//
//  AQTAdapter.m
//  AquaTerm
//
//  Created by Per Persson on Sat Jul 12 2003.
//  Copyright (c) 2003-2012 The AquaTerm Team. All rights reserved.
//

#import "AQTAdapter.h"
#import "AQTClientManager.h"
#import "AQTPlotBuilder.h"
#import "ARCBridge.h"

NSString *const AQTFontNameKey = @"AQTFontname";
NSString *const AQTFontSizeKey = @"AQTFontsize";
NSString *const AQTBaselineAdjustKey = @"AQTBaselineAdjust";
NSString *const AQTNonPrintingCharKey = @"AQTNonPrintingChar";

@implementation AQTAdapter

-(instancetype)initWithServer:(id)localServer
{
   if(self = [super init]) {
      BOOL serverIsOK = YES;
      _clientManager = [AQTClientManager sharedManager];
      if (localServer) {
         [_clientManager setServer:localServer];
      } else {
         serverIsOK = [_clientManager connectToServer];
      }
      if (!serverIsOK) {
         AUTORELEASEOBJNORETURN(self);
         return nil;
      }
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(connectionDidDie:)
                                                   name:NSConnectionDidDieNotification
                                                 object:nil];
   }
   return self;
}

- (instancetype)init
{
   return [self initWithServer:nil];
}

#if !__has_feature(objc_arc)
- (oneway void)release
{
   [_clientManager logMessage:[NSString stringWithFormat:@"adapter rc = %lu", (unsigned long)[self retainCount]] logLevel:3];
   [super release];
}
#endif

- (void)dealloc
{
   [_clientManager logMessage:@"adapter dealloc, terminating connection." logLevel:3];
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   [_clientManager terminateConnection];
   SUPERDEALLOC;
}

- (void)setErrorBlock:(void (^)(NSString *))errorBlock
{
   _clientManager.errorBlock = errorBlock;
}

- (void (^)(NSString *))errorBlock
{
   return _clientManager.errorBlock;
}

- (void)setEventBlock:(void (^)(int, NSString *))eventBlock
{
   _clientManager.eventBlock = eventBlock;
}

- (void (^)(int, NSString *))eventBlock
{
   return _clientManager.eventBlock;
}

- (void)setErrorHandler:(void (*)(NSString *errMsg))fPtr
{
   [_clientManager setErrorHandler:fPtr];
}

- (void)setEventHandler:(void (*)(int index, NSString *event))fPtr
{
   [_clientManager setEventHandler:fPtr];
}

- (void)connectionDidDie:(id)x
{
   // NSLog(@"in --> %@ %s line %d", NSStringFromSelector(_cmd), __FILE__, __LINE__);
   // Make sure we can't access any invalid objects:
   _selectedBuilder = nil;
}

#pragma mark === Control operations ===

/* Creates a new builder instance, adds it to the list of builders and makes it the selected builder. If the referenced builder exists, it is selected and cleared. */
/*" Open up a new plot with internal reference number refNum and make it the target for subsequent commands. If the referenced plot already exists, it is selected and cleared. Disables event handling for previously targeted plot. "*/
- (void)openPlotWithIndex:(int32_t)refNum
{
   _selectedBuilder = [_clientManager newPlotWithIndex:refNum];
}

/*" Get the plot referenced by refNum and make it the target for subsequent commands. If no plot exists for refNum, the currently targeted plot remain unchanged. Disables event handling for previously targeted plot. Returns YES on success. "*/
- (BOOL)selectPlotWithIndex:(int32_t)refNum
{
   BOOL didChangePlot = NO;
   AQTPlotBuilder *tmpBuilder = [_clientManager selectPlotWithIndex:refNum];
   if (tmpBuilder != nil)
   {
      _selectedBuilder = tmpBuilder;
      didChangePlot = YES;
   }
   return didChangePlot;
}

/*" Set the limits of the plot area. Must be set %before any drawing command following an #openPlotWithIndex: or #clearPlot command or behaviour is undefined.  "*/
- (void)setPlotSize:(NSSize)canvasSize
{
   _selectedBuilder.size = canvasSize;
}

