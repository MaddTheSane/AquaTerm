//
//  AQTGraphicDrawingMethods.h
//  AquaTerm
//
//  Created by Per Persson on Mon Oct 20 2003.
//  Copyright (c) 2003-2012 The AquaTerm Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <AquaTerm/AQTGraphic.h>
#import <AquaTerm/AQTModel.h>


@interface AQTGraphic (AQTGraphicDrawingMethods)
// + (NSImage *)sharedScratchPad;
@property (setter=_setCache:, strong) id _cache;
- (void)_setCache:(id)object;
- (void)setAQTColor;
@property (readonly) NSRect updateBounds;
- (void)renderInRect:(NSRect)boundsRect; // <--- canvas coords
@end

