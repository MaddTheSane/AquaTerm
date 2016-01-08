//
//  AQTView.m
//  AquaTerm
//
//  Created by Per Persson on Wed Apr 17 2002.
//  Copyright (c) 2001-2012 The AquaTerm Team. All rights reserved.
//

#import "AQTView.h"
#import "AQTGraphic.h"
#import "AQTModel.h"
#import "AQTGraphicDrawingMethods.h"
#import "AQTPlot.h"
#import "PreferenceKeys.h"

@implementation AQTView
@synthesize model;
@synthesize isProcessingEvents = _isProcessingEvents;

-(void)setCrosshairCursorColor
{
  NSString *cursorImageName;
  NSInteger cursorIndex = [[NSUserDefaults standardUserDefaults] integerForKey:CrosshairColorKey];

  switch (cursorIndex) {
    case 0: 
      cursorImageName = @"crossRed";
      break;
    case 1:
      cursorImageName = @"crossYellow";
      break;
    case 2:
      cursorImageName = @"crossBlue";
      break;
    case 3:
      cursorImageName = @"crossGreen";
      break;
    case 4:
      cursorImageName = @"crossBlack";
      break;
    case 5:
      cursorImageName = @"crossWhite";
      break;
    default:
      cursorImageName = @"crossRed";
      break;
  }
  NSImage *curImg = [NSImage imageNamed:cursorImageName];
  crosshairCursor = [[NSCursor alloc] initWithImage:curImg hotSpot:NSMakePoint(7,7)];
}

-(void)awakeFromNib
{
   [self setCrosshairCursorColor];
   [self setIsProcessingEvents:NO];   
}

-(BOOL)acceptsFirstResponder
{
   return YES;
}

-(BOOL)isOpaque
{
   return YES;
}

-(BOOL)isPrinting
{
   return ![NSGraphicsContext currentContextDrawingToScreen]; 
}

- (void)setIsProcessingEvents:(BOOL)flag
{
   if (_isProcessingEvents != flag)
   {
      // Change in state
      _isProcessingEvents = flag;
      [self setCrosshairCursorColor];
      [self.window invalidateCursorRectsForView:self];
   }
}

-(void)resetCursorRects
{
   NSCursor *aCursor = _isProcessingEvents?crosshairCursor:[NSCursor arrowCursor];
   [self addCursorRect:self.bounds cursor:aCursor];
   [aCursor setOnMouseEntered:YES];
}

- (NSPoint)convertPointToCanvasCoordinates:(NSPoint) aPoint
{
   NSAffineTransform *localTransform = [NSAffineTransform transform];
   [localTransform scaleXBy:model.canvasSize.width/NSWidth(self.bounds)
                        yBy:model.canvasSize.height/NSHeight(self.bounds)];

   return [localTransform transformPoint:aPoint];
}

- (NSRect)convertRectToCanvasCoordinates:(NSRect)viewRect
{
   NSRect tmpRect;
   NSAffineTransform *localTransform = [NSAffineTransform transform];
   [localTransform scaleXBy:model.canvasSize.width/NSWidth(self.bounds)
                        yBy:model.canvasSize.height/NSHeight(self.bounds)];

   tmpRect.origin = [localTransform transformPoint:viewRect.origin];
   tmpRect.size = [localTransform transformSize:viewRect.size];
   return tmpRect;
}

- (NSRect)convertRectToViewCoordinates:(NSRect)canvasRect
{
   NSRect tmpRect;
   NSAffineTransform *localTransform = [NSAffineTransform transform];
   [localTransform scaleXBy:NSWidth(self.bounds)/model.canvasSize.width
                        yBy:NSHeight(self.bounds)/model.canvasSize.height];

   tmpRect.origin = [localTransform transformPoint:canvasRect.origin];
   tmpRect.size = [localTransform transformSize:canvasRect.size];
   return tmpRect;
}


-(void)_aqtHandleMouseDownAtLocation:(NSPoint)point button:(int32_t)button
{
   if (self.isProcessingEvents)
   {
      point = [self convertPoint:point fromView:nil];
      point = [self convertPointToCanvasCoordinates:point];
      point = NSIntegralRect((NSRect){.origin = point, .size = NSMakeSize(1, 1)}).origin;
      [(AQTPlot*)self.window.delegate processEvent:[NSString stringWithFormat:@"1:%@:%d", NSStringFromPoint(point), button]];
   }
}


-(void)mouseDown:(NSEvent *)theEvent
{
   [self _aqtHandleMouseDownAtLocation:theEvent.locationInWindow button:1];
}

-(void)rightMouseDown:(NSEvent *)theEvent
{
   [self _aqtHandleMouseDownAtLocation:theEvent.locationInWindow button:2];
}   

-(void)keyDown:(NSEvent *)theEvent
{
   if (self.isProcessingEvents)
   {
      NSString *eventString;
      NSPoint pos = [self convertPoint:self.window.mouseLocationOutsideOfEventStream fromView:nil];
      NSRect viewBounds = self.bounds;
      if (!NSPointInRect(pos, viewBounds))
      {
         // Just crop it to be inside [self bounds];
         if (pos.x < 0 )
            pos.x = 0;
         else if (pos.x > NSWidth(viewBounds))
            pos.x = NSWidth(viewBounds);
         if (pos.y < 0 )
            pos.y = 0;
         else if (pos.y > NSHeight(viewBounds))
            pos.y = NSHeight(viewBounds);
      }
      eventString = [NSString stringWithFormat:@"2:%@:%@:%d", 
        NSStringFromPoint([self convertPointToCanvasCoordinates:pos]), 
        theEvent.characters, 
        theEvent.keyCode];
      [(AQTPlot*)self.window.delegate processEvent:eventString];
   }
}

-(void)drawRect:(NSRect)dirtyRect // <--- argument _always_ in view coords
{
   NSRect viewBounds = self.bounds;
   NSSize canvasSize = model.canvasSize;
   NSRect dirtyCanvasRect;
   NSAffineTransform *transform = [NSAffineTransform transform];

   [NSGraphicsContext currentContext].imageInterpolation = [[NSUserDefaults standardUserDefaults] integerForKey:ImageInterpolationKey]; // NSImageInterpolationNone FIXME: user prefs
   [NSGraphicsContext currentContext].shouldAntialias = [[NSUserDefaults standardUserDefaults] boolForKey:AntialiasDrawingKey]; // FIXME: user prefs
#ifdef DEBUG_BOUNDS
   [[NSColor redColor] set];
   NSFrameRect(dirtyRect);
#endif
   NSRectClip(dirtyRect);

   // Dirty rect in view coords, clipping rect is set.
   // Need to i) set transform for subsequent operations
   // and ii) transform dirty rect to canvas coords.

   // (i) view transform
   [transform translateXBy:0.5 yBy:0.5]; // FIXME: should this go before scale or after?
   [transform scaleXBy:viewBounds.size.width/canvasSize.width
               yBy:viewBounds.size.height/canvasSize.height];
   [transform concat];

   // (ii) dirty rect transform
   [transform invert];
   dirtyCanvasRect.origin = [transform transformPoint:dirtyRect.origin];
   dirtyCanvasRect.size = [transform transformSize:dirtyRect.size];

   [model renderInRect:dirtyCanvasRect]; // expects aRect in canvas coords, _not_ view coords
   
#ifdef DEBUG_BOUNDS
   NSLog(@"dirtyRect: %@", NSStringFromRect(dirtyRect));
   NSLog(@"dirtyCanvasRect: %@", NSStringFromRect(dirtyCanvasRect));
#endif
}
@end


