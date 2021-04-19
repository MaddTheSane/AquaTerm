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

   NSBitmapImageRep *bir = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&whiteChars pixelsWide:1 pixelsHigh:1 bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:3 bitsPerPixel:24];
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

   const void *bdBytes = bytes.bytes;
   NSBitmapImageRep *bir = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&bdBytes pixelsWide:(NSInteger)size.width pixelsHigh:(NSInteger)size.height bitsPerSample:8 samplesPerPixel:3 hasAlpha:NO isPlanar:NO colorSpaceName:NSCalibratedRGBColorSpace bytesPerRow:3 * (NSInteger)size.width bitsPerPixel:24];
   NSImage *img = [[NSImage alloc] initWithSize:size];
   RELEASEOBJ(bir);
   [img addRepresentation:bir];
   
   self = [self initWithImage:img size:size bounds:bounds];
   RELEASEOBJ(img);

   return self;
}


#define AQTPictureBaseImageKey @"BaseImage"
#define AQTPictureBitmapSizeKey @"BitmapSize"
#define AQTPictureTransformKey @"Transform"
#define AQTPictureFitBoundsKey @"FitBounds"

+ (BOOL)supportsSecureCoding
{
   return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
   if (self = [super initWithCoder:coder]) {
      NSAssert([coder allowsKeyedCoding], @"No app should be sending non-keyed coding!");
      baseImage = RETAINOBJ([coder decodeObjectOfClass:[NSImage class] forKey:AQTPictureBaseImageKey]);
      self.transform = [coder decodeObjectOfClass:[NSAffineTransform class] forKey:AQTPictureTransformKey];
      fitBounds = [coder decodeBoolForKey:AQTPictureFitBoundsKey];
      bitmapSize = [coder decodeSizeForKey:AQTPictureBitmapSizeKey];
   }
   return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
   [super encodeWithCoder:coder];
   [coder encodeObject:baseImage forKey:AQTPictureBaseImageKey];
   [coder encodeSize:bitmapSize forKey:AQTPictureBitmapSizeKey];
   [coder encodeObject:transform forKey:AQTPictureTransformKey];
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
