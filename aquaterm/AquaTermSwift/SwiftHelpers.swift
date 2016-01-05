//
//  SwiftHelpers.swift
//  AquaTerm
//
//  Created by C.W. Betts on 1/5/16.
//
//

import Cocoa
import AquaTerm

public func ==(lhs: AQTColor, rhs: AQTColor) -> Bool {
	return AQTEqualColors(lhs, rhs)
}

extension AQTColor: Equatable {
	var cocoaColor: NSColor {
		return NSColor(calibratedRed: CGFloat(self.red), green: CGFloat(self.green), blue: CGFloat(self.blue), alpha: CGFloat(self.alpha))
	}
}
