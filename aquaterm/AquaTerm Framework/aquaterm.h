//
//  aquaterm.h
//  AquaTerm
//
//  Created by Per Persson on Sat Jul 12 2003.
//  Copyright (c) 2003-2012 The AquaTerm team.
//

#pragma once

#ifndef __AQUATERM_AQUATERM_H__
#define __AQUATERM_AQUATERM_H__

#include <stdint.h>
#include <stdbool.h>
#if __has_include(<lifetimebound.h>)
#include <lifetimebound.h>
#else
#ifndef __noescape
#define __noescape __attribute__((noescape))
#define __lifetimebound
#define __lifetime_capture_by(X)
#endif
#endif
#if __has_include(<ptrcheck.h>)
#include <ptrcheck.h>
#ifndef __counted_by
  #error __counted_by is not defined but should be
#endif
#else
// Feature not available so define attributes to be empty to avoid breaking the build
#ifndef __single
#define __single
#define __unsafe_indexable
#define __counted_by(N)
#define __counted_by_or_null(N)
#define __sized_by(N)
#define __sized_by_or_null(N)
#define __ended_by(E)
#define __terminated_by(T)
#define __null_terminated
#define __ptrcheck_abi_assume_single()
#define __ptrcheck_abi_assume_unsafe_indexable()
#define __unsafe_forge_single(T, P) ((T)(P))
#define __unsafe_forge_terminated_by(T, P, E) ((T)(P))
#define __unsafe_forge_null_terminated(T, P) ((T)(P))
#define __array_decay_discards_count_in_parameters
#define __terminated_by_to_indexable(P) (P)
#define __unsafe_terminated_by_to_indexable(P) (P)
#define __null_terminated_to_indexable(P) (P)
#define __unsafe_null_terminated_to_indexable(P) (P)
#define __IGNORE_REST(P, ...) (P)
#define __unsafe_terminated_by_from_indexable(T, ...)                          \
  __IGNORE_REST(__VA_ARGS__, DUMMY)
#define __unsafe_null_terminated_from_indexable(...)                           \
  __unsafe_terminated_by_from_indexable(DUMMY_TYPE, __VA_ARGS__)
#define __ptrcheck_unavailable
#define __ptrcheck_unavailable_r(REPLACEMENT)
#endif
#endif
#include <AvailabilityMacros.h>
#include <CoreFoundation/CFAvailability.h>

/*!
 * The biggest value that ``aqtGetLastEvent`` and ``aqtWaitNextEvent`` will ever fill.
 */
#define AQT_EVENTBUF_SIZE 128

/** Constants that specify linecap styles. */
typedef CF_ENUM(int32_t, AQTLineCapStyle) {
   /**
    * Line does not extend beyond the endpoint.
    */
   AQTLineCapStyleButt = 0,
   /**
    * Line extends into a half-circle beyond endpoint.
    */
   AQTLineCapStyleRound = 1,
   /**
    * Line extends into a half-square beyond endpoint.
    */
   AQTLineCapStyleSquare = 2,
};

/*! Use ``AQTLineCapStyle/butt`` instead.*/
static const AQTLineCapStyle AQTButtLineCapStyle __API_DEPRECATED_WITH_REPLACEMENT("AQTLineCapStyleButt", macos(10.4, 10.9)) = AQTLineCapStyleButt;

/*! Use ``AQTLineCapStyle/round`` instead.*/
static const AQTLineCapStyle AQTRoundLineCapStyle __API_DEPRECATED_WITH_REPLACEMENT("AQTLineCapStyleRound", macos(10.4, 10.9)) = AQTLineCapStyleRound;

/*! Use ``AQTLineCapStyle/square`` instead.*/
static const AQTLineCapStyle AQTSquareLineCapStyle __API_DEPRECATED_WITH_REPLACEMENT("AQTLineCapStyleSquare", macos(10.4, 10.9)) = AQTLineCapStyleSquare;

/*! Constants that specify horizontal and vertical alignment for labels. See ``AQTAdapter/addLabel:atPoint:angle:shearAngle:align:`` for definitions and use. */
typedef CF_OPTIONS(int32_t, AQTAlign) {
   /** @name Constants that specify horizontal alignment for labels.
    @{ */
   
   /**
    * Left alignment.
    */
   AQTAlignLeft = 0x00,
   
   /**
    * Horizontal center alignment.
    */
   AQTAlignCenter = 0x01,
   
   /**
    * Right alignment.
    */
   AQTAlignRight = 0x02,
   
   /** @}
    @name Constants that specify vertical alignment for labels.
    @{ */
   
   /**
    * Vertical center alignment.
    */
   AQTAlignMiddle = 0x00,
   
   /**
    * Vertical baseline alignment.
    */
   AQTAlignBaseline = 0x04,
   
   /**
    * Bottom alignment.
    */
   AQTAlignBottom = 0x08,
   
   /**
    * Top alignment.
    */
   AQTAlignTop = 0x10
   
   /** @} */
};

/** \name Class initialization etc.
 @{ */

/*!
 * Initialize the AquaTerm C functions.
 */
bool aqtInit(void);

/*!
 * Deinitializes the AquaTerm C functions.
 */
void aqtTerminate(void);

/** The event handler callback functionality should be used with caution, it may
   not be safe to use in all circumstances. It is certainly _not_ thread-safe.
   If in doubt, use aqtWaitNextEvent() instead. */
