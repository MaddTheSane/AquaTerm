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

-(instancetype)initWithPoints:(const NSPointArray __counted_by(pc) __noescape)points pointCount:(int32_t)pc;
{
  if (self = [super init])
  {
     pc = [self _aqtSetupPathStoreForPointCount:pc];
     if (pc != 0)
     {
        memcpy(path, points, sizeof(NSPoint) * pc);
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
         [points addObject:@(path[i])];
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

+ (BOOL)supportsSecureCoding
{
   return YES;
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
   NSInteger i;
   if (self = [super initWithCoder:coder]) {
      if (coder.allowsKeyedCoding && [coder containsValueForKey:AQTPathPathKey]) {
         isFilled = [coder decodeBoolForKey:AQTPathIsFilledKey];
         lineCapStyle = [coder decodeInt32ForKey:AQTPathLineCapStyleKey];
         linewidth = [coder decodeDoubleForKey:AQTPathLineWidthKey];
         NSArray *tmpArr = [coder decodeObjectOfClasses:[NSSet setWithObjects:[NSValue class], [NSArray class], nil] forKey:AQTPathPathKey];
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
         
         tmpArr = [coder decodeObjectOfClasses:[NSSet setWithObjects:[NSNumber class], [NSArray class], nil] forKey:AQTPathPatternKey];
         
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
         
         [coder decodeValueOfObjCType:@encode(BOOL) at:&isFilled size:sizeof(BOOL)];
         [coder decodeValueOfObjCType:@encode(int32_t) at:&lineCapStyle size:sizeof(int32_t)];
         [coder decodeValueOfObjCType:@encode(float) at:&tmpFloat size:sizeof(float)];
         [coder decodeValueOfObjCType:@encode(int32_t) at:&pointCount size:sizeof(int32_t)];
         linewidth = tmpFloat;
         // path might be malloc'd or on heap depending on pointCount
         pointCount = [self _aqtSetupPathStoreForPointCount:pointCount];
         // Fix for 64bit interoperability: NSPoint is of type GCFloat which is double on 64 bit and float on 32
         for (i = 0; i < pointCount; i++ )
         {
            [coder decodeValueOfObjCType:@encode(AQTPoint) at:&p size:sizeof(AQTPoint)];
            path[i].x = p.x; path[i].y = p.y;
         }
         [coder decodeValueOfObjCType:@encode(int32_t) at:&patternCount size:sizeof(int32_t)];
         [coder decodeArrayOfObjCType:@encode(float) count:patternCount at:pattern];
         [coder decodeValueOfObjCType:@encode(float) at:&tmpFloat size:sizeof(float)];
         patternPhase = tmpFloat;
         [coder decodeValueOfObjCType:@encode(BOOL) at:&hasPattern size:sizeof(BOOL)];
      }
   }
   
   return self;
}

- (void)setLinestylePattern:(const float * __counted_by(newCount) __noescape)newPattern count:(int32_t)newCount phase:(CGFloat)newPhase
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