- (NSSize)plotSize
{
   return _selectedBuilder.size;
}

/*" Set title to appear in window titlebar, also default name when saving. "*/
- (void)setPlotTitle:(NSString *)title
{
   _selectedBuilder.title = title?title:@"Untitled";
}

- (NSString*)plotTitle
{
   return _selectedBuilder.title;
}

/*" Render the current plot in the viewer. "*/
- (void)renderPlot
{
   if(_selectedBuilder)
   {
      [_clientManager renderPlot];
   }
   else
   {
      // Just inform user about what is going on...
      [_clientManager logMessage:@"Warning: No plot selected" logLevel:2];
   }
}

/*" Clears the current plot and resets default values. To keep plot settings, use #eraseRect: instead. "*/
- (void)clearPlot
{
      _selectedBuilder = [_clientManager clearPlot];
}

/*" Closes the current plot but leaves viewer window on screen. Disables event handling. "*/
- (void)closePlot 
{
   [_clientManager closePlot];
   _selectedBuilder = nil;
}

#pragma mark === Event handling ===

/*" Inform AquaTerm whether or not events should be passed from the currently selected plot. Deactivates event passing from any plot previously set to pass events. "*/
- (void)setAcceptingEvents:(BOOL)flag 
{
   [_clientManager setAcceptingEvents:flag]; 
}

/*" Reads the last event logged by the viewer. Will always return NoEvent unless #setAcceptingEvents: is called with a YES argument."*/
- (NSString *)lastEvent
{
   [[NSRunLoop currentRunLoop] runMode:NSConnectionReplyMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
   return [_clientManager lastEvent]; 
}

- (NSString *)waitNextEvent // FIXME: timeout? Hardcoded to 10s
{
 NSString *event;
   BOOL isRunning;
   [self setAcceptingEvents:YES];
   do {
      isRunning = [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10.0]];
      event = [_clientManager lastEvent];
      isRunning = [event isEqualToString:@"0"]?YES:NO;
   } while (isRunning);
   [self setAcceptingEvents:NO];
   return event;
}

#pragma mark === Plotting commands ===

/*" Set a clipping region (rectangular) to apply to all subsequent operations, until changed again by #setClipRect: or #setDefaultClipRect. "*/ 
- (void)setClipRect:(NSRect)clip
{
   [_selectedBuilder setClipRect:clip];
}

- (NSRect)clipRect
{
   return _selectedBuilder.clipRect;
}

/*" Restore clipping region to the deafult (object bounds), i.e. no clipping performed. "*/
- (void)setDefaultClipRect
{
   [_selectedBuilder setDefaultClipRect];
}

/*" Return the number of color entries available in the currently active colormap. "*/
- (int32_t)colormapSize
{
   int32_t size = AQT_COLORMAP_SIZE; // Default size
   if (_selectedBuilder)
   {
      size = _selectedBuilder.colormapSize;
   }
   else
   {
      // Just inform user about what is going on...
      [_clientManager logMessage:@"Warning: No plot selected" logLevel:2];
   }
   return size;
}

/*" Set an RGB entry in the colormap, at the position given by entryIndex. "*/
- (void)setColormapEntry:(int32_t)entryIndex red:(float)r green:(float)g blue:(float)b alpha:(float)a
{
   AQTColor tmpColor;
   tmpColor.red = r;
   tmpColor.green = g;
   tmpColor.blue = b;
   tmpColor.alpha = a;
   [_selectedBuilder setColor:tmpColor forColormapEntry:entryIndex];
}

- (void)setColormapEntry:(int32_t)entryIndex red:(float)r green:(float)g blue:(float)b 
{
   [self setColormapEntry:entryIndex red:r green:g blue:b alpha:1.0];
}


