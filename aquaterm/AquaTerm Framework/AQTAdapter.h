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
#include "aquaterm.h"

NS_ASSUME_NONNULL_BEGIN

@class AQTPlotBuilder, AQTClientManager;

/** \brief Class that provides an interface to the functionality of AquaTerm.
 
 AQTAdapter is a class that provides an interface to the functionality of AquaTerm.
 As such, it bridges the gap between client's procedural calls requesting operations
 such as drawing a line or placing a label and the object-oriented graph being built.
 The actual assembling of the graph is performed by an instance of class <code>AQTPlotBuilder</code>.

 It seemlessly provides a connection to the viewer (AquaTerm.app) without any work on behalf of the client.

 It also provides some utility functionality such an indexed colormap, and an optional
 error handling callback function for the client.

 Event handling of user input is provided through an optional callback function.

\code{.m}
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
\endcode
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

//! This is the designated initalizer, allowing for the default handler (an object vended by AquaTerm via OS X's distributed objects mechanism) to be replaced by a local instance. In most cases \c -init should be used, which calls \c -initWithHandler: with a \c nil argument.
- (nullable instancetype)initWithServer:(nullable id)localServer NS_DESIGNATED_INITIALIZER;

/** @}
 \name callbacks
 @{ */

@property (copy, nullable) void (^errorBlock)(NSString *__nullable msg);
@property (copy, nullable) void (^eventBlock)(int index, NSString *__nullable event);

/*! @brief Optionally set an error handling routine of the form <code>customErrorHandler(NSString *errMsg)</code>
 to override default behaviour. */
- (void)setErrorHandler:(void (*__nullable)(NSString *__nullable msg))fPtr;

/*" Optionally set an event handling routine of the form <code>customEventHandler(int index, NSString *event)</code>.
 The reference number of the plot that generated the event is passed in index and
 the structure of the string event is @"type:data1:data2:..."
 
 Currently supported events are:
 _{event description}
 _{0 NoEvent }
 _{1:%{x,y}:%button MouseDownEvent }
 _{2:%{x,y}:%key KeyDownEvent }
 _{42:%{x,y}:%key ServerError }
 _{43:%{x,y}:%key Error } "*/
- (void)setEventHandler:(void (*__nullable)(int index, NSString *__nullable event))fPtr;

/** @}
 \name Control operations
 @{ */

/*! Open up a new plot with internal reference number \c refNum and make it the target for subsequent commands. If the referenced plot already exists, it is selected and cleared. Disables event handling for previously targeted plot. */
- (void)openPlotWithIndex:(int32_t)refNum;

/*! Get the plot referenced by \c refNum and make it the target for subsequent commands.
 If no plot exists for refNum, the currently targeted plot remain unchanged. Disables
 event handling for previously targeted plot.
 \return \c YES on success, \c NO otherwise.
 */
- (BOOL)selectPlotWithIndex:(int32_t)refNum;

@property NSSize plotSize;

//! Title to appear in window titlebar, also default name when saving.
@property (copy, null_resettable) NSString *plotTitle;

//! Render the current plot in the viewer.
- (void)renderPlot;

//! Clears the current plot and resets default values. To keep plot settings, use \c eraseRect: instead.
- (void)clearPlot;

//! Closes the current plot but leaves viewer window on screen. Disables event handling.
- (void)closePlot;

/** @}
 \name Event handling
  @{ */

/*! Inform AquaTerm whether or not events should be passed from the currently selected plot. Deactivates
 event passing from any plot previously set to pass events. */
- (void)setAcceptingEvents:(BOOL)flag;

/*! Reads the last event logged by the viewer. Will always return \c NoEvent unless \c setAcceptingEvents: is called with a \c YES argument. */
@property (readonly, copy) NSString *lastEvent;

- (NSString *)waitNextEvent;

/** @}
 \name Plotting related commands
 @{ */

/** \name Clip rect, applies to all objects
 @{ */

/*! When setting a clipping region (rectangular) to apply to all subsequent operations,
 until changed again by \c setClipRect: or <code>setDefaultClipRect</code>. */
@property NSRect clipRect;

//! Restore clipping region to the deafult (object bounds), i.e. no clipping performed.
- (void)setDefaultClipRect;

/** @}
 \name Colormap (utility)
 @{ */

//! Return the number of color entries available in the currently active colormap.
@property (readonly) int32_t colormapSize;

//! Set an RGB entry in the colormap, at the position given by <code>entryIndex</code>.
- (void)setColormapEntry:(int32_t)entryIndex red:(float)r green:(float)g blue:(float)b alpha:(float)a;

- (void)getColormapEntry:(int32_t)entryIndex red:(float *)r green:(float *)g blue:(float *)b alpha:(float *)a;

