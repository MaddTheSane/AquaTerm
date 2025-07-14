//
//  AQTPicture.m
//  AQTFwk
//
//  Created by C.W. Betts on 4/18/21.
//  Copyright © 2021 AquaTerm Team. All rights reserved.
//

#import "AQTPicture.h"
#import "ARCBridge.h"

@interface AQTPicture ()
-(instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;
@property (readwrite, copy) NSImage *baseImage;
@end

@implementation AQTPicture
@synthesize transform;
@synthesize fitBounds;
@synthesize bitmapSize;
@synthesize baseImage;

- (instancetype)initWithImage:(NSImage*)img size:(NSSize)size bounds:(NSRect)bounds
{
   if (self = [super init]) {
      _bounds = bounds;
      if (NSEqualSizes(NSZeroSize, size)) {
         bitmapSize = img.size;
      } else {
         bitmapSize = size;
      }
      self.transform = [NSAffineTransform transform];
      self.baseImage = img;
      fitBounds = YES;
   }
   return self;
}

- (instancetype)init
{
   static const unsigned char whiteChars[] = {0,0,0};

   NSBitmapImageRep *bir = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:(unsigned char**)&whiteChars pixelsWide:1 pixelsHigh:1 bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:3 bitsPerPixel:24];
   NSImage *img = [[NSImage alloc] initWithSize:NSMakeSize(1, 1)];
   [img addRepresentation:bir];
   RELEASEOBJ(bir);
   self = [self initWithImage:img size:NSMakeSize(1, 1) bounds:NSMakeRect(0, 0, 1, 1)];
   RELEASEOBJ(img);
   return self;
}

- (nullable instancetype)initWithBitmapData:(NSData *)bytes size:(NSSize)size bounds:(NSRect)bounds
{
   // first, make sure the data is big enough:
   NSInteger minSize = 3 * (NSInteger)size.width * (NSInteger)size.height;
   if (bytes.length < minSize || NSEqualSizes(NSZeroSize, size)) {
      self = [self init];
      RELEASEOBJ(self);
      // Error out if it isn't.
      return nil;
   }

   CGDataProviderRef dataRef = CGDataProviderCreateWithCFData((CFDataRef)bytes);
   CGColorSpaceRef colrSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
   CGImageRef imgRef = CGImageCreate(size.width, size.height, 8, 24,
                                     (size_t)(size.width) * 3, colrSpace,
                                     kCGBitmapByteOrderDefault, dataRef, NULL, true,
                                     kCGRenderingIntentDefault);
   CGColorSpaceRelease(colrSpace);
   CGDataProviderRelease(dataRef);
   
   NSBitmapImageRep *bir = [[NSBitmapImageRep alloc] initWithCGImage:imgRef];
   CGImageRelease(imgRef);
   NSImage *img = [[NSImage alloc] initWithSize:size];
   [img addRepresentation:bir];
   RELEASEOBJ(bir);

   self = [self initWithImage:img size:size bounds:bounds];
   RELEASEOBJ(img);

   return self;
}

- (nullable instancetype)initWithRGBABitmapData:(NSData *)bytes size:(NSSize)size bounds:(NSRect)bounds
{
   // first, make sure the data is big enough:
   NSInteger minSize = 4 * (NSInteger)size.width * (NSInteger)size.height;
   if (bytes.length < minSize || NSEqualSizes(NSZeroSize, size)) {
      self = [self init];
      RELEASEOBJ(self);
      // Error out if it isn't.
      return nil;
   }

   CGDataProviderRef dataRef = CGDataProviderCreateWithCFData((CFDataRef)bytes);
   CGColorSpaceRef colrSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
   CGImageRef imgRef = CGImageCreate(size.width, size.height, 8, 32,
                                     (size_t)(size.width) * 4, colrSpace,
                                     kCGBitmapByteOrderDefault | kCGImageAlphaLast, dataRef, NULL, true,
                                     kCGRenderingIntentDefault);
   CGColorSpaceRelease(colrSpace);
   CGDataProviderRelease(dataRef);

   NSBitmapImageRep *bir = [[NSBitmapImageRep alloc] initWithCGImage:imgRef];
   CGImageRelease(imgRef);
   NSImage *img = [[NSImage alloc] initWithSize:size];
   [img addRepresentation:bir];
   RELEASEOBJ(bir);

   self = [self initWithImage:img size:size bounds:bounds];
   RELEASEOBJ(img);

   return self;

}

