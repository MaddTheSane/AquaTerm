//
//  AQPlot.swift
//  AquaTerm
//
//  Created by C.W. Betts on 1/5/16.
//
//

import Cocoa

class AQPlot: NSObject, NSWindowDelegate {
	/// Points to the rendering view
	@IBOutlet weak var canvas: AQView!
	// MARK: interface additions
	@IBOutlet weak var extendSavePanelView: NSBox!
	@IBOutlet weak var saveFormatPopUp: NSPopUpButton!
	// MARK: -
/*
AQTModel	*model;		/*" Holds the model for the view "*/
BOOL _isWindowLoaded;
BOOL _acceptingEvents;
id <NSObject, AQTEventProtocol> _client;
int32_t _clientPID;
NSString *_clientName;
*/

	func processEvent(theEvent: String) {
		
	}
}
