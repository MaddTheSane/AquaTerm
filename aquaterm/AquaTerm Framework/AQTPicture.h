//
//  AQTPicture.h
//  AQTFwk
//
//  Created by C.W. Betts on 4/18/21.
//  Copyright © 2021 AquaTerm Team. All rights reserved.
//

#import <AquaTerm/AQTGraphic.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AQTPicture : AQTGraphic {
   NSImage *baseImage;
   NSAffineTransform *transform;
   NSSize bitmapSize;
   BOOL fitBounds;
}

- (instancetype)initWithImage:(NSImage*)img size:(NSSize)size bounds:(NSRect)bounds NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithBitmapData:(NSData *)bytes size:(NSSize)size bounds:(NSRect)bounds;
- (nullable instancetype)initWithRGBABitmapData:(NSData *)bytes size:(NSSize)size bounds:(NSRect)bounds;
- (nullable instancetype)initWithImageData:(NSData * _Nonnull)imageData size:(NSSize)size bounds:(NSRect)bounds;

@property (nonatomic, copy) NSAffineTransform *transform;
@property (readonly, copy) NSImage *baseImage;
@property (readonly) BOOL fitBounds;
@property (readonly) NSSize bitmapSize;

@end

NS_ASSUME_NONNULL_END
