//
//  SwiftHelpers.swift
//  AquaTerm
//
//  Created by C.W. Betts on 1/5/16.
//
//

import Cocoa
import AquaTerm
import AquaTerm.AQTFunctions
import AquaTerm.AQTModel.AQTGraphic

public func ==(lhs: AQTColor, rhs: AQTColor) -> Bool {
	return AQTEqualColors(lhs, rhs)
}

extension AQTColor: Equatable {
	var cocoaColor: NSColor {
		return NSColor(calibratedRed: CGFloat(self.red), green: CGFloat(self.green), blue: CGFloat(self.blue), alpha: CGFloat(self.alpha))
	}
}

#if false
let OurNSExceptionErrorDomain = "NSException Domain"
let OurNSExceptionErrorKey = "NSException Key"

func tryCatchExceptionsRethrowAsError(block: () -> Void) throws {
	var exception: NSException?
	
	TryCatchBlock(block) { (except) -> Void in
		exception = except
	}
	
	if let exception = exception {
		throw NSError(domain: OurNSExceptionErrorDomain, code: 0, userInfo: [OurNSExceptionErrorKey: exception])
	}
}
#endif
