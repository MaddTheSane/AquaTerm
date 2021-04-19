//
//  AQTImage.m
//  AquaTerm
//
//  Created by Per Persson on Tue Feb 05 2002.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#import "AQTImage.h"
#import "ARCBridge.h"

@interface AQTImage ()
-(instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;
@end

@implementation AQTImage
@synthesize transform;
@synthesize fitBounds;
@synthesize bitmapSize;
@synthesize bitmap;
/*
- (id)initWithContentsOfFile:(NSString *)filename
{
  if (self = [super init])
  {
    image = [[NSImage alloc] initWithContentsOfFile:filename];
  }
  return self;
}
*/

- (instancetype)init
{
  static const char whiteChars[] = {0,0,0};
  return [self initWithBitmap:whiteChars size:NSMakeSize(1, 1) bounds:NSMakeRect(0, 0, 1, 1)];
}

- (instancetype)initWithBitmap:(const char *)bytes size:(NSSize)size bounds:(NSRect)bounds
{
  if (self = [super init])
  {
    _bounds = bounds;
    bitmapSize = size;
    bitmap = [[NSData alloc] initWithBytes:bytes length:3 * (NSInteger)size.width * (NSInteger)size.height];  // 3 bytes/sample
    // Identity matrix
    transform.m11 = 1.0;
    transform.m22 = 1.0;
    fitBounds = YES;
  }
  return self;
}

- (instancetype)initWithBitmapData:(NSData *)bytes size:(NSSize)size bounds:(NSRect)bounds
{
  // first, make sure the data is big enough:
  NSInteger minSize = 3 * (NSInteger)size.width * (NSInteger)size.height;
  if (bytes.length < minSize) {
    self = [self init];
    RELEASEOBJ(self);
    // Error out if it isn't.
    return nil;
  }
  if (self = [self initWithBitmap:bytes.bytes size:size bounds:bounds]) {
    
  }
  return self;
}

#if !__has_feature(objc_arc)
-(void)dealloc
{
  [bitmap release];
  [super dealloc];
}
#endif

#define AQTImageBitmapKey @"Bitmap"
#define AQTImageBitmapSizeKey @"BitmapSize"
#define AQTImageTransformKey @"Transform"
#define AQTImageFitBoundsKey @"FitBounds"

+ (BOOL)supportsSecureCoding
{
  return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  [super encodeWithCoder:coder];
  [coder encodeObject:bitmap forKey:AQTImageBitmapKey];
  [coder encodeSize:bitmapSize forKey:AQTImageBitmapSizeKey];
  [coder encodeObject:[NSValue value:&transform withObjCType:@encode(AQTAffineTransformStruct)] forKey:AQTImageTransformKey];
  [coder encodeBool:fitBounds forKey:AQTImageFitBoundsKey];
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
  if (self = [super initWithCoder:coder]) {
    if (coder.allowsKeyedCoding && [coder containsValueForKey:AQTImageTransformKey]) {
      bitmap = RETAINOBJ([coder decodeObjectOfClass:[NSData class] forKey:AQTImageBitmapKey]);
      bitmapSize = [coder decodeSizeForKey:AQTImageBitmapSizeKey];
      NSValue * tmpVal = [coder decodeObjectOfClass:[NSValue class] forKey:AQTImageTransformKey];
      [tmpVal getValue:&transform];
      fitBounds = [coder decodeBoolForKey:AQTImageFitBoundsKey];
    } else {
      AQTRect r;
      AQTSize s;
      
      bitmap = RETAINOBJ([coder decodeObject]);
      [coder decodeValueOfObjCType:@encode(AQTSize) at:&s];
      bitmapSize.width = s.width; bitmapSize.height = s.height;
      [coder decodeValueOfObjCType:@encode(AQTRect) at:&r];
      _bounds.origin.x = r.origin.x; _bounds.origin.y = r.origin.y;
      _bounds.size.width = r.size.width; _bounds.size.height = r.size.height;
      [coder decodeValueOfObjCType:@encode(AQTAffineTransformStruct) at:&transform];
      [coder decodeValueOfObjCType:@encode(BOOL) at:&fitBounds];
    }
  }
  return self;
}

- (void)setTransform:(AQTAffineTransformStruct)newTransform
{
  transform = newTransform;
  fitBounds = NO;
}

@end
