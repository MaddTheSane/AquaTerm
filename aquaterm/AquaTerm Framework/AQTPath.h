//
//  AQTPath.h
//  AquaTerm
//
//  Created by ppe on Wed May 16 2001.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AquaTerm/aquaterm.h>
#import <AquaTerm/AQTGraphic.h>

NS_ASSUME_NONNULL_BEGIN

/** This balances the fixed size of the objects vs. the need for dynamic allocation of storage. */
#define STATIC_POINT_STORAGE 24

#define MAX_PATTERN_COUNT 8
// FIXME: Base actual number on tests
// FIXME: Define AQTFarAwayPoint to separate disjoint line segments that otherwise have the same attributes?.
@interface AQTPath : AQTGraphic 
{
   NSPointArray path;
   NSPoint staticPathStore[STATIC_POINT_STORAGE];
   NSPointArray dynamicPathStore;
   int32_t pointCount;
   CGFloat linewidth;
   AQTLineCapStyle lineCapStyle;
   BOOL isFilled;
   BOOL hasPattern;
   float pattern[MAX_PATTERN_COUNT];
   int32_t patternCount;
   CGFloat patternPhase;
}

- (instancetype)init;

/*!
 * A leaf object class representing an actual item in the plot.
 *
 * Since the app is a viewer we do three things with the object:
 * create (once), draw (any number of times) and (eventually) dispose of it.
 */
- (instancetype)initWithPoints:(nullable const NSPointArray)points pointCount:(int32_t)pointCount NS_DESIGNATED_INITIALIZER;

/// Current linewidth in points
@property CGFloat lineWidth;

@property AQTLineCapStyle lineCapStyle;
@property (getter=isFilled) BOOL filled;
@property (readonly) BOOL hasPattern;

/*! Set the line style to pattern style.
 
 The linestyle is specified
 as a pattern, an array of at most 8 floats, where even positions correspond to dash-lengths and odd positions
 correspond to gap-lengths. To produce e.g. a dash-dotted line, use the pattern `{4.0, 2.0, 1.0, 2.0}`. */
- (void)setLinestylePattern:(nullable const float *)newPattern count:(int32_t)newCount phase:(CGFloat)newPhase;

/**
 * Deprecated way of setting the ``lineWidth`` property.
 *
 * Use the `lineWidth` property or `-setLineWidth:` instead.
 */
- (void)setLinewidth:(float)lw __API_DEPRECATED_WITH_REPLACEMENT("-setLineWidth:", macos(10.4, 10.9));

/**
 * Deprecated way of setting the ``filled`` property.
 *
 * Use the `filled` property or `-setFilled:` instead.
 */
- (void)setIsFilled:(BOOL)newFill __API_DEPRECATED_WITH_REPLACEMENT("-setFilled:", macos(10.4, 10.9));
@end

NS_ASSUME_NONNULL_END
