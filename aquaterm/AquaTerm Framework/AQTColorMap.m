//
//  AQTColorMap.m
//  AquaTerm
//
//  Created by Bob Savage on Mon Jan 28 2002.
//  Copyright (c) 2002-2012 The AquaTerm Team. All rights reserved.
//

#import "AQTColorMap.h"
#import "ARCBridge.h"

@implementation AQTColorMap
@synthesize size;
-(instancetype)init
{
    return [self initWithColormapSize:1]; // Black
}

-(instancetype)initWithColormapSize:(int32_t)mapsize
{
   if (self = [super init]) {
      size = (mapsize < 1)?1:mapsize;
      colormap = malloc(size*sizeof(AQTColor));
      if(!colormap) {
         AUTORELEASEOBJNORETURN(self);
         return nil;
      }
   }
   return self;
}

-(void)dealloc
{
   if (colormap) {
      free(colormap);
   }
   SUPERDEALLOC;
}

-(void)setColor:(AQTColor)newColor forIndex:(int32_t)index
{
   if (index >= 0 && index < size) {
      colormap[index] = newColor;
   }
}

-(AQTColor)colorForIndex:(int32_t)index
{
   if (index < 0 || index >= size) {
      return colormap[0];
   } else {
      return colormap[index];
   }
}

- (AQTColor)objectAtIndexedSubscript:(int32_t)index
{
   return [self colorForIndex:index];
}

- (void)setObject:(AQTColor)newValue atIndexedSubscript:(int32_t)index
{
   [self setColor:newValue forIndex:index];
}

@end
