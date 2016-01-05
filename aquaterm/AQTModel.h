//
//  AQTModel.h
//  AquaTerm
//
//  Created by per on Fri Nov 02 2001.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AQTGraphic.h"

@interface AQTModel : AQTGraphic /*" NSObject "*/ 
{
   NSMutableArray *modelObjects; /*" An array of AQTGraphic objects (leaf or collection) "*/
   NSString       *title; /*" Associate a title with the model. Default is 'Figure n'. "*/
   NSSize         canvasSize;
   NSRect         dirtyRect;
   BOOL           isDirty;
}
-(instancetype)initWithCanvasSize:(NSSize)canvasSize;
@property NSSize canvasSize;
-(NSRect)dirtyRect;
-(BOOL)isDirty;
@property (readonly) int32_t count;
-(void)addObject:(AQTGraphic *)graphic;
-(void)addObjectsFromArray:(NSArray<AQTGraphic*> *)graphics;
-(NSArray<AQTGraphic*> *)modelObjects;
-(void)removeAllObjects;
-(void)removeObjectAtIndex:(uint32_t)i;
@property (copy) NSString *title;
@end