- (nullable instancetype)initWithImageData:(NSData * _Nonnull)imageData size:(NSSize)size bounds:(NSRect)bounds
{
   NSImage *img = [[NSImage alloc] initWithData:imageData];
   if (!img) {
      self = [self init];
      RELEASEOBJ(self);
      return nil;
   }
   
   NSSize passedSize = NSEqualSizes(size, NSZeroSize) ? img.size : size;
   
   self = [self initWithImage:img size:passedSize bounds:bounds];
   RELEASEOBJ(img);
   
   return self;
}


#define AQTPictureBaseImageKey @"BaseImage"
#define AQTPictureBitmapSizeKey @"BitmapSize"
#define AQTPictureTransformKey @"Transform"
#define AQTPictureTransformKey1 @"Transform.m11"
#define AQTPictureTransformKey2 @"Transform.m12"
#define AQTPictureTransformKey3 @"Transform.m21"
#define AQTPictureTransformKey4 @"Transform.m22"
#define AQTPictureTransformKey5 @"Transform.tX"
#define AQTPictureTransformKey6 @"Transform.tY"
#define AQTPictureFitBoundsKey @"FitBounds"

+ (BOOL)supportsSecureCoding
{
   return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
   if (self = [super initWithCoder:coder]) {
      NSAssert([coder allowsKeyedCoding], @"No app should be sending non-keyed coding!");
      NSData *imgDat = [coder decodeObjectOfClass:[NSData class] forKey:AQTPictureBaseImageKey];
      baseImage = [[NSImage alloc] initWithData:imgDat];
      if ([coder containsValueForKey:AQTPictureTransformKey]) {
         self.transform = [coder decodeObjectOfClass:[NSAffineTransform class] forKey:AQTPictureTransformKey];
      } else {
         NSAffineTransform *transform1 = [NSAffineTransform transform];
         NSAffineTransformStruct aStruct;
         aStruct.m11 = [coder decodeDoubleForKey:AQTPictureTransformKey1];
         aStruct.m12 = [coder decodeDoubleForKey:AQTPictureTransformKey2];
         aStruct.m21 = [coder decodeDoubleForKey:AQTPictureTransformKey3];
         aStruct.m22 = [coder decodeDoubleForKey:AQTPictureTransformKey4];
         aStruct.tX = [coder decodeDoubleForKey:AQTPictureTransformKey5];
         aStruct.tY = [coder decodeDoubleForKey:AQTPictureTransformKey6];
         transform1.transformStruct = aStruct;
         self.transform = transform1;
      }
      fitBounds = [coder decodeBoolForKey:AQTPictureFitBoundsKey];
      bitmapSize = [coder decodeSizeForKey:AQTPictureBitmapSizeKey];
   }
   return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
   [super encodeWithCoder:coder];
   NSAffineTransformStruct theStruct = transform.transformStruct;
   [coder encodeObject:baseImage.TIFFRepresentation forKey:AQTPictureBaseImageKey];
   [coder encodeSize:bitmapSize forKey:AQTPictureBitmapSizeKey];
   [coder encodeDouble:theStruct.m11 forKey:AQTPictureTransformKey1];
   [coder encodeDouble:theStruct.m12 forKey:AQTPictureTransformKey2];
   [coder encodeDouble:theStruct.m21 forKey:AQTPictureTransformKey3];
   [coder encodeDouble:theStruct.m22 forKey:AQTPictureTransformKey4];
   [coder encodeDouble:theStruct.tX forKey:AQTPictureTransformKey5];
   [coder encodeDouble:theStruct.tY forKey:AQTPictureTransformKey6];
   [coder encodeBool:fitBounds forKey:AQTPictureFitBoundsKey];
}

#if !__has_feature(objc_arc)
-(void)dealloc
{
   [baseImage release];
   [transform release];
   [super dealloc];
}
#endif

- (void)setTransform:(NSAffineTransform *)newTransform
{
#if !__has_feature(objc_arc)
   NSAffineTransform *tmp = transform;
   transform = [newTransform copy];
   [tmp release];
#else
   transform = [newTransform copy];
#endif
   fitBounds = NO;
}

@end
