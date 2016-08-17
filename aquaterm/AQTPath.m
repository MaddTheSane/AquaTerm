//
//  AQTPath.m
//  AquaTerm
//
//  Created by ppe on Wed May 16 2001.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#import "AQTPath.h"
#import "ARCBridge.h"

@interface AQTPath ()
-(instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;
@end

@implementation AQTPath
@synthesize lineWidth = linewidth;
@synthesize lineCapStyle;
@synthesize filled = isFilled;
@synthesize hasPattern;

/** A private method to provide storage for an NSPointArray */
- (int32_t)_aqtSetupPathStoreForPointCount:(int32_t)pc
{
   // Use static store as default (efficient for small paths)
   path = staticPathStore;
   if (pc > STATIC_POINT_STORAGE)
   {
      // Use dynamic store instead to avoid large memory overhead
      // by having too large static store in all objects
      if((dynamicPathStore = malloc(pc * sizeof(NSPoint))))
      {
         path = dynamicPathStore;
      }
      else
      {
         NSLog(@"Error: Could not allocate memory, path clipped to %d points", STATIC_POINT_STORAGE);
         pc = STATIC_POINT_STORAGE;
      }
   }
   return pc;
}

/**"
*** A leaf object class representing an actual item in the plot.
*** Since the app is a viewer we do three things with the object:
*** create (once), draw (any number of times) and (eventually) dispose of it.
"**/
-(instancetype)initWithPoints:(NSPointArray)points pointCount:(int32_t)pc;
{
  int32_t i;
  if (self = [super init])
  {
     pc = [self _aqtSetupPathStoreForPointCount:pc];
     // FIXME: memcpy
     for (i = 0; i < pc; i++)
     {
        path[i] = points[i];
     }
     pointCount = pc;
     linewidth = .2;
     hasPattern = NO;
  }
  return self;
}

-(instancetype)init
{
   return [self initWithPoints:nil pointCount:0];
}

-(void)dealloc
{
   if (path == dynamicPathStore) {
      free(dynamicPathStore);
   }
   SUPERDEALLOC;
}

#define AQTPathIsFilledKey @"IsFilled"
#define AQTPathLineCapStyleKey @"LineCapStyle"
#define AQTPathLineWidthKey @"LineWidth"
#define AQTPathPathKey @"Path"
#define AQTPathPatternKey @"Pattern"
#define AQTPathPatternPhaseKey @"PatternPhase"
#define AQTPathHasPatternKey @"HasPattern"

- (void)encodeWithCoder:(NSCoder *)coder
{
   NSInteger i;
   [super encodeWithCoder:coder];
   [coder encodeBool:isFilled forKey:AQTPathIsFilledKey];
   [coder encodeInt32:lineCapStyle forKey:AQTPathLineCapStyleKey];
   [coder encodeDouble:linewidth forKey:AQTPathLineWidthKey];
   NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:pointCount];
   @autoreleasepool {
      for (i = 0; i < pointCount; i++) {
         [points addObject:[NSValue valueWithPoint:path[i]]];
      }
      [coder encodeObject:points forKey:AQTPathPathKey];
      RELEASEOBJ(points);
      points = [[NSMutableArray alloc] initWithCapacity:MAX_PATTERN_COUNT];
      for (i = 0; i < patternCount; i++) {
         [points addObject:@(pattern[i])];
      }
      [coder encodeObject:points forKey:AQTPathPatternKey];
      RELEASEOBJ(points);
   }
   [coder encodeDouble:patternPhase forKey:AQTPathPatternPhaseKey];
   [coder encodeBool:hasPattern forKey:AQTPathHasPatternKey];
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
   NSInteger i;
   if (self = [super initWithCoder:coder]) {
      if (coder.allowsKeyedCoding) {
         isFilled = [coder decodeBoolForKey:AQTPathIsFilledKey];
         lineCapStyle = [coder decodeInt32ForKey:AQTPathLineCapStyleKey];
         linewidth = [coder decodeDoubleForKey:AQTPathLineWidthKey];
         NSArray *tmpArr = [coder decodeObjectForKey:AQTPathPathKey];
         pointCount = (int)tmpArr.count;
         pointCount = [self _aqtSetupPathStoreForPointCount:pointCount];
         
         i = 0;
         for (NSValue *val in tmpArr) {
            if (i >= pointCount) {
               break;
            }
            path[i] = val.pointValue;
            
            i++;
         }
         
         tmpArr = [coder decodeObjectForKey:AQTPathPatternKey];
         
         i = 0;
         for (NSNumber *val in tmpArr) {
            if (i >= MAX_PATTERN_COUNT) {
               break;
            }
            
            pattern[i] = val.floatValue;
            
            i++;
         }
         
         patternPhase = [coder decodeDoubleForKey:AQTPathPatternPhaseKey];
         hasPattern = [coder decodeBoolForKey:AQTPathHasPatternKey];
      } else {
         AQTPoint p;
         float tmpFloat;
         
         [coder decodeValueOfObjCType:@encode(BOOL) at:&isFilled];
         [coder decodeValueOfObjCType:@encode(int32_t) at:&lineCapStyle];
         [coder decodeValueOfObjCType:@encode(float) at:&tmpFloat];
         linewidth = tmpFloat;
         [coder decodeValueOfObjCType:@encode(int32_t) at:&pointCount];
         // path might be malloc'd or on heap depending on pointCount
         pointCount = [self _aqtSetupPathStoreForPointCount:pointCount];
         // Fix for 64bit interoperability: NSPoint is of type GCFloat which is double on 64 bit and float on 32
         for( i = 0; i < pointCount; i++ )
         {
            [coder decodeValueOfObjCType:@encode(AQTPoint) at:&p];
            path[i].x = p.x; path[i].y = p.y;
         }
         [coder decodeValueOfObjCType:@encode(int32_t) at:&patternCount];
         [coder decodeArrayOfObjCType:@encode(float) count:patternCount at:pattern];
         [coder decodeValueOfObjCType:@encode(float) at:&tmpFloat];
         patternPhase = tmpFloat;
         [coder decodeValueOfObjCType:@encode(BOOL) at:&hasPattern];
      }
   }
   
   return self;
}

- (void)setLinestylePattern:(const float *)newPattern count:(int32_t)newCount phase:(CGFloat)newPhase
{
   // Create a local copy of the pattern.
   int32_t i;
   if (newCount <= 0) // Sanity check
      return;
   // constrain count to MAX_PATTERN_COUNT
   newCount = MIN(newCount, MAX_PATTERN_COUNT);
   for (i=0; i<newCount; i++) {
      pattern[i] = newPattern[i];
   }
   patternCount = newCount;
   patternPhase = newPhase;
   hasPattern = YES;
}

- (void)setIsFilled:(BOOL)newFill
{
   self.filled = newFill;
}

- (void)setLinewidth:(float)lw
{
   self.lineWidth = lw;
}

@end
