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
  __weak AQTModel *model;
  BOOL _isProcessingEvents; /*!< Holds state of mouse input. */
  NSCursor *crosshairCursor;  /*!< Holds an alternate cursor for use with mouse input. */
  BOOL _enableTiming;
}
@property (weak) AQTModel *model;
@property (readonly, getter=isPrinting) BOOL printing;
/*! @brief Holds state of mouse input. */
@property (nonatomic, getter=isProcessingEvents) BOOL processingEvents;

/*" Utility methods "*/
- (NSPoint)convertPointToCanvasCoordinates:(NSPoint)viewPoint;
- (NSRect)convertRectToCanvasCoordinates:(NSRect)viewRect;
- (NSRect)convertRectToViewCoordinates:(NSRect)canvasRect;
@end
