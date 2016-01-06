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
-(instancetype)init NS_DESIGNATED_INITIALIZER;

/*" accessor methods "*/
@property NSRect bounds;
@property NSRect clipRect;
@property BOOL isClipped;

/*" color handling "*/
@property AQTColor color;
@end
