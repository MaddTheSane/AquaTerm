//
//  AQTModel.m
//  AquaTerm
//
//  Created by per on Fri Nov 02 2001.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#import "AQTModel.h"

@implementation AQTModel
@synthesize title;
@synthesize canvasSize;
@synthesize dirtyRect;
@synthesize dirty = isDirty;
/**"
*** A class representing a collection of objects making up the plot.
"**/

-(id)initWithCanvasSize:(NSSize)size
{
  self = [super init];
  if (self)
  {
    modelObjects = [[NSMutableArray alloc] initWithCapacity:1024];
    self.title = @"Untitled";
    canvasSize = size;
  }
  return self;
}

-(id)init
{
  return [self initWithCanvasSize:NSMakeSize(200,200)];
}

-(void)dealloc
{
#ifdef MEM_DEBUG
   NSLog(@"[%@(0x%x) %@] %s:%d", NSStringFromClass([self class]), self, NSStringFromSelector(_cmd), __FILE__, __LINE__);
#endif
   [title release];
   [modelObjects release];
   [super dealloc];
}

#define AQTModelModelsKey @"Models"
#define AQTModelTitleKey @"Title"
#define AQTModelCanvasSizeKey @"CanvasSize"
#define AQTModelDirtyRectKey @"DirtyRect"
#define AQTModelIsDirtyKey @"IsDirty"

- (void)encodeWithCoder:(NSCoder *)coder
{
  [super encodeWithCoder:coder];
  if ([coder allowsKeyedCoding]) {
    [coder encodeObject:modelObjects forKey:AQTModelModelsKey];
    [coder encodeObject:title forKey:AQTModelTitleKey];
    [coder encodeSize:canvasSize forKey:AQTModelCanvasSizeKey];
    [coder encodeRect:dirtyRect forKey:AQTModelDirtyRectKey];
    [coder encodeBool:isDirty forKey:AQTModelIsDirtyKey];
  } else {
    AQTSize s;
    AQTRect r;
    
    [coder encodeObject:modelObjects];
    [coder encodeObject:title];
    // 64bit compatibility
    s.width = canvasSize.width; s.height = canvasSize.height;
    [coder encodeValueOfObjCType:@encode(AQTSize) at:&s];
    r.origin.x = dirtyRect.origin.x; r.origin.x = dirtyRect.origin.y;
    r.size.width = dirtyRect.size.width; r.size.height = dirtyRect.size.height;
    [coder encodeValueOfObjCType:@encode(AQTRect) at:&r];
    [coder encodeValueOfObjCType:@encode(BOOL) at:&isDirty];
  }
}

-(id)initWithCoder:(NSCoder *)coder
{
  if (self = [super initWithCoder:coder]) {
    if ([coder allowsKeyedCoding]) {
      modelObjects = [[coder decodeObjectForKey:AQTModelModelsKey] retain];
      title = [[coder decodeObjectForKey:AQTModelTitleKey] retain];
      canvasSize = [coder decodeSizeForKey:AQTModelCanvasSizeKey];
      dirtyRect = [coder decodeRectForKey:AQTModelDirtyRectKey];
      isDirty = [coder decodeBoolForKey:AQTModelIsDirtyKey];
    } else {
      AQTSize s;
      AQTRect r;
      
      modelObjects = [[coder decodeObject] retain];
      title = [[coder decodeObject] retain];
      [coder decodeValueOfObjCType:@encode(AQTSize) at:&s];
      canvasSize.width = s.width; canvasSize.height = s.height;
      [coder decodeValueOfObjCType:@encode(AQTRect) at:&r];
      dirtyRect.origin.x = r.origin.x; dirtyRect.origin.x = r.origin.y;
      dirtyRect.size.width = r.size.width; dirtyRect.size.height = r.size.height;
      [coder decodeValueOfObjCType:@encode(BOOL) at:&isDirty];
    }
  }
  
  return self;
}

-(NSString *)description
{
   return [NSString stringWithFormat:@"[AQTModel description] =\nTitle %@\nCanvasSize %@\nCount %lu\nBounds %@", title, NSStringFromSize(canvasSize), (unsigned long)[modelObjects count],  NSStringFromRect(_bounds)];
}

-(NSInteger)count
{
  return [modelObjects count];
}

/**"
*** Add any subclass of AQTGraphic to the collection of objects.
"**/
-(void)addObject:(AQTGraphic *)graphic
{
  [modelObjects addObject:graphic];
}

-(void)addObjectsFromArray:(NSArray *)graphics
{
   [modelObjects addObjectsFromArray:graphics];   
}

-(NSArray *)modelObjects
{
   return [[modelObjects copy] autorelease];
}

-(void)removeAllObjects
{
   [modelObjects removeAllObjects];
}

-(void)removeObjectAtIndex:(NSInteger)i
{
   [modelObjects removeObjectAtIndex:i];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nonnull *)buffer count:(NSUInteger)len
{
   return [modelObjects countByEnumeratingWithState:state objects:buffer count:len];
}

@end
