//
//  AQTView.m
//  AquaTerm
//
//  Created by Per Persson on Wed Apr 17 2002.
//  Copyright (c) 2001 AquaTerm. All rights reserved.
//

#import "AQTView.h"
#import "AQTGraphic.h"
#import "AQTModel.h"
#import "AQTGraphicDrawingMethods.h"

@implementation AQTView
-(void)awakeFromNib
{
   NSImage *curImg = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Cross" ofType:@"tiff"]];
   crosshairCursor = [[NSCursor alloc] initWithImage:curImg hotSpot:NSMakePoint(7,7)];
   [curImg release];
   [self setIsProcessingEvents:NO];
#ifdef TIMING
   if (getenv("AQUATERM_REPORT_TIMING") != (char *)NULL)
   {
      _enableTiming = YES;
   }
#endif
   
}

-(void)dealloc
{
   [crosshairCursor release];
   [super dealloc];
}

-(BOOL)acceptsFirstResponder
{
   return YES;
}

-(void)setModel:(AQTModel *)newModel
{
   model = newModel;
}

- (AQTModel *)model
{
   return model;
}

-(BOOL)isOpaque
{
   return YES;
}

-(BOOL)isPrinting
{
   return ![NSGraphicsContext currentContextDrawingToScreen]; 
}

- (BOOL)isProcessingEvents
{
   return _isProcessingEvents;
}

- (void)setIsProcessingEvents:(BOOL)flag
{
   if (_isProcessingEvents != flag)
   {
      // Change in state
      _isProcessingEvents = flag;
      [[self window] invalidateCursorRectsForView:self];
   }
}

-(void)resetCursorRects
{
   NSCursor *aCursor = _isProcessingEvents?crosshairCursor:[NSCursor arrowCursor];
   [self addCursorRect:[self bounds] cursor:aCursor];
   [aCursor setOnMouseEntered:YES];
}

- (NSPoint)convertPointToCanvasCoordinates:(NSPoint) aPoint
{
   NSAffineTransform *localTransform = [NSAffineTransform transform];
   [localTransform scaleXBy:[model canvasSize].width/NSWidth([self bounds])
                        yBy:[model canvasSize].height/NSHeight([self bounds])];

   return [localTransform transformPoint:aPoint];
}

- (NSRect)convertRectToCanvasCoordinates:(NSRect)viewRect
{
   NSRect tmpRect;
   NSAffineTransform *localTransform = [NSAffineTransform transform];
   [localTransform scaleXBy:[model canvasSize].width/NSWidth([self bounds])
                        yBy:[model canvasSize].height/NSHeight([self bounds])];

   tmpRect.origin = [localTransform transformPoint:viewRect.origin];
   tmpRect.size = [localTransform transformSize:viewRect.size];
   return tmpRect;
}

- (NSRect)convertRectToViewCoordinates:(NSRect)canvasRect
{
   NSRect tmpRect;
   NSAffineTransform *localTransform = [NSAffineTransform transform];
   [localTransform scaleXBy:NSWidth([self bounds])/[model canvasSize].width
                        yBy:NSHeight([self bounds])/[model canvasSize].height];

   tmpRect.origin = [localTransform transformPoint:canvasRect.origin];
   tmpRect.size = [localTransform transformSize:canvasRect.size];
   return tmpRect;
}


-(void)_aqtHandleMouseDownAtLocation:(NSPoint)point button:(int)button
{
   if ([self isProcessingEvents])
   {
      point = [self convertPoint:point fromView:nil];
      point = [self convertPointToCanvasCoordinates:point];
      [[[self window] delegate] processEvent:[NSString stringWithFormat:@"1:%@:%d", NSStringFromPoint(point), button]];
   }
}


-(void)mouseDown:(NSEvent *)theEvent
{
   [self _aqtHandleMouseDownAtLocation:[theEvent locationInWindow] button:1];
}

-(void)rightMouseDown:(NSEvent *)theEvent
{
   [self _aqtHandleMouseDownAtLocation:[theEvent locationInWindow] button:2];
}   

-(void)keyDown:(NSEvent *)theEvent
{
   if ([self isProcessingEvents])
   {
      NSString *eventString;
      NSPoint pos = [self convertPoint:[[self window] mouseLocationOutsideOfEventStream] fromView:nil];
      NSRect viewBounds = [self bounds];
      char aKey = [[theEvent characters] UTF8String][0];;
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
      eventString = [NSString stringWithFormat:@"2:%@:%c", NSStringFromPoint([self convertPointToCanvasCoordinates:pos]), aKey];
      [[[self window] delegate] processEvent:eventString];
   }
}

-(void)drawRect:(NSRect)dirtyRect // <--- argument _always_ in view coords
{
   NSRect viewBounds = [self bounds];
   NSSize canvasSize = [model canvasSize];
   NSRect dirtyCanvasRect;
   NSAffineTransform *transform = [NSAffineTransform transform];

#ifdef TIMING
   static float totalTime = 0.0;
   float thisTime;
   NSDate *startTime;
#endif

   [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationNone]; // FIXME: user prefs
   [[NSGraphicsContext currentContext] setShouldAntialias:YES]; // FIXME: user prefs
#ifdef DEBUG_BOUNDS
   [[NSColor redColor] set];
   NSFrameRect(dirtyRect);
#endif
   NSRectClip(dirtyRect);

   // Dirty rect in view coords, clipping rect is set.
   // Need to i) set transform for subsequent operations
   // and ii) transform dirty rect to canvas coords.

   // (i) view transform
   [transform scaleXBy:viewBounds.size.width/canvasSize.width
               yBy:viewBounds.size.height/canvasSize.height];
   [transform concat];

   // (ii) dirty rect transform
   [transform invert];
   dirtyCanvasRect.origin = [transform transformPoint:dirtyRect.origin];
   dirtyCanvasRect.size = [transform transformSize:dirtyRect.size];
#ifdef TIMING
   if (_enableTiming)
   {
      startTime = [NSDate date];
   }
   [model renderInRect:dirtyCanvasRect]; 
   if (_enableTiming)
   {
      thisTime = -[startTime timeIntervalSinceNow];
      totalTime += thisTime;
      NSLog(@"Render time: %f for %d objects. Total: %f", thisTime, [[model modelObjects] count], totalTime);
   }
#else
   [model renderInRect:dirtyCanvasRect]; // expects aRect in canvas coords, _not_ view coords
#endif
   
#ifdef DEBUG_BOUNDS
   NSLog(@"dirtyRect: %@", NSStringFromRect(dirtyRect));
   NSLog(@"dirtyCanvasRect: %@", NSStringFromRect(dirtyCanvasRect));
#endif
}
@end