/*" Set an RGB entry in the colormap, at the position given by entryIndex. "*/
- (void)getColormapEntry:(int32_t)entryIndex red:(float *)r green:(float *)g blue:(float *)b alpha:(float *)a
{
   AQTColor tmpColor = [_selectedBuilder colorForColormapEntry:entryIndex];
   *r = tmpColor.red;
   *g = tmpColor.green;
   *b = tmpColor.blue;
   *a = tmpColor.alpha;
}

- (void)getColormapEntry:(int32_t)entryIndex red:(float *)r green:(float *)g blue:(float *)b
{
   float dummyAlpha;
   [self getColormapEntry:entryIndex red:r green:g blue:b alpha:&dummyAlpha];
}


/*" Set the current color, used for all subsequent items, using the color stored at the position given by index in the colormap. "*/
- (void)takeColorFromColormapEntry:(int32_t)index
{
   [_selectedBuilder takeColorFromColormapEntry:index];
}

/*" Set the background color, overriding any previous color, using the color stored at the position given by index in the colormap. "*/
- (void)takeBackgroundColorFromColormapEntry:(int32_t)index
{
   [_selectedBuilder takeBackgroundColorFromColormapEntry:index];
}

/*" Set the current color, used for all subsequent items, using explicit RGB components. "*/
- (void)setColorRed:(float)r green:(float)g blue:(float)b alpha:(float)a
{
   AQTColor newColor = (AQTColor){r, g, b, a};
   _selectedBuilder.color = newColor;
}

- (void)setColorRed:(float)r green:(float)g blue:(float)b
{
   [self setColorRed:r green:g blue:b alpha:1.0];
}


/*" Set the background color, overriding any previous color, using explicit RGB components. "*/
- (void)setBackgroundColorRed:(float)r green:(float)g blue:(float)b alpha:(float)a
{
   AQTColor newColor = (AQTColor){r, g, b, a};
   _selectedBuilder.backgroundColor = newColor;
}

- (void)setBackgroundColorRed:(float)r green:(float)g blue:(float)b
{
   [self setBackgroundColorRed:r green:g blue:b alpha:1.0];
}


/*" Get current RGB color components by reference. "*/
- (void)getColorRed:(float *)r green:(float *)g blue:(float *)b alpha:(float *)a
{
   AQTColor tmpColor = _selectedBuilder.color;
   *r = tmpColor.red;
   *g = tmpColor.green;
   *b = tmpColor.blue;
   *a = tmpColor.alpha;
}


- (void)getColorRed:(float *)r green:(float *)g blue:(float *)b
{
   AQTColor tmpColor = _selectedBuilder.color;
   *r = tmpColor.red;
   *g = tmpColor.green;
   *b = tmpColor.blue;
}

/*" Get background color components by reference. "*/
- (void)getBackgroundColorRed:(float *)r green:(float *)g blue:(float *)b alpha:(float *)a
{
    AQTColor tmpColor = _selectedBuilder.backgroundColor;
    *r = tmpColor.red;
    *g = tmpColor.green;
    *b = tmpColor.blue;
    *a = tmpColor.alpha;
}


- (void)getBackgroundColorRed:(float *)r green:(float *)g blue:(float *)b
{
   float dummyAlpha;
   [self getBackgroundColorRed:r green:g blue:b alpha:&dummyAlpha];
}


- (void)setFontname:(NSString *)newFontname
{
   self.fontName = newFontname;
}

- (void)setFontsize:(float)newFontsize
{
   self.fontSize = newFontsize;
}


/*" Set the font to be used. Applies to all future operations. Default is Times-Roman."*/
- (void)setFontName:(NSString *)newFontname
{
   _selectedBuilder.fontName = newFontname;
}

- (NSString *)fontName
{
   return _selectedBuilder.fontName;
}

/*" Set the font size in points. Applies to all future operations. Default is 14pt. "*/
- (void)setFontSize:(CGFloat)newFontsize
{
   _selectedBuilder.fontSize = newFontsize;
}

- (CGFloat)fontSize
{
   return _selectedBuilder.fontSize;
}

