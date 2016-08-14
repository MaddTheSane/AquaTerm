//
//  AQTModel.h
//  AquaTerm
//
//  Created by per on Fri Nov 02 2001.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AQTGraphic.h"

/// A class representing a collection of objects making up the plot
@interface AQTModel : AQTGraphic <NSFastEnumeration> /*" NSObject "*/
{
   NSMutableArray<AQTGraphic*> *modelObjects; /**< An array of \c AQTGraphic objects (leaf or collection) */
   NSString       *title; /**< Associate a title with the model. Default is 'Figure n'. */
   NSSize         canvasSize;
   NSRect         dirtyRect;
   BOOL           isDirty;
}

-(instancetype)init;
-(instancetype)initWithCanvasSize:(NSSize)canvasSize NS_DESIGNATED_INITIALIZER;
@property NSSize canvasSize;
@property (readonly) NSRect dirtyRect;
@property (readonly, getter=isDirty) BOOL dirty;
@property (readonly) NSInteger count;
/// Add any subclass of AQTGraphic to the collection of objects.
-(void)addObject:(AQTGraphic *)graphic;
/// Add any subclass of \c AQTGraphic to the collection of objects
-(void)addObjectsFromArray:(NSArray<AQTGraphic*> *)graphics;
@property (readonly, copy) NSArray<AQTGraphic*> *modelObjects;
-(void)removeAllObjects;
-(void)removeObjectAtIndex:(NSInteger)i;
@property (copy) NSString *title;

@end
