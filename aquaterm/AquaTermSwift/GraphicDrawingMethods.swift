//
//  GraphicDrawingMethods.swift
//  AquaTerm
//
//  Created by C.W. Betts on 1/5/16.
//
//

import Cocoa
import AquaTerm
import AquaTerm.AQTModel.AQTGraphic
import AquaTerm.AQTModel.AQTLabel
import AquaTerm.AQTModel.AQTPath
import AquaTerm.AQTModel.AQTImage

/* _aqtMinimumLinewidth is used by view to pass user prefs to line drawing routine,
this is ugly, but I can't see a simple way to do it without affecting performance. */
private var _aqtMinimumLinewidth = CGFloat()


extension AQTGraphic {
	
	private static var currentColor = AQTColor()
	
	func setAQTColor() {
		if AQTGraphic.currentColor != color {
			color.cocoaColor.set()
			AQTGraphic.currentColor = color
		}
	}
	
	func renderInRect(boundsRect: NSRect) {
		NSLog("Error: *** AQTGraphicDrawing ***");
	}
	
	func updateBounds() -> NSRect {
		return bounds
	}
}

extension AQTModel {
	/// Tell every object in the collection to draw itself.
	override func updateBounds() -> NSRect {
		var tmpRect = NSZeroRect;
		//AQTGraphic *graphic;
		//NSEnumerator *enumerator = [modelObjects objectEnumerator];
		
		_aqtMinimumLinewidth = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("MinimumLinewidth"))
		
		for graphic in modelObjects {
			/*       NSRect graphRect = [graphic updateBounds];
			
			if (NSIsEmptyRect(graphRect))
			{
			NSLog(@"**** rect = %@ : %@", NSStringFromRect(graphRect), [graphic description]);
			}
			
			tmpRect = AQTUnionRect(tmpRect, graphRect);
			*/
			tmpRect = AQTUnionRect(tmpRect, graphic.updateBounds());
		}
		self.bounds = tmpRect
		return tmpRect;
	}
}

extension AQTLabel {
	override func updateBounds() -> NSRect {
		var tempBounds = NSRect.zero
		if _cache == nil {
			_aqtLabelUpdateCache()
		}
		tempBounds = (_cache! as! NSBezierPath).bounds
		self.bounds = tempBounds
		return tempBounds
	}
	
	override func renderInRect(boundsRect: NSRect) {
		var context: NSGraphicsContext?
		let clippedBounds = isClipped ? NSIntersectionRect(bounds, clipRect) : bounds
		if AQTIntersectsRect(boundsRect, clippedBounds) {
			setAQTColor()
			if isClipped {
				context = NSGraphicsContext.currentContext()
				context?.saveGraphicsState();
				NSRectClip(clippedBounds);
				(_cache as? NSBezierPath)?.fill()
				context?.restoreGraphicsState()
			} else {
				(_cache as? NSBezierPath)?.fill()
			}
		}
		#if DEBUG_BOUNDS
			if (_shouldShowBounds) {
				let debugContext = NSGraphicsContext.currentContext()
				debugContext?.saveGraphicsState()
				NSColor.yellowColor().set()
				NSFrameRect(bounds);
				if isClipped {
					NSColor.orangeColor().set()
					NSFrameRect(_clipRect);
				}
				debugContext?.restoreGraphicsState()
			}
		#endif
	}
}

extension AQTPath {
	override func updateBounds() -> NSRect {
		var tmpBounds = NSRect()
		if _cache == nil {
			_aqtPathUpdateCache()
		}
		tmpBounds = (_cache! as! NSBezierPath).bounds.insetBy(dx: -lineWidth / 2, dy: -lineWidth / 2)
		bounds = tmpBounds
		return tmpBounds
	}
	
