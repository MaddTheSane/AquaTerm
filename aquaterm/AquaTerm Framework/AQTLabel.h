//
//  AQTLabel.h
//  AquaTerm
//
//  Created by ppe on Wed May 16 2001.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AQTGraphic.h"
#import "aquaterm.h"

/// A leaf object class representing an actual item in the plot.<br>
/// Since the app is a viewer we do three things with the object:
/// create (once), draw (any number of times) and (eventually) dispose of it.
@interface AQTLabel : AQTGraphic
{
   id string;		/**< The text (label, legend etc.) */
   NSString *fontName;
   CGFloat fontSize;
   NSPoint position;		/**< The position of the text */
   CGFloat angle;
   AQTAlign justification;		/**< Justification with respect to the position of the text */
   CGFloat shearAngle;
}
- (instancetype)initWithAttributedString:(NSAttributedString *)aString position:(NSPoint)aPoint angle:(CGFloat)textAngle shearAngle:(CGFloat)shearAngle justification:(AQTAlign)justify NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithString:(NSString *)aString position:(NSPoint)aPoint angle:(CGFloat)textAngle shearAngle:(CGFloat)shearAngle justification:(AQTAlign)justify NS_DESIGNATED_INITIALIZER;

@property (copy) NSString *fontName;
@property CGFloat fontSize;
@end
