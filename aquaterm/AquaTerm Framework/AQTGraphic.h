//
//  AQTGraphic.h
//  AquaTerm
//
//  Created by ppe on Wed May 16 2001.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AQTModel;

/** \brief Color struct used by AquaTerm.
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
} AQTColor;

/** \brief Architecture-independant NSPoint.
 */
typedef struct _AQTPoint {
  float x;
  float y;
} AQTPoint;

/** \brief Architecture-independant size.
 */
typedef struct _AQTSize {
  float width;
  float height;
} AQTSize;

/** \brief Architecture-independant rect.
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

/*! \brief Set the \c clipped property.
 \deprecated Use the \c clipped property or \c -setClipped: instead.
 */
- (void)setIsClipped:(BOOL)newClip DEPRECATED_MSG_ATTRIBUTE("Use the clipped property") NS_SWIFT_UNAVAILABLE("Use the .clipped property");

/** @} */

@end