	override func renderInRect(boundsRect: NSRect) {
		var context: NSGraphicsContext?
		let clippedBounds = isClipped ? NSIntersectionRect(bounds, clipRect) : bounds;
		if (AQTIntersectsRect(boundsRect, clippedBounds)) {
			setAQTColor();
			if (isClipped) {
				context = NSGraphicsContext.currentContext()
				context?.saveGraphicsState()
				NSRectClip(clippedBounds);
			}
			(_cache as? NSBezierPath)?.stroke()
			if isFilled {
				(_cache as? NSBezierPath)?.fill()
			}
			if isClipped {
				context?.restoreGraphicsState()
			}
		}
		#if DEBUG_BOUNDS
			if shouldShowBounds {
				let debugContext = NSGraphicsContext.currentContext()
				debugContext?.saveGraphicsState()
				NSColor.yellowColor().set()
				NSFrameRect(bounds);
				if (isClipped) {
					NSColor.orangeColor().set()
					NSFrameRect(clipRect);
				}
				debugContext?.restoreGraphicsState()
			}
		#endif
		
	}
}

extension AQTAffineTransformStruct {
	var nsAffineStruct: NSAffineTransformStruct {
		return NSAffineTransformStruct(m11: CGFloat(self.m11), m12: CGFloat(self.m12), m21: CGFloat(self.m21), m22: CGFloat(self.m22), tX: CGFloat(self.tX), tY: CGFloat(self.tY))
	}
}

extension AQTImage {
	override func updateBounds() -> NSRect {
		let transf = NSAffineTransform()
		var tmpBounds = NSRect()
		if fitBounds {
			tmpBounds = bounds
		} else {
			transf.transformStruct = transform.nsAffineStruct
			// FIXME: This is lazy beyond any reasonable measure...
			tmpBounds = transf.transformBezierPath(NSBezierPath(rect: NSRect(origin: .zero, size: bitmapSize))).bounds
			bounds = tmpBounds
		}
		
		return tmpBounds
	}
	override func renderInRect(boundsRect: NSRect) {
		var context: NSGraphicsContext?
		let clippedBounds = isClipped ? NSIntersectionRect(bounds, clipRect) : bounds;
		if (AQTIntersectsRect(boundsRect, clippedBounds)) {
			if _cache == nil {
				// Install an NSImage in _cache
				let tmpImage = NSImage(size: bitmapSize)
				var theBytes = UnsafeMutablePointer<UInt8>(bitmap.bytes)
				if let tmpBitmap = NSBitmapImageRep(bitmapDataPlanes: &theBytes, pixelsWide: Int(bitmapSize.width), pixelsHigh: Int(bitmapSize.height), bitsPerSample: 8, samplesPerPixel: 3, hasAlpha: false, isPlanar: false, colorSpaceName: NSDeviceRGBColorSpace, bytesPerRow: 3*Int(bitmapSize.width), bitsPerPixel: 24) {
					tmpImage.addRepresentation(tmpBitmap)
				}
				_cache = tmpImage
			}
			if isClipped {
				context = NSGraphicsContext.currentContext()
				context?.saveGraphicsState()
				NSRectClip(clippedBounds);
			}
			if !fitBounds {
				let transf = NSAffineTransform();
				
				// If the image is clipped, the state is already stored
				if !isClipped {
					context = NSGraphicsContext.currentContext()
					context?.saveGraphicsState()
				}
				transf.transformStruct = transform.nsAffineStruct
				transf.concat()
			}
			if let cacheImg = _cache as? NSImage {
				cacheImg.drawAtPoint(.zero, fromRect: NSRect(origin: .zero, size: cacheImg.size), operation: .CompositeSourceOver, fraction: 1)
			}
			context?.restoreGraphicsState()
		}
		#if DEBUG_BOUNDS
			if (_shouldShowBounds) {
				let debugContext = NSGraphicsContext.currentContext()
				debugContext?.saveGraphicsState()
				NSColor.yellowColor().set()
				NSFrameRect(bounds);
				if (isClipped) {
					NSColor.orangeColor().set()
					NSFrameRect(clipRect);
				}
				debugContext.restoreGraphicsState()
			}
		#endif
	}
}
