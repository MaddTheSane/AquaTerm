//
//  AQController.swift
//  AquaTerm
//
//  Created by C.W. Betts on 1/5/16.
//  Copyright © 2016 AquaTerm Team. All rights reserved.
//

import Cocoa
import AquaTerm
import AquaTerm.AQTProtocols

@NSApplicationMain
class AQController: NSObject, NSApplicationDelegate, AQTConnectionProtocol {
	private var cascadingPoint: NSPoint = {
		var screenFrame = NSScreen.mainScreen()!.visibleFrame;
		//handlerList = [[NSMutableArray alloc] initWithCapacity:256];
		return NSPoint(x: screenFrame.minX, y: screenFrame.maxY)
	}()
	
	func ping() {
		
	}
	
	func getServerVersionMajor(major: UnsafeMutablePointer<Int32>, minor: UnsafeMutablePointer<Int32>, rev: UnsafeMutablePointer<Int32>) {
		major.memory = 1
		minor.memory = 0
		rev.memory = 0
	}
	
	func addAQTClient(client: AnyObject?, name: String, pid procId: pid_t) -> AnyObject {
		
		
		return NSObject()
	}

	func setWindowPos(plotWindow: NSWindow) {
		cascadingPoint = plotWindow.cascadeTopLeftFromPoint(cascadingPoint)
	}

}
