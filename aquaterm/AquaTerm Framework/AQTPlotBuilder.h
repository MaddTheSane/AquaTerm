//
//  AQTPlotBuilder.h
//  AquaTerm
//
//  Created by Per Persson on Sat Aug 16 2003.
//  Copyright (c) 2003-2012 The AquaTerm Team. All rights reserved.
//

#ifndef __AQUATERM_AQTPLOTBUILDER_H__
#define __AQUATERM_AQTPLOTBUILDER_H__

#import <Foundation/Foundation.h>
#import <AquaTerm/AQTGraphic.h>
#import <AquaTerm/AQTImage.h>
#import <AquaTerm/AQTPath.h>
#import <AquaTerm/AQTClientProtocol.h>
#include <AquaTerm/aquaterm.h>

NS_ASSUME_NONNULL_BEGIN

/// This is the default colormap size
#define AQT_COLORMAP_SIZE 256

// This is the maximum practically useable path length due to the way Quartz renders a path
// FIXME: establish some "optimal" value
#define MAX_POLYLINE_POINTS 64
#define MAX_POLYGON_POINTS 256

@class AQTModel, AQTColorMap;

/**
 * `AQTClientManager` is the main controller class present in AquaTerm.framework, a shared instance
 * is used (and instantiated) by ``AQTAdapter``.
 *
 * When the client opens a new plot, the request is forwarded from `AQTAdapter` to `AQTClientManager`
 * which sends a message to AquaTerm (after launching it if it is not running) requesting a new plot. AquaTerm
 * instantiates an object of class `AQTPlot` and replies with a reference to the newly instantiated `AQTPlot`
 * object. `AQTClientManager` then instantiates a corresponding `AQTPlotBuilder` and returns a
 * reference to AQTAdapter which will forward all drawing related messages to it. Thus, there is a one-to-one
 * relationship between AQTPlotBuilder (in AquaTerm.framework) and `AQTPlot` (in AquaTerm).
 *
 * It also implements the methods in protocol `AQTEventProtocol` in order to receive event from a plot window, see ``AQTEventProtocol``.
 */
@interface AQTPlotBuilder : NSObject
{
  AQTModel *_model;	/**< The graph currently being built */
  AQTColor _color;	/**< Currently selected color */
  NSString *_fontName;	/**< Currently selected font */
  CGFloat _fontSize;	/**< Currently selected fontsize [pt] */
  CGFloat _linewidth;	/**< Currently selected linewidth [pt] */
  AQTLineCapStyle _capStyle; /**< Currently selected linecap style */
  NSPoint _polylinePoints[MAX_POLYLINE_POINTS];	/**< A cache for coalescing connected line segments into a single path */
  int32_t _polylinePointCount;	/**< The current number of points in \c _polylinePoints */
  NSPoint _polygonPoints[MAX_POLYGON_POINTS];	/**< A cache for coalescing connected line segments into a single path */
  int32_t _polygonPointCount;	/**< The current number of points in \c _polylinePoints */
  BOOL _hasSize; /**< A flag to indicate that size has been set at least once */
  BOOL _modelIsDirty;	/**< A flag indicating that AquaTerm has not been updated with the latest info */
  AQTAffineTransformStruct _transform;
  AQTColorMap *_colormap;
  BOOL _hasPattern; /**< Current pattern state */
  float _pattern[MAX_PATTERN_COUNT]; /**< Currently selected dash pattern */
  int32_t _patternCount;   /**< Currently selected dash count */
  CGFloat _patternPhase; /**< Currently selected dash phase */
  NSRect _clipRect;
  BOOL _isClipped;
}

/** \name Acessors
 @{ */

/// A flag indicating that AquaTerm has not been updated with the latest info
@property (readonly) BOOL modelIsDirty;
/// The graph currently being built
@property (readonly, retain) AQTModel *model;
@property NSSize size;
@property (copy) NSString *title;

/**
 @}
 \name Clip rect, applies to all objects
 @{ */

