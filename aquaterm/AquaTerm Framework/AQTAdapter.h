//
//  AQTAdapter.h
//  AquaTerm
//
//  Created by Per Persson on Sat Jul 12 2003.
//  Copyright (c) 2003-2012 The AquaTerm Team. All rights reserved.
//

#import <Foundation/NSString.h>
#import <Foundation/NSGeometry.h>
#import <Foundation/NSAttributedString.h>
#include <AquaTerm/aquaterm.h>
#import <AquaTerm/AQTGraphic.h>

NS_ASSUME_NONNULL_BEGIN

@class AQTPlotBuilder, AQTClientManager;

/**
 Class that provides an interface to the functionality of AquaTerm.
 
 `AQTAdapter` is a class that provides an interface to the functionality of AquaTerm.
 As such, it bridges the gap between client's procedural calls requesting operations
 such as drawing a line or placing a label and the object-oriented graph being built.
 The actual assembling of the graph is performed by an instance of class ``AQTPlotBuilder``.

 It seemlessly provides a connection to the viewer (AquaTermApp.app) without any work on behalf of the client.

 It also provides some utility functionality such an indexed colormap, and an optional
 error handling callback function for the client.

 Event handling of user input is provided through an optional callback function.

```objc
//example: HelloAquaTerm.m
//
// gcc -ObjC main.c -o aqtex -lobjc -framework AquaTerm -framework Foundation
// gcc main.m -o aqtex -framework AquaTerm -framework Foundation
#import <Foundation/Foundation.h>
#import <AquaTerm/AQTAdapter.h>

int main(void)
{
   NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
   AQTAdapter *adapter = [[AQTAdapter alloc] init];
   [adapter openPlotWithIndex:1];
   [adapter setPlotSize:NSMakeSize(600,400)];
   [adapter addLabel:@"HelloAquaTerm!" atPoint:NSMakePoint(300, 200) angle:0.0 align:1];
   [adapter renderPlot];
   [adapter release];
   [pool release];
   return 0;
}
```
*/
@interface AQTAdapter : NSObject
{
   /*" All instance variables are private. "*/
@private
   AQTClientManager *_clientManager;
   AQTPlotBuilder *_selectedBuilder;
#if __i386__
   id _aqtReserved1;
   id _aqtReserved2;
#endif
}

/** @name Class initialization etc.
  @{ */

//! Initializes an instance and sets up a connection to the handler object via DO. Launches AquaTerm if necessary.
- (nullable instancetype)init;

//! This is the designated initalizer, allowing for the default handler (an object vended by AquaTerm via macOS's distributed objects mechanism) to be replaced by a local instance.
//!
//! In most cases `-init` should be used, which calls `-initWithHandler:` with a `nil` argument.
- (nullable instancetype)initWithServer:(nullable id)localServer NS_DESIGNATED_INITIALIZER;

/*! Optionally set an error handling block of the form `void (^customErrorHandler)(NSString *errMsg)`
 to override default behaviour. */
@property (copy, nullable) void (^errorBlock)(NSString *__nullable msg);

/*! Optionally set an event handling routine of the form `void (^customEventHandler)(int index, NSString *event)`.
 
 The reference number of the plot that generated the event is passed in index and
 the structure of the string event is @"type:data1:data2:..."
 
 Currently supported events are:
 | Event string format | Description |
 | --- | --- |
 | 0 | No event (time-out) |
 | 1:_x,y_:_button_ | Mouse down event |
 | 2:_x,y_:_key_ | Key down event |
 | 42:_x,y_:_key_ | Server error |
 | 43:_x,y_:_key_ | General error |
 */
@property (copy, nullable) void (^eventBlock)(int index, NSString *__nullable event);

/*! Optionally set an error handling routine of the form `void customErrorHandler(NSString *errMsg)`
 to override default behaviour.
 */
- (void)setErrorHandler:(void (*__nullable)(NSString *__nullable msg))fPtr;

