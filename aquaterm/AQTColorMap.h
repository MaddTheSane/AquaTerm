//
//  AQTColorMap.h
//  AquaTerm
//
//  Created by Bob Savage on Mon Jan 28 2002.
//  Copyright (c) 2002-2012 The AquaTerm Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AQTGraphic.h"

typedef AQTColor *AQTColorPtr;

NS_ASSUME_NONNULL_BEGIN

@interface AQTColorMap : NSObject	
{
   AQTColorPtr colormap; // NB. Not an object but a pointer to a struct
   int32_t size; 
}
/// Creates an `AQTColorMap with a size of 1.
-(instancetype)init;

-(instancetype)initWithColormapSize:(int32_t)size NS_DESIGNATED_INITIALIZER;

@property (readonly) int32_t size;

-(void)setColor:(AQTColor)newColor forIndex:(int32_t)index;

-(AQTColor)colorForIndex:(int32_t)index;

- (AQTColor)objectAtIndexedSubscript:(int32_t)index;
- (void)setObject:(AQTColor)newValue atIndexedSubscript:(int32_t)index;

@end

NS_ASSUME_NONNULL_END