/*" Add text at coordinate given by pos, rotated by angle degrees and aligned vertically and horisontally (with respect to pos and rotation) according to align. Horizontal and vertical align may be combined by an OR operation, e.g. (AQTAlignCenter | AQTAlignMiddle).
_{HorizontalAlign Description}
_{AQTAlignLeft LeftAligned}
_{AQTAlignCenter Centered}
_{AQTAlignRight RightAligned}
_{VerticalAlign -}
_{AQTAlignMiddle ApproxCenter}
_{AQTAlignBaseline Normal}
_{AQTAlignBottom BottomBoundsOfTHISString}
_{AQTAlignTop TopBoundsOfTHISString}
By specifying #shearAngle the text may be sheared in order to appear correctly in e.g. 3D plot labels. 
The text can be either an NSString or an NSAttributedString. By using NSAttributedString a subset of the attributes defined in AppKit may be used to format the string beyond the fontface ans size. The currently supported attributes are
_{Attribute value}
_{@"NSSuperScript" raise-level}
_{@"NSUnderline" 0or1}
"*/
- (void)addLabel:(id)text atPoint:(NSPoint)pos angle:(CGFloat)angle shearAngle:(CGFloat)shearAngle align:(AQTAlign)just
{
   [_selectedBuilder addLabel:text position:pos angle:angle shearAngle:shearAngle justification:just];
}

/*" Same as #addLabel:atPoint:angle:shearAngle:align: except that shearAngle defaults to 0."*/
- (void)addLabel:(id)text atPoint:(NSPoint)pos angle:(CGFloat)angle align:(AQTAlign)just
{
   [_selectedBuilder addLabel:text position:pos angle:angle shearAngle:0.0 justification:just];
}

/*" Convenience form of #addLabel:atPoint:angle:shearAngle:align: for horizontal, left and baseline aligned text."*/
- (void)addLabel:(id)text atPoint:(NSPoint)pos
{
   [_selectedBuilder addLabel:text position:pos angle:0.0 shearAngle:0.0 justification:(AQTAlignLeft | AQTAlignBaseline)];
}



/*" Set the current linewidth (in points), used for all subsequent lines. Any line currently being built by #moveToPoint:/#addLineToPoint will be considered finished since any coalesced sequence of line segments must share the same linewidth.  Default linewidth is 1pt."*/
- (void)setLinewidth:(float)newLinewidth
{
   [_selectedBuilder setLinewidth:newLinewidth];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
   _selectedBuilder.lineWidth = lineWidth;
}

- (CGFloat)lineWidth
{
   return _selectedBuilder.lineWidth;
}

/*" Set the current line style to pattern style, used for all subsequent lines. The linestyle is specified as a pattern, an array of at most 8 float, where even positions correspond to dash-lengths and odd positions correspond to gap-lengths. To produce e.g. a dash-dotted line, use the pattern {4.0, 2.0, 1.0, 2.0}."*/
- (void)setLinestylePattern:(const float *)newPattern count:(NSInteger)newCount phase:(float)newPhase
{
   [_selectedBuilder setLinestylePattern:newPattern count:(int32_t)newCount phase:newPhase];
}

- (void)setLinestyleSolid
{
   [_selectedBuilder setLinestyleSolid];
}

- (void)setLineCapStyle:(AQTLineCapStyle)capStyle
{
   _selectedBuilder.lineCapStyle = capStyle;
}

- (AQTLineCapStyle)lineCapStyle
{
   return _selectedBuilder.lineCapStyle;
}

- (void)moveToPoint:(NSPoint)point
{
   [_selectedBuilder moveToPoint:point];
}

- (void)addLineToPoint:(NSPoint)point
{
   [_selectedBuilder addLineToPoint:point];
}

- (void)addPolylineWithPoints:(NSPointArray)points pointCount:(NSInteger)pc
{
   [_selectedBuilder addPolylineWithPoints:points pointCount:(int32_t)pc];
}

- (void)moveToVertexPoint:(NSPoint)point
{
   [_selectedBuilder moveToVertexPoint:point];
}

- (void)addEdgeToVertexPoint:(NSPoint)point
{
   [_selectedBuilder addEdgeToPoint:point];
}

