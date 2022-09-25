//
//  AQTHelpers.swift
//  AquaTerm
//
//  Created by C.W. Betts on 2/26/16.
//  Copyright © 2016 AquaTerm Team. All rights reserved.
//

import Foundation

extension AQTColor: Equatable, CustomPlaygroundDisplayConvertible {
	@inlinable static public func ==(lhs: AQTColor, rhs: AQTColor) -> Bool {
		return AQTEqualColors(lhs, rhs)
	}
   
	public var playgroundDescription: Any {
		return NSColor(calibratedRed: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
	}
}

extension AQTPoint: CustomPlaygroundDisplayConvertible {
	public var playgroundDescription: Any {
		return NSPoint(x: CGFloat(self.x), y: CGFloat(self.y))
	}
}

extension AQTSize: CustomPlaygroundDisplayConvertible {
	public var playgroundDescription: Any {
		return NSSize(width: CGFloat(self.width), height: CGFloat(self.height))
	}
}

extension AQTRect: CustomPlaygroundDisplayConvertible {
	public var playgroundDescription: Any {
		return NSRect(x: CGFloat(self.origin.x), y: CGFloat(self.origin.y), width: CGFloat(self.size.width), height: CGFloat(self.size.height))
	}
}