/*! Optionally set an event handling routine of the form `customEventHandler(int index, NSString *event)`.
 
 The reference number of the plot that generated the event is passed in index and
 the structure of the string event is @"type:data1:data2:..."
 
 Currently supported events are:
 | Event string format | Description |
 | --- | --- |
 | 0 | No event (time-out) |
 | 1:_x,y_:_button_ | Mouse down event |
 | 2:_x,y_:_key_ | Key down event |
 | 42:_x,y_:_key_ | Server error |
 | 43:_x,y_:_key_ | General error |
 */
- (void)setEventHandler:(void (*__nullable)(int index, NSString *__nullable event))fPtr;

/**
 @}
 \name Control operations
 @{ */

/*! Open up a new plot with internal reference number `refNum` and make it the target for subsequent commands.
 *
 * If the referenced plot already exists, it is selected and cleared. Disables event handling for previously targeted plot. */
- (void)openPlotWithIndex:(int32_t)refNum;

/*! Get the plot referenced by `refNum` and make it the target for subsequent commands.
 
 If no plot exists for `refNum`, the currently targeted plot remain unchanged. Disables
 event handling for previously targeted plot.
 \return `YES` on success, `NO` otherwise.
 */
- (BOOL)selectPlotWithIndex:(int32_t)refNum;

/*! Set the limits of the plot area.
 
 Must be set  *before* any drawing command following
 an `-openPlotWithIndex:` or `-clearPlot` command or behaviour is undefined.
 */
@property NSSize plotSize;

//! Title to appear in window titlebar, also default name when saving.
@property (copy, null_resettable) NSString *plotTitle;

//! Render the current plot in the viewer.
- (void)renderPlot;

//! Clears the current plot and resets default values. To keep plot settings, use \c eraseRect: instead.
- (void)clearPlot;

//! Closes the current plot but leaves viewer window on screen. Disables event handling.
- (void)closePlot;

/**
 @}
 \name Event handling
  @{ */

/*! Inform AquaTerm whether or not events should be passed from the currently selected plot. Deactivates
 event passing from any plot previously set to pass events. */
- (void)setAcceptingEvents:(BOOL)flag;

/*! Reads the last event logged by the viewer. Will always return `NoEvent` unless `-setAcceptingEvents:` is called with a `YES` argument. */
@property (readonly, copy) NSString *lastEvent;

- (NSString *)waitNextEvent;

/**
 @}
 \name Plotting related commands
 @{ */

/** \name Clip rect, applies to all objects
 @{ */

/*! When setting a clipping region (rectangular) to apply to all subsequent operations,
 until changed again by `-setClipRect:` or ``setDefaultClipRect``. */
@property NSRect clipRect;

//! Restore clipping region to the deafult (object bounds), i.e. no clipping performed.
- (void)setDefaultClipRect;

/**
 @}
 \name Colormap (utility)
 @{ */

//! Return the number of color entries available in the currently active colormap.
@property (readonly) int32_t colormapSize;

//! Set an RGBA entry in the colormap, at the position given by `entryIndex`.
- (void)setColormapEntry:(int32_t)entryIndex red:(float)r green:(float)g blue:(float)b alpha:(float)a;

//! Get an RGBA entry in the colormap, at the position given by `entryIndex`.
- (void)getColormapEntry:(int32_t)entryIndex red:(float *)r green:(float *)g blue:(float *)b alpha:(float *)a;

//! Set an RGB entry in the colormap, at the position given by `entryIndex`.
- (void)setColormapEntry:(int32_t)entryIndex red:(float)r green:(float)g blue:(float)b;

//! Get an RGB entry in the colormap, at the position given by `entryIndex`.
- (void)getColormapEntry:(int32_t)entryIndex red:(float *)r green:(float *)g blue:(float *)b;

//! Set the current color, used for all subsequent items, using the color stored at the position given by `index` in the colormap.
- (void)takeColorFromColormapEntry:(int32_t)index;

//! Set the background color, overriding any previous color, using the color stored at the position given by `index` in the colormap.
- (void)takeBackgroundColorFromColormapEntry:(int32_t)index;