//! Set an RGB entry in the colormap, at the position given by <code>entryIndex</code>.
- (void)setColormapEntry:(int32_t)entryIndex red:(float)r green:(float)g blue:(float)b;

- (void)getColormapEntry:(int32_t)entryIndex red:(float *)r green:(float *)g blue:(float *)b;

//! Set the current color, used for all subsequent items, using the color stored at the position given by \c index in the colormap.
- (void)takeColorFromColormapEntry:(int32_t)index;

//! Set the background color, overriding any previous color, using the color stored at the position given by \c index in the colormap.
- (void)takeBackgroundColorFromColormapEntry:(int32_t)index;

/** @}
 \name Color handling
 @{ */

/*! Set the current color, used for all subsequent items, using explicit RGB components. */
- (void)setColorRed:(float)r green:(float)g blue:(float)b alpha:(float)a NS_SWIFT_NAME(setColor(red:green:blue:alpha:));

/*! Set the background color, overriding any previous color, using explicit RGB components. */
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

/** @}
 \name Text handling
 @{ */

/*! The font to be used. Applies to all future operations. Default is Times-Roman.*/
@property (copy) NSString *fontName;

/*! The font size in points. Applies to all future operations. Default is 14pt. */
@property CGFloat fontSize;

/*! Convenience form of \c addLabel:atPoint:angle:shearAngle:align: for horizontal, left and baseline aligned text. */
- (void)addLabel:(id)text atPoint:(NSPoint)pos NS_REFINED_FOR_SWIFT;

/*! Same as \c addLabel:atPoint:angle:shearAngle:align: except that \c shearAngle defaults to <code>0</code>.*/
- (void)addLabel:(id)text atPoint:(NSPoint)pos angle:(CGFloat)angle align:(AQTAlign)just NS_REFINED_FOR_SWIFT;

/*! Add \c text at coordinate given by <code>pos</code>, rotated by \c angle degrees and aligned vertically and horisontally (with respect to pos and rotation) according to <code>align</code>. Horizontal and vertical align may be combined by an OR operation, e.g. <code>(AQTAlignCenter | AQTAlignMiddle)</code>.
 
 \li {HorizontalAlign Description}
 \li {AQTAlignLeft LeftAligned}
 \li {AQTAlignCenter Centered}
 \li {AQTAlignRight RightAligned}
 \li {VerticalAlign -}
 \li {AQTAlignMiddle ApproxCenter}
 \li {AQTAlignBaseline Normal}
 \li {AQTAlignBottom BottomBoundsOfTHISString}
 \li {AQTAlignTop TopBoundsOfTHISString}
 
 By specifying \c shearAngle the text may be sheared in order to appear correctly in e.g. 3D plot labels.
 The text can be either an \c NSString or an NSAttributedString. By using \c NSAttributedString a subset of the attributes defined in AppKit may be used to format the string beyond the fontface ans size. The currently supported attributes are:
 \li {Attribute value}
 \li {@"NSSuperScript" raise-level}
 \li {@"NSUnderline" 0 or 1}
 */
- (void)addLabel:(id)text atPoint:(NSPoint)pos angle:(CGFloat)angle shearAngle:(CGFloat)shearAngle align:(AQTAlign)just NS_REFINED_FOR_SWIFT;

/** @}
 \name Line handling
 @{ */

/*! The current \c linewidth (in points), used for all subsequent lines. Any line currently being built by \c -moveToPoint:/\c -addLineToPoint will be considered finished since any coalesced sequence of line segments must share the same lineWidth.  Default \c lineWidth is 1pt.*/
@property CGFloat lineWidth;

/*! Set the current line style to pattern style, used for all subsequent lines. The linestyle is specified
 as a pattern, an array of at most 8 float, where even positions correspond to dash-lengths and odd positions
 correspond to gap-lengths. To produce e.g. a dash-dotted line, use the pattern {4.0, 2.0, 1.0, 2.0}. */
- (void)setLinestylePattern:(const float *)newPattern count:(NSInteger)newCount phase:(float)newPhase;

/*! Set the current line style to solid, used for all subsequent lines. This is the default.*/
- (void)setLinestyleSolid;

/** The current line cap style (in points), used for all subsequent lines. Any line currently being built when this is set by \c moveToPoint: / \c addLineToPoint: will be considered finished since any coalesced sequence of line segments must share the same cap style.

 \li {AQTLineCapStyleButt ButtLineCapStyle}
 \li {AQTLineCapStyleRound RoundLineCapStyle}
 \li {AQTLineCapStyleSquare SquareLineCapStyle}
 
 Default is RoundLineCapStyle. */
@property AQTLineCapStyle lineCapStyle;

/*! Moves the current point (in canvas coordinates) in preparation for a new sequence of line segments.*/
- (void)moveToPoint:(NSPoint)point;

