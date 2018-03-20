//
//  AQTGraphic.h
//  AquaTerm
//
//  Created by ppe on Wed May 16 2001.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AQTModel;

typedef struct _AQTColor {
   float red;
   float green;
   float blue;
   float alpha;
} AQTColor;

typedef struct _AQTPoint {
  float x;
  float y;
} AQTPoint;

typedef struct _AQTSize {
  float width;
  float height;
} AQTSize;

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

/** color handling */
@property AQTColor color;

/** @}
 \name Deprecated
 @{ */

- (void)setIsClipped:(BOOL)newClip DEPRECATED_MSG_ATTRIBUTE("Use the clipped property") NS_SWIFT_UNAVAILABLE("Use the .clipped property");

/** @} */

@end