/**
 @}
 \name Color handling
 @{ */

/*! Set the current color, used for all subsequent items, using explicit RGBA components. */
- (void)setColorRed:(float)r green:(float)g blue:(float)b alpha:(float)a NS_SWIFT_NAME(setColor(red:green:blue:alpha:));

/*! Set the background color, overriding any previous color, using explicit RGBA components. */
- (void)setBackgroundColorRed:(float)r green:(float)g blue:(float)b alpha:(float)a  NS_SWIFT_NAME(setBackgroundColor(red:green:blue:alpha:));

/*! Get current RGB color components by reference. */
- (void)getColorRed:(float *)r green:(float *)g blue:(float *)b alpha:(float *)a NS_SWIFT_NAME(getColor(red:green:blue:alpha:));

/*! Get background color components by reference. */
- (void)getBackgroundColorRed:(float *)r green:(float *)g blue:(float *)b alpha:(float *)a NS_SWIFT_NAME(getBackgroundColor(red:green:blue:alpha:));

/*! Set the current color, used for all subsequent items, using explicit RGB components. */
- (void)setColorRed:(float)r green:(float)g blue:(float)b NS_SWIFT_NAME(setColor(red:green:blue:));

/*! Set the background color, overriding any previous color, using explicit RGB components. */
- (void)setBackgroundColorRed:(float)r green:(float)g blue:(float)b NS_SWIFT_NAME(setBackgroundColor(red:green:blue:));

/*! Get current RGB color components by reference. */
- (void)getColorRed:(float *)r green:(float *)g blue:(float *)b NS_SWIFT_NAME(getColor(red:green:blue:));

/*! Get background color components by reference. */
- (void)getBackgroundColorRed:(float *)r green:(float *)g blue:(float *)b NS_SWIFT_NAME(getBackgroundColor(red:green:blue:));

//! The current RGB color components.
@property AQTColor color;

//! The background color components.
@property AQTColor backgroundColor;

/**
 @}
 \name Text handling
 @{ */

/*! The font to be used. Applies to all future operations. Default is "Times-Roman".
 */
@property (copy) NSString *fontName;

/*! The font size in points. Applies to all future operations. Default is 14pt. */
@property CGFloat fontSize;

/*! Convenience form of ``addLabel:atPoint:angle:shearAngle:align:`` for horizontal, left and baseline aligned text. */
- (void)addLabel:(id)text atPoint:(NSPoint)pos NS_REFINED_FOR_SWIFT;

/*! Same as ``addLabel:atPoint:angle:shearAngle:align:`` except that `shearAngle` defaults to `0`.*/
- (void)addLabel:(id)text atPoint:(NSPoint)pos angle:(CGFloat)angle align:(AQTAlign)just NS_REFINED_FOR_SWIFT;

/*! Add `text` at coordinate given by `pos`, rotated by `angle` degrees and aligned vertically and horisontally (with respect to pos and rotation) according to `align`. Horizontal and vertical align may be combined by an OR operation, e.g. `(AQTAlignCenter | AQTAlignMiddle)`.
 
 | Horizontal Align | Description |
 | --- | --- |
 | ``AQTAlign/left`` | Left aligned text |
 | ``AQTAlign/center`` | Centered text |
 | ``AQTAlign/right`` | Right aligned text |

 | Vertical Align | Description |
 | --- | --- |
 | ``AQTAlign/middle`` | Approximate centerline |
 | ``AQTAlign/baseline`` | Normal |
 | ``AQTAlign/bottom`` | Bottom bounds of _this_ string |
 | ``AQTAlign/top`` | Top bounds of _this_ string |
 
 By specifying `shearAngle`, the text may be sheared in order to appear correctly in e.g. 3D plot labels.
 The text can be either an `NSString` or an `NSAttributedString`. By using `NSAttributedString` a subset of the attributes defined in AppKit may be used to format the string beyond the fontface ans size. The currently supported attributes are:
 
 | Attribute | Description |
 | --- | --- |
 | @"NSSuperScript" | raise-level -3 to 3, default is 0 |
 | @"NSUnderline" | 0 or 1 |
 */
