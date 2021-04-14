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
 \brief A leaf object class representing an actual item in the plot.
 
 Since the app is a viewer we do three things with the object:
 create (once), draw (any number of times) and (eventually) dispose of it.
 */
- (instancetype)initWithPoints:(nullable const NSPointArray)points pointCount:(int32_t)pointCount NS_DESIGNATED_INITIALIZER;

@property CGFloat lineWidth;
@property AQTLineCapStyle lineCapStyle;
@property (getter=isFilled) BOOL filled;
@property (readonly) BOOL hasPattern;
- (void)setLinestylePattern:(nullable const float *)newPattern count:(int32_t)newCount phase:(CGFloat)newPhase;

/** \deprecated Use the \c lineWidth property or \c -setLineWidth: instead.
 */
- (void)setLinewidth:(float)lw __API_DEPRECATED_WITH_REPLACEMENT("-setLineWidth:", macos(10.4, 10.9));

/** \deprecated Use the \c filled property or \c -setFilled: instead.
 */
- (void)setIsFilled:(BOOL)newFill __API_DEPRECATED_WITH_REPLACEMENT("-setFilled:", macos(10.4, 10.9));
@end

NS_ASSUME_NONNULL_END