/*! Add a line segment from the current point (given by a previous \c moveToPoint: or <code>addLineToPoint</code>).*/
- (void)addLineToPoint:(NSPoint)point;

//! Add a sequence of line segments specified by a list of start-, end-, and joinpoint(s) in points. Parameter \c pc is number of line segments + 1.
- (void)addPolylineWithPoints:(NSPointArray)points pointCount:(NSInteger)pc NS_REFINED_FOR_SWIFT;

/** @}
 \name Rect and polygon handling
 @{ */

- (void)moveToVertexPoint:(NSPoint)point;
- (void)addEdgeToVertexPoint:(NSPoint)point;

/*! Add a polygon specified by a list of corner points.<br>
 Number of corners is passed in <code>pc</code>.
 */
- (void)addPolygonWithVertexPoints:(NSPointArray)points pointCount:(NSInteger)pc NS_REFINED_FOR_SWIFT;

//! Add a filled rectangle. Will attempt to remove any objects that will be covered by <code>aRect</code>.
- (void)addFilledRect:(NSRect)aRect;

//! Remove any objects \a completely inside <code>aRect</code>. Does \a not force a redraw of the plot.
- (void)eraseRect:(NSRect)aRect;

/** @}
 \name Image handling
 @{*/

/// \brief Set a transformation matrix.
///
/// For images added by <code>addTransformedImageWithBitmap:size:clipRect:</code>,
/// see \c NSImage documentation for details.
- (void)setImageTransformM11:(float)m11 m12:(float)m12 m21:(float)m21 m22:(float)m22 tX:(float)tX tY:(float)tY NS_SWIFT_NAME(setImageTransform(m11:m12:m21:m22:tX:tY:));

///Set transformation matrix to unity, i.e. no transform.
- (void)resetImageTransform;

/// Add a bitmap image of size bitmapSize scaled to fit destBounds, does \b not apply transform. Bitmap format is 24bits per pixel in sequence RGBRGB... with 8 bits per color.
- (void)addImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize bounds:(NSRect)destBounds;

/*! Add a bitmap image of size \c bitmapSize \b honoring transform, transformed image is clipped to current <code>clipRect</code>. Bitmap format is 24bits per pixel in sequence RGBRGB...  with 8 bits per color. */
- (void)addTransformedImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize;

/** @}
 @}
 \name Private methods
 @{ */

- (void)timingTestWithTag:(uint32_t)tag;

/** @}
 \name Deprecated
 @{ */

/*! \brief Deprecated method to set the line width.
 \deprecated Use the lineWidth property.
 \param newLinewidth The new line width.
 */
- (void)setLinewidth:(float)newLinewidth DEPRECATED_MSG_ATTRIBUTE("Use the lineWidth property") NS_SWIFT_UNAVAILABLE("Use the .lineWidth property");

/*! \brief Deprecated method to set the font name.
 \deprecated Use the fontName property.
 \param newFontname The new font name.
 */
- (void)setFontname:(NSString *)newFontname DEPRECATED_MSG_ATTRIBUTE("Use the fontName property") NS_SWIFT_UNAVAILABLE("Use the .fontName property");

/*! \brief Deprecated method to set the font size.
 \deprecated Use the fontSize property.
 \param newFontsize The new font size.
 */
- (void)setFontsize:(float)newFontsize DEPRECATED_MSG_ATTRIBUTE("Use the fontSize property") NS_SWIFT_UNAVAILABLE("Use the .fontSize property");

/** Deprecated, use \c addTransformedImageWithBitmap:size: instead.
 Add a bitmap image of size \c bitmapSize \b honoring transform,
 transformed image is clipped to <code>destBounds</code>. Bitmap format is 24bits
 per pixel in sequence RGBRGB...  with 8 bits per color.
 \deprecated Use \c addTransformedImageWithBitmap:size: instead.
 */
- (void)addTransformedImageWithBitmap:(const void *)bitmap size:(NSSize)bitmapSize clipRect:(NSRect)destBounds DEPRECATED_ATTRIBUTE;
/** @} */
@end

#ifdef __MAC_10_13
extern NSAttributedStringKey const AQTFontNameKey NS_SWIFT_NAME(AQTFontName);
extern NSAttributedStringKey const AQTFontSizeKey NS_SWIFT_NAME(AQTFontSize);
extern NSAttributedStringKey const AQTBaselineAdjustKey NS_SWIFT_NAME(AQTBaselineAdjust);
extern NSAttributedStringKey const AQTNonPrintingCharKey NS_SWIFT_NAME(AQTNonPrintingChar);
#else
extern NSString *const AQTFontNameKey;
extern NSString *const AQTFontSizeKey;
extern NSString *const AQTBaselineAdjustKey;
extern NSString *const AQTNonPrintingCharKey;
#endif

NS_ASSUME_NONNULL_END
