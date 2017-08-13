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
	open var color: (red: Float, green: Float, blue: Float, alpha: Float) {
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
	
	open var backgroundColor: (red: Float, green: Float, blue: Float, alpha: Float) {
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
	
	/// Add a sequence of line segments specified by a list of start-, end-, 
	/// and joinpoint(s) in points.
	/// - parameter points: the polyline points to add.
	@nonobjc open func addPolyline(points: [NSPoint]) {
		var points1 = points
		__addPolyline(with: &points1, pointCount: points.count)
	}
	
	/// Add a polygon specified by a list of corner points.
	/// - parameter vp: the corner points.
	@nonobjc open func addPolygon(vertexPoints vp: [NSPoint]) {
		var points1 = vp
		__addPolygon(withVertexPoints: &points1, pointCount: vp.count)
	}
	
	/// Add `text` at coordinate given by `pos`, rotated by `angle` degrees and aligned 
	/// vertically and horisontally (with respect to pos and rotation) according to 
	/// `align`. Horizontal and vertical `align` may be combined, e.g.
	/// `[.center, .middle]`.
	///
	/// By specifying `shearAngle` the text may be sheared in order to appear correctly 
	/// in e.g. 3D plot labels.
	///
	/// The `text` can be either an `NSString` or an `NSAttributedString`. By using
	/// `NSAttributedString` a subset of the attributes defined in AppKit may be 
	/// used to format the string beyond the fontface ans size. The currently supported 
	/// attributes are:
	/// * {Attribute value}
	/// * {@"NSSuperScript" raise-level}
	/// * {@"NSUnderline" 0or1}
	/// - parameter text: The text to show. May be either `NSString` or `NSAttributedString`.
	/// - parameter pos: The location to show the text.
	/// - parameter angle: The angle, in degrees, to rotate the text. Default is `0`.
	/// - parameter shearAngle: The angle to shear the text. Useful for e.g. 3D plot labels. 
	/// Default is `0`.
	/// - parameter just: Alignment of the text. Default is `[.baseline]`.
	open func addLabel(_ text: Any, at pos: NSPoint, angle: CGFloat = 0, shearAngle: CGFloat = 0, align just: AQTAlign = [.baseline]) {
		__addLabel(text, at: pos, angle: angle, shearAngle: shearAngle, align: just)
	}

	open func setLinestylePattern(_ newPattern: [CGFloat], phase newPhase: CGFloat) {
		var newFPattern = newPattern.map { (val1) -> Float in
			return Float(val1)
		}
		
		setLinestylePattern(&newFPattern, count: newFPattern.count, phase: Float(newPhase))
	}

}