- (void)addLabel:(id)text atPoint:(NSPoint)pos angle:(CGFloat)angle shearAngle:(CGFloat)shearAngle align:(AQTAlign)just NS_REFINED_FOR_SWIFT;

/**
 @}
 \name Line handling
 @{ */

/*! The current `linewidth` (in points), used for all subsequent lines. Any line currently being built by ``moveToPoint:``/``addLineToPoint:`` will be considered finished since any coalesced sequence of line segments must share the same lineWidth.  Default `lineWidth` is 1pt.*/
@property CGFloat lineWidth;

/*! Set the current line style to pattern style, used for all subsequent lines.
 *
 * The linestyle is specified
 * as a pattern, an array of at most 8 float, where even positions correspond to dash-lengths and odd positions
 * correspond to gap-lengths. To produce e.g. a dash-dotted line, use the pattern `{4.0, 2.0, 1.0, 2.0}`.
 */
- (void)setLinestylePattern:(const float *)newPattern count:(NSInteger)newCount phase:(CGFloat)newPhase;

/*! Set the current line style to solid, used for all subsequent lines. This is the default.*/
- (void)setLinestyleSolid;

/** The current line cap style (in points), used for all subsequent lines. Any line currently being built when this is set by ``moveToPoint:``/``addLineToPoint:`` will be considered finished since any coalesced sequence of line segments must share the same cap style.

 | _capStyle_ | Description |
 | --- | --- |
 | ``AQTLineCapStyle/butt`` | Line does not extend beyond endpoint |
 | ``AQTLineCapStyle/round`` | Line extends into half-circle beyond endpoint |
 | ``AQTLineCapStyle/square`` | Line extends into half-square beyond endpoint |
 
 Default is `AQTLineCapStyleRound`. */
@property AQTLineCapStyle lineCapStyle;

/*! Moves the current point (in canvas coordinates) in preparation for a new sequence of line segments.*/
- (void)moveToPoint:(NSPoint)point;

/*! Add a line segment from the current point (given by a previous ``moveToPoint:`` or ``addLineToPoint:``).*/
- (void)addLineToPoint:(NSPoint)point;

/** Add a sequence of line segments specified by a list of start-, end-, and joinpoint(s) in points.
 * \param pc Number of line segments + 1.
 * \param points The points to add.
 */
- (void)addPolylineWithPoints:(NSPointArray)points pointCount:(NSInteger)pc NS_REFINED_FOR_SWIFT;

/**
 @}
 \name Rect and polygon handling
 @{ */

- (void)moveToVertexPoint:(NSPoint)point;
- (void)addEdgeToVertexPoint:(NSPoint)point;

/*! Add a polygon specified by a list of corner points.<br>
 Number of corners is passed in `pc`.
 */
- (void)addPolygonWithVertexPoints:(NSPointArray)points pointCount:(NSInteger)pc NS_REFINED_FOR_SWIFT;

//! Add a filled rectangle. Will attempt to remove any objects that will be covered by <code>aRect</code>.
- (void)addFilledRect:(NSRect)aRect;

//! Remove any objects *completely* inside `aRect`. Does *not* force a redraw of the plot.
- (void)eraseRect:(NSRect)aRect;

/**
 @}
 \name Image handling
 @{*/

/// Set a transformation matrix.
///
/// For images added by ``addTransformedImageWithBitmap:size:clipRect:``,
/// see `NSImage` documentation for details.
- (void)setImageTransformM11:(float)m11 m12:(float)m12 m21:(float)m21 m22:(float)m22 tX:(float)tX tY:(float)tY NS_SWIFT_NAME(setImageTransform(m11:m12:m21:m22:tX:tY:));

/// Set transformation matrix to unity, i.e. no transform.
- (void)resetImageTransform;

/// Add a bitmap image of size `bitmapSize` scaled to fit `destBounds`, does **not** apply transform. Bitmap format is 24bits per pixel in sequence RGBRGB... with 8 bits per color.
- (void)addImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize bounds:(NSRect)destBounds;

