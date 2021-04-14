//
//  AQTPath.swift
//  AquaTerm
//
//  Created by C.W. Betts on 8/15/16.
//  Copyright © 2016 AquaTerm Team. All rights reserved.
//

import Foundation
import AquaTerm
import AquaTerm.AQTGraphic.AQTPath

extension AQTPath {
	@nonobjc public convenience init(points: [NSPoint]) {
		var points1 = points
		
		self.init(points: &points1, pointCount: Int32(points.count))
	}
	
	/// Set the current line style to pattern style, used for all subsequent lines. The linestyle is specified as a
	/// pattern, an array of at most 8 float, where even positions correspond to dash-lengths and odd positions
	/// correspond to gap-lengths. To produce e.g. a dash-dotted line, use the pattern `[4.0, 2.0, 1.0, 2.0]`.
	@nonobjc open func setLinestylePattern(_ newPattern: [CGFloat], phase newPhase: CGFloat) {
		var newFPattern = newPattern.map({Float($0)})
		
		setLinestylePattern(&newFPattern, count: Int32(newFPattern.count), phase: newPhase)
	}
}
