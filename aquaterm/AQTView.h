//
//  AQTView.h
//  AquaTerm
//
//  Created by Per Persson on Wed Apr 17 2002.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#import <AppKit/AppKit.h>


@class AQTModel;
@interface AQTView : NSView
{
  __unsafe_unretained AQTModel *model;
  BOOL _isProcessingEvents; /*" Holds state of mouse input."*/
  NSCursor *crosshairCursor;  /*" Holds an alternate cursor for use with mouse input."*/
  BOOL _enableTiming;
}
@property (unsafe_unretained) AQTModel *model;
@property (readonly, getter=isPrinting) BOOL printing;
@property (nonatomic, getter=isProcessingEvents) BOOL processingEvents;

/*" Utility methods "*/
- (NSPoint)convertPointToCanvasCoordinates:(NSPoint)viewPoint;
- (NSRect)convertRectToCanvasCoordinates:(NSRect)viewRect;
- (NSRect)convertRectToViewCoordinates:(NSRect)canvasRect;
@end
