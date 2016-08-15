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
}
