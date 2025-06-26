//
//  AQTModel.h
//  AquaTerm
//
//  Created by per on Fri Nov 02 2001.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#ifndef __AQUATERM_AQTMODEL_H__
#define __AQUATERM_AQTMODEL_H__

#import <Foundation/Foundation.h>
#import <AquaTerm/AQTGraphic.h>

NS_ASSUME_NONNULL_BEGIN

/// A class representing a collection of objects making up the plot.
@interface AQTModel : AQTGraphic <NSFastEnumeration> /*" NSObject "*/
{
   /** An array of ``AQTGraphic`` objects (leaf or collection) */
   NSMutableArray<__kindof AQTGraphic*> *modelObjects;
   /** Associate a title with the model. Default is 'Figure n'. */
   NSString       *title;
   
   NSSize         canvasSize;
   NSRect         dirtyRect;
   BOOL           isDirty;
}

-(instancetype)init;
-(instancetype)initWithCanvasSize:(NSSize)canvasSize NS_DESIGNATED_INITIALIZER;
-(nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;
@property NSSize canvasSize;
@property (readonly) NSRect dirtyRect;
@property (readonly, getter=isDirty) BOOL dirty;
@property (readonly) NSInteger count;
/// Add any subclass of ``AQTGraphic`` to the collection of objects.
-(void)addObject:(__kindof AQTGraphic *)graphic;
/// Add any subclass of ``AQTGraphic`` to the collection of objects.
-(void)addObjectsFromArray:(NSArray<__kindof AQTGraphic*> *)graphics;
/** An array of ``AQTGraphic`` objects (leaf or collection) */
@property (readonly, copy) NSArray<__kindof AQTGraphic*> *modelObjects;
-(void)removeAllObjects;
-(void)removeObjectAtIndex:(NSInteger)i;
/// Associate a title with the model. Default is 'Figure n'.
@property (copy) NSString *title;

@end

NS_ASSUME_NONNULL_END

#endif
