//
//  AQPlot.swift
//  AquaTerm
//
//  Created by C.W. Betts on 1/5/16.
//
//

import Cocoa
import AquaTerm
import AquaTerm.AQTModel
import AquaTerm.AQTProtocols

private let WINDOW_MIN_WIDTH: CGFloat = 200.0
private let WINDOW_MAX_WIDTH: CGFloat = 4096.0

//Assumes title bar height cannot change when the app is running.
//FIXME: change if/when theme support is added?
private let TITLEBAR_HEIGHT: CGFloat = {
	let frame = NSRect(x: 0, y: 0, width: 100, height: 100)
	let contentRect = NSWindow.contentRectForFrameRect(frame, styleMask: NSTitledWindowMask)
	return frame.height - contentRect.height
}()

final class AQPlot: NSObject, NSWindowDelegate, AQTClientProtocol {
	/// Points to the rendering view
	@IBOutlet weak var canvas: AQView!
	// MARK: interface additions
	@IBOutlet weak var extendSavePanelView: NSBox!
	@IBOutlet weak var saveFormatPopUp: NSPopUpButton!
	/// Holds the model for the view
	var model: AQTModel? {
		get {
			return _model
		}
		set(newModel) {
			//LOG(@"in --> %@ %s line %d", NSStringFromSelector(_cmd), __FILE__, __LINE__);
			//LOG(newModel.description);
			var viewNeedResize = true;
			if let aModel = _model, newModel = newModel {
				// Respect the windowsize set by user
				viewNeedResize = !AQTProportionalSizes(aModel.canvasSize, newModel.canvasSize);
			}
			//[model release];		// let go of any temporary model not used (unlikely)
			_model = newModel;		// Make it point to new model
			_model?.updateBounds()
			
			if isWindowLoaded {
				_aqtSetupView(shouldResize: viewNeedResize)
				_model?.invalidate() // Invalidate all of canvas
			}
			
		}
	}
	/// *Actually* holds the model for the view
	private var _model: AQTModel?
	private var isWindowLoaded = false
	var acceptingEvents = false {
		didSet {
			if isWindowLoaded {
				canvas.isProcessingEvents = acceptingEvents;
			}
		}
	}
	var client: AQTEventProtocol? = nil {
		willSet {
			if newValue?.isProxy() ?? false {
				//sshhh...
				(newValue as? AnyObject)?.setProtocolForProxy(AQTEventProtocol.self)
			}
		}
	}
	private var clientPID: pid_t = -1
	private var clientName = "No connection"
	
	// MARK: -

	func processEvent(theEvent: String) {
		if acceptingEvents // FIXME: redundant!?
		{
			TryCatchBlock({ () -> Void in
				self.client?.processEvent(theEvent, sender: self)
				}, { (anException) -> Void in
					if anException.name == NSObjectInaccessibleException {
						self.invalidateClient()
					} else {
						anException.raise()
					}
			})
		}
	}
	
	func invalidateClient() {
		
	}
	
	func appendModel(newModel: AQTModel) {
		//LOG(@"in --> %@ %s line %d", NSStringFromSelector(_cmd), __FILE__, __LINE__);
		if let model = _model {
			//LOG(newModel.description);
			let viewNeedResize = !AQTProportionalSizes(model.canvasSize, newModel.canvasSize)
			model.appendModel(newModel)
			if isWindowLoaded {
				_aqtSetupView(shouldResize: viewNeedResize)
				// FIXME: Why was the next line needed???
				// dirtyRect = backgroundDidChange?AQTRectFromSize([model canvasSize]):AQTUnionRect(dirtyRect, [newModel bounds]);
			}
		} else {
			//LOG(@"No model, passing to setModel:");
			self.model = newModel
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		cascadeWindow(orderFront: false)
		if _model != nil {
			_aqtSetupView(shouldResize: true)
			canvas.window?.makeKeyAndOrderFront(self)
		}
		isWindowLoaded = true
	}
	
	func cascadeWindow(orderFront orderFront: Bool) {
		(NSApp.delegate as? AQController)?.setWindowPos(canvas.window!)
		if orderFront {
			canvas.window?.makeKeyAndOrderFront(self)
		}
	}

	func draw() {
		
	}
	
	func close() {
		
	}
	
	/// This is a "housekeeping" method, to avoid buildup of hidden objects, does not imply redraw(?)
	func removeGraphicsInRect(aRect: AQTRect) {
		model?.removeGraphicsInRect(aRect)
	}
	
	func timingTestWithTag(tag: UInt32) {
		
	}

	private func _aqtSetupView(shouldResize shouldResize: Bool) {
		let windowFrame = canvas.window!.frame;
		let windowTopLeft = NSPoint(x: windowFrame.minX, y: windowFrame.maxY)
		let contentSize = model!.canvasSize
		var windowSize = contentSize
		windowSize.height += TITLEBAR_HEIGHT
		// FIXME: Better handling of min/max size
		let maxSize = NSSize(width: WINDOW_MAX_WIDTH, height: WINDOW_MAX_WIDTH*contentSize.height/contentSize.width + TITLEBAR_HEIGHT);
		let minSize = NSSize(width: WINDOW_MIN_WIDTH, height: WINDOW_MIN_WIDTH*contentSize.height/contentSize.width + TITLEBAR_HEIGHT);
		let ratio = windowSize;
		
		canvas.model = model;
		canvas.setFrameOrigin(.zero)
		if clientPID != -1 {
			var newTitle = NSUserDefaults.standardUserDefaults().boolForKey("ShowProcessName") ? "\(clientName) " : ""
			newTitle += NSUserDefaults.standardUserDefaults().boolForKey("ShowProcessId") ? "\(clientPID)": ""
			newTitle += model!.title
			canvas.window?.title = newTitle
		} else {
			canvas.window!.title = model!.title;
		}
		
		if (shouldResize) {
			let contentFrame = NSRect(origin: .zero, size: contentSize)
			canvas.window?.setContentSize(contentSize)
			canvas.window?.setFrameTopLeftPoint(windowTopLeft)
			canvas.frame = contentFrame;
			canvas.window?.aspectRatio = ratio;
		}
		canvas.window?.maxSize = maxSize;   // FIXME: take screen size into account
		canvas.window?.minSize = minSize;
		canvas.isProcessingEvents = acceptingEvents;
	}
	
	func setClientInfoName(name: String, pid: pid_t) {
		clientName = name;
		clientPID = pid;
	}

}