@property (nonatomic) NSRect clipRect;
- (void)setClipRect:(NSRect)clip;
- (void)setDefaultClipRect;

/**
 @}
 Color handling
 @{ */

/// Currently selected color
@property (nonatomic) AQTColor color;
/// Currently selected background color
@property AQTColor backgroundColor;

- (void)takeColorFromColormapEntry:(int32_t)index;
- (void)takeBackgroundColorFromColormapEntry:(int32_t)index;

@property (readonly) int32_t colormapSize;
- (void)setColor:(AQTColor)newColor forColormapEntry:(int32_t)entryIndex;
- (AQTColor)colorForColormapEntry:(int32_t)entryIndex;

/**
 @}
 \name Text handling
 @{ */

/// Currently selected font name
@property (copy) NSString* fontName;
/// Currently selected fontsize (pt)
@property CGFloat fontSize;

- (void)addLabel:(id)text position:(NSPoint)pos angle:(CGFloat)angle shearAngle:(CGFloat)shearAngle justification:(AQTAlign)just;

/**
 @}
 \name Line handling
 @{ */

/// Currently selected linewidth [pt]
@property (nonatomic) CGFloat lineWidth;

- (void)setLinestylePattern:(const float * __counted_by(newCount) __noescape)newPattern count:(int32_t)newCount phase:(CGFloat)newPhase;
- (void)setLinestyleSolid;
/// Currently selected linecap style
@property (nonatomic) AQTLineCapStyle lineCapStyle;

- (void)setLineCapStyle:(AQTLineCapStyle)capStyle;
- (void)moveToPoint:(NSPoint)point;  // AQTPath
- (void)addLineToPoint:(NSPoint)point;  // AQTPath
- (void)addPolylineWithPoints:(const NSPointArray __counted_by(pc) __noescape)points pointCount:(int32_t)pc;

/**
 @}
 \name Filled areas
 @{ */

- (void)moveToVertexPoint:(NSPoint)point;
- (void)addEdgeToPoint:(NSPoint)point; 
- (void)addPolygonWithPoints:(const NSPointArray __counted_by(pc) __noescape)points pointCount:(int32_t)pc; // AQTPatch
- (void)addFilledRect:(NSRect)aRect;

/**
 @}
 \name Image handling
 @{ */

@property AQTAffineTransformStruct imageTransform;
- (void)addImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize bounds:(NSRect)destBounds; // AQTPicture
- (void)addTransformedImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize clipRect:(NSRect)destBounds; // AQTImage
- (void)addTransformedImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize; // AQTImage

- (BOOL)addImageWithBitmapData:(NSData *)bitmap size:(NSSize)bitmapSize bounds:(NSRect)destBounds; // AQTPicture
- (BOOL)addImageWithRGBABitmapData:(NSData *)bitmap size:(NSSize)bitmapSize bounds:(NSRect)destBounds;
- (BOOL)addImageWithImageData:(NSData *)bitmap size:(NSSize)bitmapSize bounds:(NSRect)destBounds;

/**
 @}
 \name Misc.
 @{ */

- (void)removeAllParts;

/**
 @}
 \name Deprecated
 @{ */

/**
 * Deprecated way of setting line width: use ``lineWidth`` setter instead.
 */
- (void)setLinewidth:(float)newLinewidth __API_DEPRECATED_WITH_REPLACEMENT("-setLineWidth:", macos(10.4, 10.9));
/**
 * Deprecated way of setting a font name: use ``fontName`` setter instead.
 */
- (void)setFontname:(NSString *)newFontname __API_DEPRECATED_WITH_REPLACEMENT("-setFontName:", macos(10.4, 10.9));
/**
 * Deprecated way of setting font size: use ``fontSize`` setter instead.
 */
- (void)setFontsize:(float)newFontsize __API_DEPRECATED_WITH_REPLACEMENT("-setFontSize:", macos(10.4, 10.9));

/**
 @} */
@end

NS_ASSUME_NONNULL_END

#endif