/*! Add a bitmap image of size `bitmapSize` **honoring** transform, transformed image is clipped to current `clipRect`. Bitmap format is 24bits per pixel in sequence RGBRGB...  with 8 bits per color. */
- (void)addTransformedImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize;


/// Add a bitmap image of size `bitmapSize` scaled to fit `destBounds`, does **not** apply transform. Bitmap format is 24bits per pixel in sequence RGBRGB... with 8 bits per color.
- (BOOL)addImageWithBitmapData:(NSData *)bitmap size:(NSSize)bitmapSize bounds:(NSRect)destBounds;

/// Add a bitmap image of size `bitmapSize` scaled to fit `destBounds`, does **not** apply transform. Bitmap format is 32bits per pixel in sequence RGBARGBA... with 8 bits per color.
- (BOOL)addImageWithRGBABitmapData:(NSData *)bitmap size:(NSSize)bitmapSize bounds:(NSRect)destBounds;

/// Add an image of size `bitmapSize` scaled to fit `destBounds`, does **not** apply transform. Image data has to be an image format that AppKit supports, such as PNG, GIF, TIFF, etc...
- (BOOL)addImageWithImageData:(NSData *)bitmap size:(NSSize)bitmapSize bounds:(NSRect)destBounds;

/// Add an image scaled to fit `destBounds`, does **not** apply transform. Image data has to be an image format that AppKit supports, such as PNG, GIF, TIFF, etc...
- (BOOL)addImageWithImageData:(NSData *)bitmap bounds:(NSRect)destBounds;


/**
 @}
 @}
 \name Private methods
 @{ */

- (void)timingTestWithTag:(uint32_t)tag;

/**
 @}
 \name Deprecated
 @{ */

/*!
 Deprecated method to set the line width. Use the ``lineWidth`` property instead.
 @deprecated Use the ``lineWidth`` property or `-setLineWidth:` instead.
 @param newLinewidth The new line width.
 */
- (void)setLinewidth:(float)newLinewidth __API_DEPRECATED_WITH_REPLACEMENT("-setLineWidth:", macos(10.4, 10.9));

/*!
 * Deprecated method to set the font name. Use the ``fontName`` property instead.
 *
 * @param newFontname The new font name.
 *
 * @deprecated Use the ``fontName`` property or `-setFontName:` instead.
 */
- (void)setFontname:(NSString *)newFontname __API_DEPRECATED_WITH_REPLACEMENT("-setFontName:", macos(10.4, 10.9));

/*!
 * Deprecated method to set the font size. Use the ``fontSize`` property instead.
 * @deprecated Use the ``fontSize`` property or `-setFontSize:` instead.
 * @param newFontsize The new font size.
 */
- (void)setFontsize:(float)newFontsize __API_DEPRECATED_WITH_REPLACEMENT("-setFontSize:", macos(10.4, 10.9));

/**
 Deprecated, use ``addTransformedImageWithBitmap:size:`` instead.
 
 Add a bitmap image of size `bitmapSize` **honoring** transform,
 transformed image is clipped to `destBounds`.
 Bitmap format is 24bits
 per pixel in sequence RGBRGB...  with 8 bits per color.
 @deprecated Use ``addTransformedImageWithBitmap:size:`` instead.
 */
- (void)addTransformedImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize clipRect:(NSRect)destBounds DEPRECATED_ATTRIBUTE;
/**
 @}
 */
@end

extern NSAttributedStringKey const AQTFontNameKey NS_SWIFT_NAME(aqtFontName);
extern NSAttributedStringKey const AQTFontSizeKey NS_SWIFT_NAME(aqtFontSize);
extern NSAttributedStringKey const AQTBaselineAdjustKey NS_SWIFT_NAME(aqtBaselineAdjust);
extern NSAttributedStringKey const AQTNonPrintingCharKey NS_SWIFT_NAME(aqtNonPrintingChar);

NS_ASSUME_NONNULL_END