/*!
 * aqtSetEventHandler
 *
 * The event handler callback functionality should be used with caution, it may
 * not be safe to use in all circumstances. It is certainly __not__ thread-safe.
 * If in doubt, use ``aqtWaitNextEvent`` instead.
 */
void aqtSetEventHandler(void (*func)(int ref, const char *event));

/*!
 * @function aqtSetEventBlock
 *
 * The event handler callback functionality should be used with caution, it may
 * not be safe to use in all circumstances. It is certainly **not** thread-safe.
 * If in doubt, use ``aqtWaitNextEvent`` instead.
 */
void aqtSetEventBlock(void (^func)(int ref, const char *event));

/**
 @}
 \name Control operations
 @{ */

void aqtOpenPlot(int32_t refNum);
int32_t aqtSelectPlot(int32_t refNum);
void aqtSetPlotSize(float width, float height);
/**
 * Set the window name.
 *
 * Attempts to read it as UTF-8, but falls back to ISO Latin 1 if UTF-8 reading fails,
 * changes the title to "Untitled" if ISO Latin 1 decoding fails.
 */
void aqtSetPlotTitle(const char *__null_terminated title);
void aqtRenderPlot(void);
void aqtClearPlot(void);
void aqtClosePlot(void);

/**
 @}
 \name Event handling
 @{ */

void aqtSetAcceptingEvents(bool flag);
int32_t aqtGetLastEvent(char *buffer);
int32_t aqtWaitNextEvent(char *buffer);

/*" Plotting related commands "*/

/**
 @}
 \name Clip rect, applies to all objects
 @{ */

void aqtSetClipRect(float originX, float originY, float width, float height);
void aqtSetDefaultClipRect(void);

/**
 @}
 \name Colormap (utility)
 @{ */

int32_t aqtColormapSize(void);
void aqtSetColormapEntryRGBA(int32_t entryIndex, float r, float g, float b, float a);
void aqtGetColormapEntryRGBA(int32_t entryIndex, float *__single r, float *__single g, float *__single b, float *__single a);
void aqtSetColormapEntry(int32_t entryIndex, float r, float g, float b);
void aqtGetColormapEntry(int32_t entryIndex, float *__single r, float *__single g, float *__single b);
void aqtTakeColorFromColormapEntry(int32_t index);
void aqtTakeBackgroundColorFromColormapEntry(int32_t index);

/**
 @}
 \name Color handling
 @{ */

void aqtSetColorRGBA(float r, float g, float b, float a);
void aqtSetBackgroundColorRGBA(float r, float g, float b, float a);
void aqtGetColorRGBA(float *__single r, float *__single g, float *__single b, float *__single a);
void aqtGetBackgroundColorRGBA(float *__single r, float *__single g, float *__single b, float *__single a);
void aqtSetColor(float r, float g, float b);
void aqtSetBackgroundColor(float r, float g, float b);
void aqtGetColor(float *__single r, float *__single g, float *__single b);
void aqtGetBackgroundColor(float *__single r, float *__single g, float *__single b);

/**
 @}
 \name Text handling
 @{ */

void aqtSetFontname(const char *newFontname);
void aqtSetFontsize(float newFontsize);
void aqtAddLabel(const char *__null_terminated text, float x, float y, float angle, AQTAlign align);
void aqtAddShearedLabel(const char *__null_terminated text, float x, float y, float angle, float shearAngle, AQTAlign align);

/**
 @}
 \name Line handling
 @{ */

void aqtSetLinewidth(float newLinewidth);
void aqtSetLinestylePattern(float *__counted_by(newCount) newPattern __noescape, int32_t newCount, float newPhase);
void aqtSetLinestyleSolid(void);
void aqtSetLineCapStyle(AQTLineCapStyle capStyle);
void aqtMoveTo(float x, float y);
void aqtAddLineTo(float x, float y);
void aqtAddPolyline(float *__counted_by(pointCount) x __noescape, float *__counted_by(pointCount) y __noescape, int32_t pointCount);

/**
 @}
 \name Rect and polygon handling
 @{ */

void aqtMoveToVertex(float x, float y);
void aqtAddEdgeToVertex(float x, float y);
void aqtAddPolygon(float *__counted_by(pointCount) x __noescape, float *__counted_by(pointCount) y __noescape, int32_t pointCount);
void aqtAddFilledRect(float originX, float originY, float width, float height);
void aqtEraseRect(float originX, float originY, float width, float height);

/**
 @}
 \name Image handling
 @{ */

void aqtSetImageTransform(float m11, float m12, float m21, float m22, float tX, float tY);
void aqtResetImageTransform(void);
void aqtAddImageWithBitmap(const void *bitmap, int32_t pixWide, int32_t pixHigh, float destX, float destY, float destWidth, float destHeight);
void aqtAddImageWithRGBABitmap(const void *bitmap, int32_t pixWide, int32_t pixHigh, float destX, float destY, float destWidth, float destHeight);
/**
 * Deprecated, do not use.
 *
 * @deprecated Deprecated.
 */
void aqtAddTransformedImageWithBitmap(const void *bitmap, int32_t pixWide, int32_t pixHigh, float clipX, float clipY, float clipWidth, float clipHeight) DEPRECATED_ATTRIBUTE;

/**
 @}
 */

#endif
