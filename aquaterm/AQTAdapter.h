//
//  AQTAdapter.h
//  AquaTerm
//
//  Created by Per Persson on Sat Jul 12 2003.
//  Copyright (c) 2003-2012 The AquaTerm Team. All rights reserved.
//

#import <Foundation/NSString.h>
#import <Foundation/NSGeometry.h>
#include "aquaterm.h"

@class AQTPlotBuilder, AQTClientManager;
@interface AQTAdapter : NSObject
{
   /*" All instance variables are private. "*/
   AQTClientManager *_clientManager;
   AQTPlotBuilder *_selectedBuilder;
   id _aqtReserved1;
   id _aqtReserved2;
}

/*" Class initialization etc."*/
- (instancetype)init;
- (instancetype)initWithServer:(id)localServer NS_DESIGNATED_INITIALIZER;
@property (copy) void (^errorBlock)(NSString *msg);
@property (copy) void (^eventBlock)(NSInteger index, NSString *event);
- (void)setErrorHandler:(void (*)(NSString *msg))fPtr;
- (void)setEventHandler:(void (*)(NSInteger index, NSString *event))fPtr;

  /*" Control operations "*/
- (void)openPlotWithIndex:(int32_t)refNum; 
- (BOOL)selectPlotWithIndex:(int32_t)refNum;
@property NSSize plotSize;
@property (copy) NSString *plotTitle;
- (void)renderPlot;
- (void)clearPlot;
- (void)closePlot;

  /*" Event handling "*/
- (void)setAcceptingEvents:(BOOL)flag;
@property (readonly, copy) NSString *lastEvent;
@property (readonly, copy) NSString *waitNextEvent; 

/*" Plotting related commands "*/

/*" Clip rect, applies to all objects "*/
- (void)setClipRect:(NSRect)clip;
- (void)setDefaultClipRect;

/*" Colormap (utility) "*/
@property (readonly) int32_t colormapSize;
- (void)setColormapEntry:(int32_t)entryIndex red:(float)r green:(float)g blue:(float)b alpha:(float)a;
- (void)getColormapEntry:(int32_t)entryIndex red:(float *)r green:(float *)g blue:(float *)b alpha:(float *)a;
- (void)setColormapEntry:(int32_t)entryIndex red:(float)r green:(float)g blue:(float)b;
- (void)getColormapEntry:(int32_t)entryIndex red:(float *)r green:(float *)g blue:(float *)b;
- (void)takeColorFromColormapEntry:(int32_t)index;
- (void)takeBackgroundColorFromColormapEntry:(int32_t)index;

  /*" Color handling "*/
- (void)setColorRed:(float)r green:(float)g blue:(float)b alpha:(float)a;
- (void)setBackgroundColorRed:(float)r green:(float)g blue:(float)b alpha:(float)a;
- (void)getColorRed:(float *)r green:(float *)g blue:(float *)b alpha:(float *)a;
- (void)getBackgroundColorRed:(float *)r green:(float *)g blue:(float *)b alpha:(float *)a;
- (void)setColorRed:(float)r green:(float)g blue:(float)b;
- (void)setBackgroundColorRed:(float)r green:(float)g blue:(float)b;
- (void)getColorRed:(float *)r green:(float *)g blue:(float *)b;
- (void)getBackgroundColorRed:(float *)r green:(float *)g blue:(float *)b;

  /*" Text handling "*/
@property (copy) NSString *fontName;
@property CGFloat fontSize;
- (void)setFontname:(NSString *)newFontname DEPRECATED_ATTRIBUTE;
- (void)setFontsize:(float)newFontsize DEPRECATED_ATTRIBUTE;
- (void)addLabel:(id)text atPoint:(NSPoint)pos;
- (void)addLabel:(id)text atPoint:(NSPoint)pos angle:(float)angle align:(AQTAlign)just;
- (void)addLabel:(id)text atPoint:(NSPoint)pos angle:(float)angle shearAngle:(float)shearAngle align:(AQTAlign)just;

  /*" Line handling "*/
- (void)setLinewidth:(float)newLinewidth DEPRECATED_ATTRIBUTE;
@property CGFloat lineWidth;
- (void)setLinestylePattern:(float *)newPattern count:(int32_t)newCount phase:(float)newPhase;
- (void)setLinestyleSolid;
@property AQTLineCapStyle lineCapStyle;
- (void)setLineCapStyle:(AQTLineCapStyle)capStyle;
- (void)moveToPoint:(NSPoint)point;  
- (void)addLineToPoint:(NSPoint)point; 
- (void)addPolylineWithPoints:(NSPoint *)points pointCount:(int32_t)pc;

  /*" Rect and polygon handling"*/
- (void)moveToVertexPoint:(NSPoint)point;
- (void)addEdgeToVertexPoint:(NSPoint)point; 
- (void)addPolygonWithVertexPoints:(NSPoint *)points pointCount:(int32_t)pc;
- (void)addFilledRect:(NSRect)aRect;
- (void)eraseRect:(NSRect)aRect;

  /*" Image handling "*/
- (void)setImageTransformM11:(float)m11 m12:(float)m12 m21:(float)m21 m22:(float)m22 tX:(float)tX tY:(float)tY;
- (void)resetImageTransform;
/// Add a bitmap image of size bitmapSize scaled to fit destBounds, does <i>not</i> apply transform. Bitmap format is 24bits per pixel in sequence RGBRGB... with 8 bits per color.
- (void)addImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize bounds:(NSRect)destBounds; 
/// Deprecated, use \c addTransformedImageWithBitmap:size: instead. Add a bitmap image of size bitmapSize <i>honoring</i> transform, transformed image is clipped to destBounds. Bitmap format is 24bits per pixel in sequence RGBRGB...  with 8 bits per color.
- (void)addTransformedImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize clipRect:(NSRect)destBounds DEPRECATED_ATTRIBUTE;
- (void)addTransformedImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize;

  /*"Private methods"*/
- (void)timingTestWithTag:(uint32_t)tag;
@end
