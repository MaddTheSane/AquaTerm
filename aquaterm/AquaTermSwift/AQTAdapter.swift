//
//  AQTAdapter.swift
//  AquaTerm
//
//  Created by C.W. Betts on 8/14/16.
//  Copyright © 2016 AquaTerm Team. All rights reserved.
//

import Foundation
import AppKit
import AquaTerm
import AquaTerm.AQTAdapter

extension AQTAdapter {
	/// The current RGB color components.
	@objc open var color: AQTColor {
		get {
			var r: Float = 0
			var g: Float = 0
			var b: Float = 0
			var a: Float = 0
			getColor(red: &r, green: &g, blue: &b, alpha: &a)
			return AQTColor(red: r, green: g, blue: b, alpha: a)
		} set {
			setColor(red: newValue.red, green: newValue.green, blue: newValue.blue, alpha: newValue.alpha)
		}
	}
	
	/// The background color components.
	@objc open var backgroundColor: AQTColor {
		get {
			var r: Float = 0
			var g: Float = 0
			var b: Float = 0
			var a: Float = 0
			getBackgroundColor(red: &r, green: &g, blue: &b, alpha: &a)
			return AQTColor(red: r, green: g, blue: b, alpha: a)
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
	/// By using
	/// `NSAttributedString` a subset of the attributes defined in AppKit may be 
	/// used to format the string beyond the fontface ans size. The currently supported 
	/// attributes are:
	/// * {Attribute value}
	/// * {@"NSSuperScript" raise-level}
	/// * {@"NSUnderline" `0` or `1`}
	/// - parameter text: The text to show.
	/// - parameter pos: The location to show the text.
	/// - parameter angle: The angle, in degrees, to rotate the text.<br> Default is `0`.
	/// - parameter shearAngle: The angle to shear the text. Useful for e.g. 3D plot labels.<br>
	/// Default is `0`.
	/// - parameter just: Alignment of the text.<br> Default is `[.baseline]`.
	@nonobjc open func addLabel(_ text: NSAttributedString, at pos: NSPoint, angle: CGFloat = 0, shearAngle: CGFloat = 0, align just: AQTAlign = [.baseline]) {
		__addLabel(text, at: pos, angle: angle, shearAngle: shearAngle, align: just)
	}
		
	/// Add `text` at coordinate given by `pos`, rotated by `angle` degrees and aligned
	/// vertically and horisontally (with respect to pos and rotation) according to
	/// `align`. Horizontal and vertical `align` may be combined, e.g.
	/// `[.center, .middle]`.
	///
	/// By specifying `shearAngle` the text may be sheared in order to appear correctly
	/// in e.g. 3D plot labels.
	///
	/// By using
	/// `AttributedString` the attributes defined in `AquaTermAttributes` may be
	/// used to format the string beyond the fontface ans size.
	/// - parameter text: The text to show.
	/// - parameter pos: The location to show the text.
	/// - parameter angle: The angle, in degrees, to rotate the text.<br> Default is `0`.
	/// - parameter shearAngle: The angle to shear the text. Useful for e.g. 3D plot labels.<br>
	/// Default is `0`.
	/// - parameter just: Alignment of the text.<br> Default is `[.baseline]`.
	@available(macOS 12, *)
	@nonobjc open func addLabel(_ text: AttributedString, at pos: NSPoint, angle: CGFloat = 0, shearAngle: CGFloat = 0, align just: AQTAlign = [.baseline]) {
		__addLabel(try! NSAttributedString(text, including: AttributeScopes.AquaTermAttributes.self), at: pos, angle: angle, shearAngle: shearAngle, align: just)
	}
	
	/// Add `text` at coordinate given by `pos`, rotated by `angle` degrees and aligned
	/// vertically and horisontally (with respect to pos and rotation) according to
	/// `align`. Horizontal and vertical `align` may be combined, e.g.
	/// `[.center, .middle]`.
	///
	/// By specifying `shearAngle` the text may be sheared in order to appear correctly
	/// in e.g. 3D plot labels.
	///
	/// - parameter text: The text to show.
	/// - parameter pos: The location to show the text.
	/// - parameter angle: The angle, in degrees, to rotate the text.<br> Default is `0`.
	/// - parameter shearAngle: The angle to shear the text. Useful for e.g. 3D plot labels.<br>
	/// Default is `0`.
	/// - parameter just: Alignment of the text.<br> Default is `[.baseline]`.
	@nonobjc open func addLabel(_ text: String, at pos: NSPoint, angle: CGFloat = 0, shearAngle: CGFloat = 0, align just: AQTAlign = [.baseline]) {
		__addLabel(text, at: pos, angle: angle, shearAngle: shearAngle, align: just)
	}


	/// Set the current line style to pattern style, used for all subsequent lines. The linestyle is specified as a
	/// pattern, an array of at most 8 float, where even positions correspond to dash-lengths and odd positions
	/// correspond to gap-lengths. To produce e.g. a dash-dotted line, use the pattern `[4.0, 2.0, 1.0, 2.0]`.
	@nonobjc open func setLinestylePattern(_ newPattern: [CGFloat], phase newPhase: CGFloat) {
		setLinestylePattern(newPattern.map({Float($0)}), phase: Float(newPhase))
	}

	/// Set the current line style to pattern style, used for all subsequent lines. The linestyle is specified as a
	/// pattern, an array of at most 8 float, where even positions correspond to dash-lengths and odd positions
	/// correspond to gap-lengths. To produce e.g. a dash-dotted line, use the pattern `[4.0, 2.0, 1.0, 2.0]`.
	@nonobjc open func setLinestylePattern(_ newPattern: [Float], phase newPhase: Float) {
		var newFPattern = newPattern
		
		setLinestylePattern(&newFPattern, count: newFPattern.count, phase: newPhase)
	}
}

@available(macOS 12, *)
public extension AttributeScopes {
	var aquaTerm: AttributeScopes.AquaTermAttributes.Type {
		return AquaTermAttributes.self
	}
	
	struct AquaTermAttributes: AttributeScope {
		public let fontName: FontNameAttribute
		
		public let fontSize: FontSizeAttribute

		public let baselineAdjust: BaselineAdjustAttribute
		
		public let nonPrinting: NonPrintingAttribute
		
		public let superscript: AttributeScopes.AppKitAttributes.SuperscriptAttribute

		public let underline: AttributeScopes.AppKitAttributes.UnderlineStyleAttribute

		@frozen public enum FontNameAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey, Sendable {
			public typealias ObjectiveCValue = NSString
			public typealias Value = String
			
			public static func objectiveCValue(for value: String) throws -> NSString {
				return value as NSString
			}
			
			public static func value(for object: NSString) throws -> String {
				return object as String
			}
			
			public static let name: String = NSAttributedString.Key.aqtFontName.rawValue
		}

		@frozen public enum FontSizeAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			public typealias ObjectiveCValue = NSNumber
			public typealias Value = CGFloat

			public static func objectiveCValue(for value: CGFloat) throws -> NSNumber {
				return value as NSNumber
			}
			
			public static func value(for object: NSNumber) throws -> CGFloat {
				return object.doubleValue
			}
			
			public static let name: String = NSAttributedString.Key.aqtFontSize.rawValue
		}

		@frozen public enum BaselineAdjustAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			public typealias ObjectiveCValue = NSNumber
			public typealias Value = CGFloat

			public static func objectiveCValue(for value: CGFloat) throws -> NSNumber {
				return value as NSNumber
			}
			
			public static func value(for object: NSNumber) throws -> CGFloat {
				return object.doubleValue
			}

			public static let name: String = NSAttributedString.Key.aqtBaselineAdjust.rawValue
		}

		@frozen public enum NonPrintingAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			public typealias ObjectiveCValue = NSNumber
			public typealias Value = Bool

			public static func objectiveCValue(for value: Bool) throws -> NSNumber {
				return value as NSNumber
			}
			
			public static func value(for object: NSNumber) throws -> Bool {
				return object.boolValue
			}

			public static let name: String = NSAttributedString.Key.aqtNonPrintingChar.rawValue
		}
		
		public typealias DecodingConfiguration = AttributeScopeCodableConfiguration

		public typealias EncodingConfiguration = AttributeScopeCodableConfiguration
	}
}

@available(macOS 12, *)
public extension AttributeDynamicLookup {
	subscript<T>(dynamicMember keyPath: KeyPath<AttributeScopes.AquaTermAttributes, T>) -> T where T : AttributedStringKey {
		return self[T.self]
	}
}
