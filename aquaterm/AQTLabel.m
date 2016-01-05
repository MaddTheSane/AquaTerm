//
//  AQTLabel.m
//  AquaTerm
//
//  Created by ppe on Wed May 16 2001.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#import "AQTLabel.h"

@implementation AQTLabel
@synthesize fontName;
@synthesize fontSize;
    /**"
    *** A leaf object class representing an actual item in the plot. 
    *** Since the app is a viewer we do three things with the object:
    *** create (once), draw (any number of times) and (eventually) dispose of it.
    "**/

-(id)initWithAttributedString:(NSAttributedString *)aString position:(NSPoint)aPoint angle:(CGFloat)textAngle shearAngle:(CGFloat)beta justification:(int32_t)justify  
{
  if (self=[super init])
  {
    string = [aString copy]; // [[NSAttributedString alloc] initWithAttributedString:aString];
    fontName = @"Times-Roman";
    fontSize = 14.0;
    position=aPoint;
    angle = textAngle;
    shearAngle = beta;
    justification = justify;
  }
  return self; 
}

-(id)initWithString:(NSString *)aString position:(NSPoint)aPoint angle:(CGFloat)textAngle shearAngle:(CGFloat)beta justification:(int32_t)justify
{
  
 /* return [self initWithAttributedString:[[[NSAttributedString alloc] initWithString:aString] autorelease]
                               position:aPoint
                                  angle:textAngle
                          justification:justify];
*/
  if (self=[super init])
  {
    string = [aString copy]; // [[NSAttributedString alloc] initWithAttributedString:aString];
    fontName = @"Times-Roman";
    fontSize = 14.0;
    position=aPoint;
    angle = textAngle;
    shearAngle = beta;
    justification = justify;
  }
  return self; 

}

-(void)dealloc
{
  [string release];
  [fontName release];
  [super dealloc];
}

-(NSString *)description
{
  return [NSString stringWithFormat:@"%@\nwith string:\n%@", [super description], [string description]];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  AQTPoint p;

  [super encodeWithCoder:coder];
  [coder encodeObject:string];
  [coder encodeObject:fontName];
  [coder encodeValueOfObjCType:@encode(float) at:&fontSize];
  // 64bit safe
  p.x = position.x; p.y = position.y;
  [coder encodeValueOfObjCType:@encode(AQTPoint) at:&p];
  [coder encodeValueOfObjCType:@encode(float) at:&angle];
  [coder encodeValueOfObjCType:@encode(int32_t) at:&justification];
  [coder encodeValueOfObjCType:@encode(float) at:&shearAngle];
}

-(id)initWithCoder:(NSCoder *)coder
{
  AQTPoint p;

  self = [super initWithCoder:coder];
  string = [[coder decodeObject] retain];
  fontName = [[coder decodeObject] retain];
  [coder decodeValueOfObjCType:@encode(float) at:&fontSize];
  [coder decodeValueOfObjCType:@encode(AQTPoint) at:&p];
  position.x = p.x; position.y = p.y;
  [coder decodeValueOfObjCType:@encode(float) at:&angle];
  [coder decodeValueOfObjCType:@encode(int32_t) at:&justification];
  [coder decodeValueOfObjCType:@encode(float) at:&shearAngle];
  return self;
}
@end
