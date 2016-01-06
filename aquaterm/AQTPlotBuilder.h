//
//  AQTPlotBuilder.h
//  AquaTerm
//
//  Created by Per Persson on Sat Aug 16 2003.
//  Copyright (c) 2003-2012 The AquaTerm Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AQTGraphic.h"
#import "AQTImage.h"
#import "AQTPath.h"
#import "AQTClientProtocol.h"
#include "aquaterm.h"

// This is the default colormap size
#define AQT_COLORMAP_SIZE 256

// This is the maximum practically useable path length due to the way Quartz renders a path
// FIXME: establish some "optimal" value
#define MAX_POLYLINE_POINTS 64
#define MAX_POLYGON_POINTS 256

@class AQTModel, AQTColorMap;
@interface AQTPlotBuilder : NSObject
{
  AQTModel *_model;	/*" The graph currently being built "*/
  AQTColor _color;	/*" Currently selected color "*/
  NSString *_fontName;	/*" Currently selected font "*/
  CGFloat _fontSize;	/*" Currently selected fontsize [pt]"*/
  CGFloat _linewidth;	/*" Currently selected linewidth [pt] "*/
  AQTLineCapStyle _capStyle; /*" Currently selected linecap style "*/
  NSPoint _polylinePoints[MAX_POLYLINE_POINTS];	/*" A cache for coalescing connected line segments into a single path "*/
  int32_t _polylinePointCount;	/*" The current number of points in _polylinePoints"*/
  NSPoint _polygonPoints[MAX_POLYGON_POINTS];	/*" A cache for coalescing connected line segments into a single path "*/
  int32_t _polygonPointCount;	/*" The current number of points in _polylinePoints"*/
  BOOL _hasSize; /*" A flag to indicate that size has been set at least once "*/
  BOOL _modelIsDirty;	/*" A flag indicating that AquaTerm has not been updated with the latest info "*/
  AQTAffineTransformStruct _transform;
  AQTColorMap *_colormap;
  BOOL _hasPattern; /*" Current pattern state "*/
  float _pattern[MAX_PATTERN_COUNT]; /*" Currently selected dash pattern "*/
  int32_t _patternCount;   /*" Currently selected dash count "*/
  CGFloat _patternPhase; /*" Currently selected dash phase "*/
  NSRect _clipRect;
  BOOL _isClipped;
}

/*" Acessors "*/
@property (readonly) BOOL modelIsDirty;
@property (readonly, retain) AQTModel *model;
@property NSSize size;
@property (copy) NSString *title;

   /*" Clip rect, applies to all objects "*/
- (void)setClipRect:(NSRect)clip;
- (void)setDefaultClipRect;

  /*" Color handling "*/
@property AQTColor color;
@property AQTColor backgroundColor;

- (void)takeColorFromColormapEntry:(int32_t)index;
- (void)takeBackgroundColorFromColormapEntry:(int32_t)index;

@property (readonly) int32_t colormapSize;
- (void)setColor:(AQTColor)newColor forColormapEntry:(int32_t)entryIndex;
- (AQTColor)colorForColormapEntry:(int32_t)entryIndex;

  /*" Text handling "*/
- (void)setFontname:(NSString *)newFontname DEPRECATED_ATTRIBUTE;
- (void)setFontsize:(float)newFontsize DEPRECATED_ATTRIBUTE;
@property (copy) NSString* fontName;
@property CGFloat fontSize;
- (void)addLabel:(id)text position:(NSPoint)pos angle:(CGFloat)angle shearAngle:(CGFloat)shearAngle justification:(AQTAlign)just;

  /*" Line handling "*/
- (void)setLinewidth:(float)newLinewidth DEPRECATED_ATTRIBUTE;
@property (nonatomic) CGFloat lineWidth;
- (void)setLinestylePattern:(float *)newPattern count:(int32_t)newCount phase:(float)newPhase;
- (void)setLinestyleSolid;
@property (nonatomic) AQTLineCapStyle lineCapStyle;
- (void)setLineCapStyle:(AQTLineCapStyle)capStyle;
- (void)moveToPoint:(NSPoint)point;  // AQTPath
- (void)addLineToPoint:(NSPoint)point;  // AQTPath
- (void)addPolylineWithPoints:(NSPoint *)points pointCount:(int32_t)pc;

  /*" Filled areas"*/
- (void)moveToVertexPoint:(NSPoint)point;
- (void)addEdgeToPoint:(NSPoint)point; 
- (void)addPolygonWithPoints:(NSPoint *)points pointCount:(int32_t)pc; // AQTPatch
- (void)addFilledRect:(NSRect)aRect;

  /*" Image handling "*/
- (void)setImageTransform:(AQTAffineTransformStruct)trans;
- (void)addImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize bounds:(NSRect)destBounds; // AQTImage
- (void)addTransformedImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize clipRect:(NSRect)destBounds;
- (void)addTransformedImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize;

   /*" Misc. "*/
- (void)removeAllParts;
@end
