//
//  AQTAdapter.swift
//  AquaTerm
//
//  Created by C.W. Betts on 8/14/16.
//  Copyright © 2016 AquaTerm Team. All rights reserved.
//

import Foundation
import AquaTerm
import AquaTerm.AQTAdapter

extension AQTAdapter {
	public var color: (red: Float, green: Float, blue: Float, alpha: Float) {
		get {
			var r: Float = 0
			var g: Float = 0
			var b: Float = 0
			var a: Float = 0
			getColor(red: &r, green: &g, blue: &b, alpha: &a)
			return (r, g, b, a)
		} set {
			setColor(red: newValue.red, green: newValue.green, blue: newValue.blue, alpha: newValue.alpha)
		}
	}
	
	public var backgroundColor: (red: Float, green: Float, blue: Float, alpha: Float) {
		get {
			var r: Float = 0
			var g: Float = 0
			var b: Float = 0
			var a: Float = 0
			getBackgroundColor(red: &r, green: &g, blue: &b, alpha: &a)
			return (r, g, b, a)
		} set {
			setBackgroundColor(red: newValue.red, green: newValue.green, blue: newValue.blue, alpha: newValue.alpha)
		}
	}
	
	@nonobjc public func addPolyline(points: [NSPoint]) {
		var points1 = points
		__addPolyline(with: &points1, pointCount: points.count)
	}
	
	@nonobjc public func addPolygon(vertexPoints vp: [NSPoint]) {
		var points1 = vp
		__addPolygon(withVertexPoints: &points1, pointCount: vp.count)
	}
}