- (void)addPolygonWithVertexPoints:(NSPointArray)points pointCount:(NSInteger)pc
{
   [_selectedBuilder addPolygonWithPoints:points pointCount:(int32_t)pc];
}

/*" Add a filled rectangle. Will attempt to remove any objects that will be covered by aRect."*/
- (void)addFilledRect:(NSRect)aRect
{
   // FIXME: this may be very inefficent, maybe store a AQTClearRect object in the model instead?
   // If the filled rect covers a substantial area, it is worthwile to clear it first.
   if (NSWidth(aRect)*NSHeight(aRect) > 100.0)
   {
      [_clientManager clearPlotRect:aRect];
   }
   [_selectedBuilder addFilledRect:aRect];
}

- (void)eraseRect:(NSRect)aRect
{
   // FIXME: Possibly keep a list of rects to be erased and pass them before any append command??
   [_clientManager clearPlotRect:aRect];
}

- (void)setImageTransformM11:(float)m11 m12:(float)m12 m21:(float)m21 m22:(float)m22 tX:(float)tX tY:(float)tY
{
   AQTAffineTransformStruct trans;
   trans.m11 = m11;
   trans.m12 = m12;
   trans.m21 = m21;
   trans.m22 = m22;
   trans.tX = tX;
   trans.tY = tY;
   [_selectedBuilder setImageTransform:trans];
}

- (void)resetImageTransform
{
   AQTAffineTransformStruct trans = {0};
   trans.m11 = 1.0;
   trans.m22 = 1.0;
   [_selectedBuilder setImageTransform:trans];
}

/*" Add a bitmap image of size bitmapSize scaled to fit destBounds, does %not apply transform. Bitmap format is 24bits per pixel in sequence RGBRGB... with 8 bits per color."*/
- (void)addImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize bounds:(NSRect)destBounds
{
   [_clientManager clearPlotRect:destBounds];
   [_selectedBuilder addImageWithBitmap:bitmap size:bitmapSize bounds:destBounds];
}

- (BOOL)addImageWithBitmapData:(NSData *)bitmap size:(NSSize)bitmapSize bounds:(NSRect)destBounds
{
   [_clientManager clearPlotRect:destBounds];
   return [_selectedBuilder addImageWithBitmapData:bitmap size:bitmapSize bounds:destBounds];
}

- (BOOL)addImageWithRGBABitmapData:(NSData *)bitmap size:(NSSize)bitmapSize bounds:(NSRect)destBounds
{
   [_clientManager clearPlotRect:destBounds];
   return [_selectedBuilder addImageWithRGBABitmapData:bitmap size:bitmapSize bounds:destBounds];
}

- (BOOL)addImageWithImageData:(NSData *)bitmap size:(NSSize)bitmapSize bounds:(NSRect)destBounds
{
   [_clientManager clearPlotRect:destBounds];
   return [_selectedBuilder addImageWithImageData:bitmap size:bitmapSize bounds:destBounds];

}

- (BOOL)addImageWithImageData:(NSData *)bitmap bounds:(NSRect)destBounds
{
   [_clientManager clearPlotRect:destBounds];
   return [_selectedBuilder addImageWithImageData:bitmap size:NSZeroSize bounds:destBounds];
}

- (void)addTransformedImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize clipRect:(NSRect)destBounds
{
   [_selectedBuilder addTransformedImageWithBitmap:bitmap size:bitmapSize clipRect:destBounds];
}

/*" Add a bitmap image of size bitmapSize %honoring transform, transformed image is clipped to current clipRect. Bitmap format is 24bits per pixel in sequence RGBRGB...  with 8 bits per color."*/
- (void)addTransformedImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize
{
   [_selectedBuilder addTransformedImageWithBitmap:bitmap size:bitmapSize];
}

/*******************************************
* Private methods                         *
*******************************************/
- (void)timingTestWithTag:(uint32_t)tag
{
   [_clientManager timingTestWithTag:tag];
}
@end

