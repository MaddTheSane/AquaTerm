//
//  AQView.swift
//  AquaTerm
//
//  Created by C.W. Betts on 1/4/16.
//
//

import Cocoa
import AquaTerm
import AquaTerm.AQTModel

class AQView: NSView {
	private var enableTiming = false
	/*" Holds an alternate cursor for use with mouse input."*/
	private var crosshairCursor: NSCursor?
	
	weak var model: AQTModel?
	var printing: Bool {
		return !NSGraphicsContext.currentContextDrawingToScreen()
	}
	/*" Holds state of mouse input."*/
	var isProcessingEvents: Bool = false {
		didSet {
			if oldValue != isProcessingEvents {
				// Change in state
				//_isProcessingEvents = flag;
				setCrosshairCursorColor()
				window?.invalidateCursorRectsForView(self)
			}
		}
	}
	
	// MARK: Utility methods
	func convertPointToCanvasCoordinates(aPoint: NSPoint) -> NSPoint {
		let localTransform = NSAffineTransform()
		if let model = model {
			localTransform.scaleXBy(model.canvasSize.width / bounds.width, yBy: model.canvasSize.height / bounds.height)
		}
		
		return localTransform.transformPoint(aPoint)
	}
	
	func convertRectToCanvasCoordinates(viewRect: NSRect) -> NSRect {
		var tmpRect = NSRect()
		let localTransform = NSAffineTransform()
		if let model = model {
			localTransform.scaleXBy(model.canvasSize.width / bounds.width, yBy: model.canvasSize.height / bounds.height)
		}
		
		tmpRect.origin = localTransform.transformPoint(viewRect.origin)
		tmpRect.size = localTransform.transformSize(viewRect.size)
		return tmpRect;
	}
	
	func convertRectToViewCoordinates(canvasRect: NSRect) -> NSRect {
		var tmpRect = NSRect()
		let localTransform = NSAffineTransform()
		if let model = model {
			localTransform.scaleXBy(bounds.width / model.canvasSize.width, yBy: bounds.height / model.canvasSize.height)
		}

		tmpRect.origin = localTransform.transformPoint(canvasRect.origin)
		tmpRect.size = localTransform.transformSize(canvasRect.size)
		return tmpRect;
	}

	private func setCrosshairCursorColor() {
		let cursorImageName: String
		
		let cursorIndex = NSUserDefaults.standardUserDefaults().integerForKey("CrosshairCursorColor")
		
		switch cursorIndex {
		case 0:
			cursorImageName = "crossRed";

		case 1:
			cursorImageName = "crossYellow";

		case 2:
			cursorImageName = "crossBlue";

		case 3:
			cursorImageName = "crossGreen";

		case 4:
			cursorImageName = "crossBlack";

		case 5:
			cursorImageName = "crossWhite";
			
		default:
			cursorImageName = "crossRed"
		}
		
		let curImg = NSImage(named: cursorImageName)!
		crosshairCursor = NSCursor(image: curImg, hotSpot:NSMakePoint(7,7))
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setCrosshairCursorColor()
		//[self setIsProcessingEvents:NO];
	}
	
	override var acceptsFirstResponder: Bool {
		return true
	}
	
	override var opaque: Bool {
		return true
	}
	
	override func resetCursorRects() {
		if let aCursor = isProcessingEvents ? crosshairCursor : NSCursor.arrowCursor() {
			addCursorRect(bounds, cursor: aCursor)
			aCursor.setOnMouseEntered( true)
		}
	}
	
	private func aqtHandleMouseDown(var location point: NSPoint, button: Int)  {
		if isProcessingEvents {
			point = convertPoint(point, fromView: nil)
			point = convertPointToCanvasCoordinates(point)
			let strEvent = "1:\(NSStringFromPoint(point)):\(button)"
			if let winDel = self.window?.delegate as? AQPlot {
				winDel.processEvent(strEvent)
			}
		}
	}

	override func mouseDown(theEvent: NSEvent) {
		aqtHandleMouseDown(location: theEvent.locationInWindow, button: 1)
	}
	
	override func rightMouseDown(theEvent: NSEvent) {
		aqtHandleMouseDown(location: theEvent.locationInWindow, button: 2)
	}
	
	override func keyDown(theEvent: NSEvent) {
		if isProcessingEvents {
			var pos = convertPoint(window?.mouseLocationOutsideOfEventStream ?? .zero, fromView: nil)
			let viewBounds = bounds
			if !NSPointInRect(pos, viewBounds) {
				// Just crop it to be inside [self bounds];
				if pos.x < 0 {
					pos.x = 0;
				} else if pos.x > viewBounds.width {
					pos.x = viewBounds.width
				}
				if pos.y < 0 {
					pos.y = 0;
				} else if pos.y > viewBounds.height {
					pos.y = viewBounds.height
				}
			}
			let eventString = "2:\(NSStringFromPoint(convertPointToCanvasCoordinates(pos))):\(theEvent.characters!):\(theEvent.keyCode)"
			if let winDel = self.window?.delegate as? AQPlot {
				winDel.processEvent(eventString)
			}
		}
	}
	
	override func drawRect(dirtyRect: NSRect) {
		if let model = model {
			let viewBounds = bounds
			let canvasSize = model.canvasSize
			var dirtyCanvasRect = NSRect()
			let transform = NSAffineTransform();
			
			NSGraphicsContext.currentContext()?.imageInterpolation = NSImageInterpolation(rawValue: UInt(NSUserDefaults.standardUserDefaults().integerForKey("ImageInterpolationLevel"))) ?? .Default
			NSGraphicsContext.currentContext()?.shouldAntialias = NSUserDefaults.standardUserDefaults().boolForKey("ShouldAntialiasDrawing")
			#if DEBUG_BOUNDS
				NSColor.redColor().set()
				NSFrameRect(dirtyRect);
			#endif
			NSRectClip(dirtyRect);
			
			// Dirty rect in view coords, clipping rect is set.
			// Need to i) set transform for subsequent operations
			// and ii) transform dirty rect to canvas coords.
			
			// (i) view transform
			transform.translateXBy(0.5, yBy:0.5); // FIXME: should this go before scale or after?
			transform.scaleXBy(viewBounds.size.width/canvasSize.width,
				yBy: viewBounds.size.height/canvasSize.height)
			transform.concat()
			
			// (ii) dirty rect transform
			transform.invert()
			dirtyCanvasRect.origin = transform.transformPoint(dirtyRect.origin)
			dirtyCanvasRect.size = transform.transformSize(dirtyRect.size)
			
			model.renderInRect(dirtyCanvasRect) // expects aRect in canvas coords, _not_ view coords
			
			#if DEBUG_BOUNDS
				NSLog("dirtyRect: %@", NSStringFromRect(dirtyRect));
				NSLog("dirtyCanvasRect: %@", NSStringFromRect(dirtyCanvasRect));
			#endif
		}
	}
}
