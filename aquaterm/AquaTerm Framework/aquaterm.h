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
#include <CoreFoundation/CFAvailability.h>

#define AQT_EVENTBUF_SIZE 128

/** Constants that specify linecap styles. */
typedef CF_ENUM(int32_t, AQTLineCapStyle) {
   AQTLineCapStyleButt = 0,
   AQTLineCapStyleRound = 1,
   AQTLineCapStyleSquare = 2,

   /*! \deprecated Use \c AQTLineCapStyleButt instead.*/
   AQTButtLineCapStyle DEPRECATED_MSG_ATTRIBUTE("Use AQTLineCapStyleButt instead") CF_SWIFT_UNAVAILABLE("Use .butt instead") = AQTLineCapStyleButt,
   
   /*! \deprecated Use \c AQTLineCapStyleRound instead.*/
   AQTRoundLineCapStyle DEPRECATED_MSG_ATTRIBUTE("Use AQTLineCapStyleRound instead") CF_SWIFT_UNAVAILABLE("Use .round instead") = AQTLineCapStyleRound,
   
   /*! \deprecated Use \c AQTLineCapStyleSquare instead.*/
   AQTSquareLineCapStyle DEPRECATED_MSG_ATTRIBUTE("Use AQTLineCapStyleSquare instead") CF_SWIFT_UNAVAILABLE("Use .square instead") = AQTLineCapStyleSquare
};

/*! Constants that specify horizontal and vertical alignment for labels. See \c addLabel:atPoint:angle:align: for definitions and use. */
typedef CF_OPTIONS(int32_t, AQTAlign) {
   /** @name Constants that specify horizontal alignment for labels.
    @{ */
   
   /** @brief Left alignment.
    */
   AQTAlignLeft = 0x00,
   
   /** @brief Horizontal center alignment.
    */
   AQTAlignCenter = 0x01,
   
   /** @brief Right alignment.
    */
   AQTAlignRight = 0x02,
   
   /** @}
    @name Constants that specify vertical alignment for labels.
    @{ */
   
   /** @brief Vertical center alignment.
    */
   AQTAlignMiddle = 0x00,
   
   /** @brief Vertical baseline alignment.
    */
   AQTAlignBaseline = 0x04,
   
   /** @brief Bottom alignment.
    */
   AQTAlignBottom = 0x08,
   
   /** @brief Top alignment.
    */
   AQTAlignTop = 0x10
   
   /** @} */
};

/** \name Class initialization etc.
 @{ */

bool aqtInit(void);
void aqtTerminate(void);

/** The event handler callback functionality should be used with caution, it may
   not be safe to use in all circumstances. It is certainly _not_ threadsafe. 
   If in doubt, use aqtWaitNextEvent() instead. */
/*!
 * @function aqtSetEventHandler
 *
 * The event handler callback functionality should be used with caution, it may
 * not be safe to use in all circumstances. It is certainly \b not threadsafe.
 * If in doubt, use \c aqtWaitNextEvent() instead.
 */
void aqtSetEventHandler(void (*func)(int ref, const char *event));

/*!
 * @function aqtSetEventBlock
 *
 * The event handler callback functionality should be used with caution, it may
 * not be safe to use in all circumstances. It is certainly \b not threadsafe.
 * If in doubt, use \c aqtWaitNextEvent() instead.
 */
void aqtSetEventBlock(void (^func)(int ref, const char *event));

/**
 @}
 \name Control operations
 @{ */

void aqtOpenPlot(int32_t refNum);
int32_t aqtSelectPlot(int32_t refNum);
void aqtSetPlotSize(float width, float height);
void aqtSetPlotTitle(const char *title);
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
void aqtGetColormapEntryRGBA(int32_t entryIndex, float *r, float *g, float *b, float *a);
void aqtSetColormapEntry(int32_t entryIndex, float r, float g, float b);
void aqtGetColormapEntry(int32_t entryIndex, float *r, float *g, float *b);
void aqtTakeColorFromColormapEntry(int32_t index);
void aqtTakeBackgroundColorFromColormapEntry(int32_t index);

/**
 @}
 \name Color handling
 @{ */

void aqtSetColorRGBA(float r, float g, float b, float a);
void aqtSetBackgroundColorRGBA(float r, float g, float b, float a);
void aqtGetColorRGBA(float *r, float *g, float *b, float *a);
void aqtGetBackgroundColorRGBA(float *r, float *g, float *b, float *a);
void aqtSetColor(float r, float g, float b);
void aqtSetBackgroundColor(float r, float g, float b);
void aqtGetColor(float *r, float *g, float *b);
void aqtGetBackgroundColor(float *r, float *g, float *b);

/**
 @}
 \name Text handling
 @{ */

void aqtSetFontname(const char *newFontname);
void aqtSetFontsize(float newFontsize);
void aqtAddLabel(const char *text, float x, float y, float angle, AQTAlign align);
void aqtAddShearedLabel(const char *text, float x, float y, float angle, float shearAngle, AQTAlign align);

/**
 @}
 \name Line handling
 @{ */

void aqtSetLinewidth(float newLinewidth);
void aqtSetLinestylePattern(float *newPattern, int32_t newCount, float newPhase);
void aqtSetLinestyleSolid(void);
void aqtSetLineCapStyle(AQTLineCapStyle capStyle);
void aqtMoveTo(float x, float y);
void aqtAddLineTo(float x, float y);
void aqtAddPolyline(float *x, float *y, int32_t pointCount);

/**
 @}
 \name Rect and polygon handling
 @{ */

void aqtMoveToVertex(float x, float y);
void aqtAddEdgeToVertex(float x, float y);
void aqtAddPolygon(float *x, float *y, int32_t pointCount);
void aqtAddFilledRect(float originX, float originY, float width, float height);
void aqtEraseRect(float originX, float originY, float width, float height);

/**
 @}
 \name Image handling
 @{ */

void aqtSetImageTransform(float m11, float m12, float m21, float m22, float tX, float tY);
void aqtResetImageTransform(void);
void aqtAddImageWithBitmap(const void *bitmap, int32_t pixWide, int32_t pixHigh, float destX, float destY, float destWidth, float destHeight);
void aqtAddTransformedImageWithBitmap(const void *bitmap, int32_t pixWide, int32_t pixHigh, float clipX, float clipY, float clipWidth, float clipHeight) DEPRECATED_ATTRIBUTE;

/**
 @}
 */

#endif
