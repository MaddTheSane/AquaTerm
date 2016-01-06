//
//  AQTLabel.m
//  AquaTerm
//
//  Created by ppe on Wed May 16 2001.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#import "AQTLabel.h"

@interface AQTGraphic ()
-(instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;
@end


@interface AQTLabel ()
-(instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;
@end

@implementation AQTLabel
@synthesize fontName;
@synthesize fontSize;
    /**"
    *** A leaf object class representing an actual item in the plot. 
    *** Since the app is a viewer we do three things with the object:
    *** create (once), draw (any number of times) and (eventually) dispose of it.
    "**/

-(instancetype)init
{
  return [self initWithString:@"Placeholder" position:NSZeroPoint angle:0 shearAngle:0 justification:0];
}

-(instancetype)initWithAttributedString:(NSAttributedString *)aString position:(NSPoint)aPoint angle:(CGFloat)textAngle shearAngle:(CGFloat)beta justification:(AQTAlign)justify  
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

-(instancetype)initWithString:(NSString *)aString position:(NSPoint)aPoint angle:(CGFloat)textAngle shearAngle:(CGFloat)beta justification:(AQTAlign)justify
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
  return [NSString stringWithFormat:@"%@\nwith string:\n%@", super.description, [string description]];
}

#define AQTLabelStringKey @"LabelString"
#define AQTLabelFontNameKey @"FontName"
#define AQTLabelFontSizeKey @"FontSize"
#define AQTLabelPositionKey @"Position"
#define AQTLabelAngleKey @"Angle"
#define AQTLabelJustificationKey @"Justification"
#define AQTLabelShearAngleKey @"ShearAngle"

- (void)encodeWithCoder:(NSCoder *)coder
{
  [super encodeWithCoder:coder];
  if (coder.allowsKeyedCoding) {
    [coder encodeObject:string forKey:AQTLabelStringKey];
    [coder encodeObject:fontName forKey:AQTLabelFontNameKey];
    [coder encodeDouble:fontSize forKey:AQTLabelFontSizeKey];
    [coder encodePoint:position forKey:AQTLabelPositionKey];
    [coder encodeDouble:angle forKey:AQTLabelAngleKey];
    [coder encodeInt32:justification forKey:AQTLabelJustificationKey];
    [coder encodeDouble:shearAngle forKey:AQTLabelShearAngleKey];
  } else {
    AQTPoint p;
    float tmpFloat;
    [coder encodeObject:string];
    [coder encodeObject:fontName];
    tmpFloat = fontSize;
    [coder encodeValueOfObjCType:@encode(float) at:&tmpFloat];
    // 64bit safe
    p.x = position.x; p.y = position.y;
    [coder encodeValueOfObjCType:@encode(AQTPoint) at:&p];
    tmpFloat = angle;
    [coder encodeValueOfObjCType:@encode(float) at:&tmpFloat];
    [coder encodeValueOfObjCType:@encode(int32_t) at:&justification];
    tmpFloat = shearAngle;
    [coder encodeValueOfObjCType:@encode(float) at:&tmpFloat];
  }
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
  if (self = [super initWithCoder:coder]) {
    if (coder.allowsKeyedCoding) {
      string = [[coder decodeObjectForKey:AQTLabelStringKey] retain];
      fontName = [[coder decodeObjectForKey:AQTLabelFontNameKey] retain];
      fontSize = [coder decodeDoubleForKey:AQTLabelFontSizeKey];
      position = [coder decodePointForKey:AQTLabelPositionKey];
      angle = [coder decodeDoubleForKey:AQTLabelAngleKey];
      justification = [coder decodeInt32ForKey:AQTLabelJustificationKey];
      shearAngle = [coder decodeDoubleForKey:AQTLabelShearAngleKey];
    } else {
      AQTPoint p;
      float tmpFloat = 0;
      string = [[coder decodeObject] retain];
      fontName = [[coder decodeObject] retain];
      [coder decodeValueOfObjCType:@encode(float) at:&tmpFloat];
      fontSize = tmpFloat;
      [coder decodeValueOfObjCType:@encode(AQTPoint) at:&p];
      position.x = p.x; position.y = p.y;
      [coder decodeValueOfObjCType:@encode(float) at:&tmpFloat];
      angle = tmpFloat;
      [coder decodeValueOfObjCType:@encode(int32_t) at:&justification];
      [coder decodeValueOfObjCType:@encode(float) at:&tmpFloat];
      shearAngle = tmpFloat;
    }
  }
  return self;
}
@end
