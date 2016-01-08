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

/*" Constants that specify linecap styles. "*/
typedef CF_ENUM(int32_t, AQTLineCapStyle) {
   AQTLineCapStyleButt = 0,
   AQTLineCapStyleRound = 1,
   AQTLineCapStyleSquare = 2
};

/*" Constants that specify horizontal and vertical alignment for labels. See #addLabel:atPoint:angle:align: for definitions and use."*/
typedef CF_OPTIONS(int32_t, AQTAlign) {
   /*" Constants that specify horizontal alignment for labels. "*/
   AQTAlignLeft = 0x00,
   AQTAlignCenter = 0x01,
   AQTAlignRight = 0x02,
   /* Constants that specify vertical alignment for labels. */
   AQTAlignMiddle = 0x00,
   AQTAlignBaseline = 0x04,
   AQTAlignBottom = 0x08,
   AQTAlignTop = 0x10
};

/*" Class initialization etc."*/
bool aqtInit(void);
void aqtTerminate(void);
/* The event handler callback functionality should be used with caution, it may 
   not be safe to use in all circumstances. It is certainly _not_ threadsafe. 
   If in doubt, use aqtWaitNextEvent() instead. */
void aqtSetEventHandler(void (*func)(int ref, const char *event));

void aqtSetEventBlock(void (^func)(int ref, const char *event));

/*" Control operations "*/
void aqtOpenPlot(int32_t refNum);
int32_t aqtSelectPlot(int32_t refNum);
void aqtSetPlotSize(float width, float height);
void aqtSetPlotTitle(const char *title);
void aqtRenderPlot(void);
void aqtClearPlot(void);
void aqtClosePlot(void);

/*" Event handling "*/
void aqtSetAcceptingEvents(bool flag);
int32_t aqtGetLastEvent(char *buffer);
int32_t aqtWaitNextEvent(char *buffer);

/*" Plotting related commands "*/

/*" Clip rect, applies to all objects "*/
void aqtSetClipRect(float originX, float originY, float width, float height);
void aqtSetDefaultClipRect(void);

/*" Colormap (utility  "*/
int32_t aqtColormapSize(void);
void aqtSetColormapEntryRGBA(int32_t entryIndex, float r, float g, float b, float a);
void aqtGetColormapEntryRGBA(int32_t entryIndex, float *r, float *g, float *b, float *a);
void aqtSetColormapEntry(int32_t entryIndex, float r, float g, float b);
void aqtGetColormapEntry(int32_t entryIndex, float *r, float *g, float *b);
void aqtTakeColorFromColormapEntry(int32_t index);
void aqtTakeBackgroundColorFromColormapEntry(int32_t index);

/*" Color handling "*/
void aqtSetColorRGBA(float r, float g, float b, float a);
void aqtSetBackgroundColorRGBA(float r, float g, float b, float a);
void aqtGetColorRGBA(float *r, float *g, float *b, float *a);
void aqtGetBackgroundColorRGBA(float *r, float *g, float *b, float *a);
void aqtSetColor(float r, float g, float b);
void aqtSetBackgroundColor(float r, float g, float b);
void aqtGetColor(float *r, float *g, float *b);
void aqtGetBackgroundColor(float *r, float *g, float *b);

/*" Text handling "*/
void aqtSetFontname(const char *newFontname);
void aqtSetFontsize(float newFontsize);
void aqtAddLabel(const char *text, float x, float y, float angle, AQTAlign align);
void aqtAddShearedLabel(const char *text, float x, float y, float angle, float shearAngle, AQTAlign align);

/*" Line handling "*/
void aqtSetLinewidth(float newLinewidth);
void aqtSetLinestylePattern(float *newPattern, int32_t newCount, float newPhase);
void aqtSetLinestyleSolid(void);
void aqtSetLineCapStyle(AQTLineCapStyle capStyle);
void aqtMoveTo(float x, float y);
void aqtAddLineTo(float x, float y);
void aqtAddPolyline(float *x, float *y, int32_t pointCount);

/*" Rect and polygon handling"*/
void aqtMoveToVertex(float x, float y);
void aqtAddEdgeToVertex(float x, float y);
void aqtAddPolygon(float *x, float *y, int32_t pointCount);
void aqtAddFilledRect(float originX, float originY, float width, float height);
void aqtEraseRect(float originX, float originY, float width, float height);

/*" Image handling "*/
void aqtSetImageTransform(float m11, float m12, float m21, float m22, float tX, float tY);
void aqtResetImageTransform(void);
void aqtAddImageWithBitmap(const void *bitmap, int32_t pixWide, int32_t pixHigh, float destX, float destY, float destWidth, float destHeight);
void aqtAddTransformedImageWithBitmap(const void *bitmap, int32_t pixWide, int32_t pixHigh, float clipX, float clipY, float clipWidth, float clipHeight) DEPRECATED_ATTRIBUTE;

/*" Deprecated constants "*/
#define AQTButtLineCapStyle AQTLineCapStyleButt
#define AQTRoundLineCapStyle AQTLineCapStyleRound
#define AQTSquareLineCapStyle AQTLineCapStyleSquare

#endif
