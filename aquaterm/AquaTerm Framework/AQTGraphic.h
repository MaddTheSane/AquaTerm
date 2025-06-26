//
//  AQTGraphic.h
//  AquaTerm
//
//  Created by ppe on Wed May 16 2001.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#ifndef __AQUATERM_AQTGRAPHIC_H__
#define __AQUATERM_AQTGRAPHIC_H__

#import <Foundation/Foundation.h>
#include <CoreGraphics/CoreGraphics.h>

@class AQTModel;

/**
 * Color struct used by AquaTerm.
 */
typedef struct _AQTColor {
   //! The red component.
   float red;
   
   //! The green component.
   float green;
   
   //! The blue component.
   float blue;
   
   //! The alpha component.
   float alpha;
} CG_BOXABLE AQTColor;

/**
 * Architecture-independant NSPoint.
 */
typedef struct _AQTPoint {
  float x;
  float y;
} AQTPoint;

/**
 * Architecture-independant size.
 */
typedef struct _AQTSize {
  float width;
  float height;
} AQTSize;

/**
 * Architecture-independant rect.
 */
typedef struct _AQTRect {
  AQTPoint origin;
  AQTSize size;
} AQTRect;

/// An abstract class to derive model objects from
/// (Overkill at present but could come in handy if the app grows)
@interface AQTGraphic : NSObject <NSSecureCoding>
{
    AQTColor _color;
    NSRect _bounds;
    NSRect _clipRect;
    BOOL _isClipped;
    BOOL _shouldShowBounds;
    @protected
       id _cache;   
}
-(nonnull instancetype)init NS_DESIGNATED_INITIALIZER;
-(nullable instancetype)initWithCoder:(nonnull NSCoder *)coder NS_DESIGNATED_INITIALIZER;

/** \name accessor methods
 @{ */

@property NSRect bounds;
@property NSRect clipRect;
@property (getter=isClipped) BOOL clipped;

/**
 @}
 \name color handling
 @{ */

@property AQTColor color;

/**
 @}
 \name Deprecated
 @{ */

/*!
 * Sets the ``clipped`` property.
 * 
 * \deprecated Use the ``clipped`` property or `-setClipped:` instead.
 */
- (void)setIsClipped:(BOOL)newClip __API_DEPRECATED_WITH_REPLACEMENT("-setClipped:", macos(10.4, 10.9));

/** @} */

@end

#endif
