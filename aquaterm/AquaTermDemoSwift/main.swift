//
//  main.swift
//  AquaTermDemoSwift
//
//  Created by C.W. Betts on 1/6/16.
//  Copyright © 2016 AquaTerm Team. All rights reserved.
//

import Foundation
import AquaTerm
import AquaTerm.AQTAdapter
//import AquaTermSwift

extension NSPoint {
	fileprivate init(x: Float, y: Float) {
		self.x = CGFloat(x)
		self.y = CGFloat(y)
	}
}

let adapter = AQTAdapter()!
var pos = NSPoint()
//var i = 0
var f: Float = 0
//let pi = 4.0*atan(1.0)
//let pi = M_PI
let rgbImage: [UInt8] = [
	255, 0, 0,
	0, 255, 0,
	0, 0, 255,
	0, 0, 0
];
adapter.openPlot(with: 1)
adapter.plotSize =  NSSize(width: 620, height: 420)
adapter.plotTitle = "TestView"
adapter.setAcceptingEvents(true)

// Set colormap
adapter.setColormapEntry(0, red: 1.0, green: 1.0, blue: 1.0) // white
adapter.setColormapEntry(1, red: 0.0, green: 0.0, blue: 0.0) //black
adapter.setColormapEntry(2, red: 1.0, green: 0.0, blue: 0.0) // red
adapter.setColormapEntry(3, red: 0.0, green: 1.0, blue: 0.0) // green
adapter.setColormapEntry(4, red: 0.0, green: 0.0, blue: 1.0) // blue
adapter.setColormapEntry(5, red: 1.0, green: 0.0, blue: 1.0) // purple
adapter.setColormapEntry(6, red: 1.0, green: 1.0, blue: 0.5) // yellow
adapter.setColormapEntry(7, red: 0.0, green: 0.5, blue: 0.5) // dark green
// Set color directly
adapter.setColor(red: 0, green: 0, blue: 0)
adapter.fontName = "Helvetica"
adapter.fontSize = 12.0
adapter.addLabel("Testview 620x420 pt", at: NSPoint(x: 4, y: 412), angle: 0.0, align: [])
	// MARK: Frame plot
adapter.move(to: NSPoint(x: 20,y: 20))
adapter.addLine(to: NSPoint(x: 600, y: 20))
adapter.addLine(to: NSPoint(x: 600, y: 400))
adapter.addLine(to: NSPoint(x: 20, y: 400))
adapter.addLine(to: NSPoint(x: 20, y: 20))
adapter.addLabel("Frame 600x400 pt", at: NSPoint(x: 24, y: 30), angle: 0.0, align: [])
	// MARK: Colormap
adapter.addLabel("Custom colormap (8 out of 256)", at: NSPoint(x: 30, y: 385), angle: 0.0, align: [])
// Display the colormap, but first create a background for the white box...
adapter.setColor(red: 0.8, green: 0.8, blue: 0.8)
adapter.addFilledRect(NSRect(x: 28, y: 348, width: 24, height: 24))
for i in 0..<8 {
	adapter.takeColor(fromColormapEntry: Int32(i))
	adapter.addFilledRect(NSRect(x: 30 + i * 30, y: 350, width: 20, height: 20))
	// Print the color index
	adapter.setColor(red: 0.5, green: 0.5, blue: 0.5)
	adapter.addLabel("\(i)" as NSString,
	                 at: NSPoint(x: 40 + i * 30, y: 360),
	                 angle: 0,
	                 align: .center)
}
	// MARK: Continuous colors
adapter.takeColor(fromColormapEntry: 1)
adapter.addLabel("\"Any color you like\"", at: NSPoint(x: 320, y: 385), angle: 0.0, align: [])
adapter.lineWidth = 1.0
for i in 0..<256 {
	f = Float(i) / 255.0
	adapter.setColor(red: 1.0, green: f, blue: f / 2.0)
	adapter.addFilledRect(NSRect(x: 320 + i, y: 350, width: 1, height: 20))
	adapter.setColor(red: 0.0, green: f, blue: 1.0 - f)
	adapter.addFilledRect(NSRect(x: 320 + i, y: 328, width: 1, height: 20))
	adapter.setColor(red: 1.0 - f, green:1.0 - f, blue: 1.0 - f)
	adapter.addFilledRect(NSRect(x: 320 + i, y: 306, width: 1, height: 20))
}

	// MARK: Lines
let pat: [[Float]] = [[4,2,4,2],[4,2,2,2],[8,4,8,4],[2,2,2,2]]

adapter.takeColor(fromColormapEntry: 1)
adapter.addLabel("Specify linewidth and pattern", at: NSPoint(x: 30, y: 325))
for f2 in stride(from: 1, to: 13, by: 2) {
	f = Float(f2)
	let lw = f/2.0;
	adapter.lineWidth = CGFloat(round(lw - 0.5))
	adapter.setLinestylePattern(pat[f2 % 3], count: 4, phase: 0.0)
	adapter.move(to: NSPoint(x: 30, y: 200.5 + f * 10))
	adapter.addLine(to: NSPoint(x: 180, y: 200.5 + f * 10))
}
adapter.setLinestyleSolid()

	// MARK: Clip rect
autoreleasepool() {
	let r = NSMakeRect(200, 200, 60, 120);
	adapter.addLabel("Clip rects", at:NSPoint(x: 200, y: 325))
	adapter.setColor(red: 0.9, green:0.9, blue:0.9)
	adapter.addFilledRect(r)
	adapter.setColor(red: 0, green:0, blue:0)
	adapter.clipRect = r
	adapter.addLabel("Clipped text. Clipped text. Clipped text.", at: NSMakePoint(180, 230), angle: 30.0, align: [.center])
	adapter.lineWidth = 1.0
	var points = Array<Int>(0..<5).map { (i) -> NSPoint in
		let radians = Double(i) * .pi * 0.8
		let r = 30.0
		return NSPoint(x: 240.0 + r * cos(radians), y: 215.0 + r * sin(radians));
	}
	adapter.takeColor(fromColormapEntry: 3)
	adapter.addPolygon(vertexPoints: points)
	adapter.takeColor(fromColormapEntry: 1)
	points.append(points.first!)
	adapter.addPolyline(points: points)
	adapter.addImage(withBitmap: rgbImage, size: NSSize(width: 2, height: 2), bounds: NSRect(x: 190, y: 280, width: 50, height: 50)) // ClipRect demo
	adapter.setDefaultClipRect()
	
	// ***** Reset clip rect! *****
}
	// MARK: linecap styles
do {
	adapter.fontSize = 8
	adapter.lineWidth = 11
	adapter.takeColor(fromColormapEntry: 1)
	adapter.lineCapStyle = .butt
	adapter.move(to: NSPoint(x: 40.5, y: 170.5))
	adapter.addLine(to: NSPoint(x: 150.5, y: 170.5))
	adapter.addLabel("AQTLineCapStyle.Butt", at: NSMakePoint(160.5, 170.5), angle: 0.0, align: [])
	adapter.lineWidth = 1.0
	adapter.takeColor(fromColormapEntry: 6)
	adapter.move(to: NSPoint(x: 40.5, y: 170.5))
	adapter.addLine(to: NSPoint(x: 150.5, y: 170.5))
	
	adapter.lineWidth = 11
	adapter.takeColor(fromColormapEntry: 1)
	adapter.lineCapStyle = .round
	adapter.move(to: NSPoint(x: 40.5, y: 150.5))
	adapter.addLine(to: NSPoint(x: 150.5, y: 150.5))
	adapter.addLabel("AQTLineCapStyle.Round", at: NSPoint(x: 160.5, y: 150.5), angle: 0.0, align: [])
	adapter.lineWidth = 1.0
	adapter.takeColor(fromColormapEntry: 6)
	adapter.move(to: NSPoint(x: 40.5, y: 150.5))
	adapter.addLine(to: NSPoint(x: 150.5, y: 150.5))
	
	adapter.lineWidth = 11
	adapter.takeColor(fromColormapEntry: 1)
	adapter.lineCapStyle = .square
	adapter.move(to: NSPoint(x: 40.5, y: 130.5))
	adapter.addLine(to: NSPoint(x: 150.5, y: 130.5))
	adapter.addLabel("AQTLineCapStyle.Square", at: NSPoint(x: 160.5, y: 130.5), angle: 0.0, align: [])
	adapter.lineWidth = 1.0
	adapter.takeColor(fromColormapEntry: 6)
	adapter.move(to: NSPoint(x: 40.5, y: 130.5))
	adapter.addLine(to: NSPoint(x: 150.5, y: 130.5))
	adapter.fontSize = 12
}

	// MARK: line joins
adapter.takeColor(fromColormapEntry: 1)
adapter.addLabel("Line joins:", at: NSPoint(x: 40, y: 90), angle: 0.0, align: [])
adapter.lineWidth = 11
adapter.lineCapStyle = .butt
adapter.move(to: NSPoint(x: 40, y: 50))
adapter.addLine(to: NSPoint(x: 75, y: 70))
adapter.addLine(to: NSPoint(x: 110, y: 50))
adapter.lineWidth = 1
adapter.takeColor(fromColormapEntry: 6)
adapter.move(to: NSPoint(x: 40, y: 50))
adapter.addLine(to: NSPoint(x: 75, y: 70))
adapter.addLine(to: NSPoint(x: 110, y: 50))

adapter.lineWidth = 11
adapter.takeColor(fromColormapEntry: 1)
adapter.move(to: NSPoint(x: 130, y: 50))
adapter.addLine(to: NSPoint(x: 150, y: 70))
adapter.addLine(to: NSPoint(x: 170, y: 50))
adapter.lineWidth = 1
adapter.takeColor(fromColormapEntry: 6)
adapter.move(to: NSPoint(x: 130, y: 50))
adapter.addLine(to: NSPoint(x: 150, y: 70))
adapter.addLine(to: NSPoint(x: 170, y: 50))

adapter.lineWidth = 11
adapter.takeColor(fromColormapEntry: 1)
adapter.lineCapStyle = .butt
adapter.move(to: NSPoint(x: 190, y: 50))
adapter.addLine(to: NSPoint(x: 200, y: 70))
adapter.addLine(to: NSPoint(x: 210, y: 50))
adapter.lineWidth = 1
adapter.takeColor(fromColormapEntry: 6)
adapter.move(to: NSPoint(x: 190, y: 50))
adapter.addLine(to: NSPoint(x: 200, y: 70))
adapter.addLine(to: NSPoint(x: 210, y: 50))

	// MARK: Polygons
do {
	adapter.takeColor(fromColormapEntry: 1)
	adapter.addLabel("Polygons", at: NSPoint(x: 320, y: 290), angle: 0.0, align: [])
	var points = Array<Int>(0..<4).map { (i) -> NSPoint in
		let radians=Double(i)*Double.pi/2.0
		let r=20.0;
		return NSPoint(x: 340.0 + r * cos(radians), y: 255.0 + r * sin(radians))
	}
	adapter.takeColor(fromColormapEntry: 2)
	adapter.addPolygon(vertexPoints: Array(points[0..<4]))
	points = Array<Int>(0..<5).map { (i) -> NSPoint in
		let radians = Double(i) * Double.pi * 0.8
		let r = 20.0
		return NSPoint(x: 400.0 + r * cos(radians), y: 255.0 + r * sin(radians))
	}
	adapter.takeColor(fromColormapEntry: 3)
	adapter.addPolygon(vertexPoints: points)
	adapter.takeColor(fromColormapEntry: 1)
	points.append(points[0])
	adapter.addPolygon(vertexPoints: points)
	points = Array<Int>(0..<8).map { (i) -> NSPoint in
		let radians = Double(i) * Double.pi / 4.0
		let r = 20.0;
		return NSPoint(x: 460.0 + r * cos(radians), y: 255.0 + r * sin(radians))
	}
	adapter.takeColor(fromColormapEntry: 4)
	adapter.addPolygon(vertexPoints: points)
	
	// Circles with alpha transparency
	adapter.takeColor(fromColormapEntry: 1)
	adapter.addLabel("Alpha channel", at: NSPoint(x: 530, y: 290), angle: 0.0, align: .center)
	do {
		let circleInfo: [(x: Double, y: Double, red: Float, green: Float, blue: Float)] = [
			(520, 255, 1, 0, 0),
			(540, 245, 0, 1, 0),
			(540, 265, 0, 0, 1)]
		
		for (x, y, red, green, blue) in circleInfo {
			let points = Array<Int>(0..<32).map { (i) -> NSPoint in
				let radians = Double(i) * Double.pi / 16.0, r = 20.0;
				return NSPoint(x: x + r * cos(radians), y: y + r * sin(radians))
			}
			adapter.setColor(red: red, green: green, blue: blue, alpha: 0.5)
			adapter.addPolygon(vertexPoints: points)
		}
	}
}
	// MARK: Images
adapter.takeColor(fromColormapEntry: 1)
adapter.addLabel("Images", at: NSPoint(x: 320, y: 220), angle: 0.0, align: [])
adapter.addImage(withBitmap: rgbImage, size: NSSize(width: 2, height: 2), bounds: NSRect(x: 328, y: 200, width: 4, height: 4))
adapter.addLabel("bits", at: NSPoint(x: 330, y: 180), angle: 0.0, align: .center)
adapter.addImage(withBitmap: rgbImage, size: NSSize(width: 2, height: 2), bounds: NSRect(x: 360, y: 190, width: 40, height: 15))
adapter.addLabel("fit bounds", at: NSPoint(x: 380, y: 180), angle: 0.0, align: .center)
adapter.setImageTransformM11(9.23880, m12: 3.82683, m21: -3.82683, m22: 9.23880, tX: 494.6, tY: 186.9)
adapter.addTransformedImage(withBitmap: rgbImage, size: NSSize(width: 2, height: 2), clipRect: NSRect(x: 0, y: 0, width: 600, height: 400))
adapter.addLabel("scale, rotate & translate", at: NSPoint(x: 500, y: 180), angle: 0.0, align: .center)
adapter.resetImageTransform() // clean up

	// MARK: Text
do {
	adapter.fontName = "Times-Roman"
	//NSString *s = [[NSString alloc] initWithFormat:@"Unicode: %C %C %C %C%C%C%C%C", (unichar)0x2124, (unichar)0x2133, (unichar)0x5925, (unichar)0x2654, (unichar)0x2655, (unichar)0x2656, (unichar)0x2657, (unichar)0x2658];
	let s = "Unicode: \u{2124} \u{2133} \u{5925} \u{2654}\u{2655}\u{2656}\u{2657}\u{2658}";
	let attrStr = NSMutableAttributedString(string: s)
	attrStr.setAttributes(["AQTFontname": "AppleSymbols"], range: NSMakeRange(9,11))
	attrStr.setAttributes(["AQTFontname": "STSong"], range: NSMakeRange(13,1))
	
	adapter.takeColor(fromColormapEntry: 1)
	adapter.fontName = "Times-Roman"
	adapter.fontSize = 12.0
	adapter.addLabel(attrStr, at: NSPoint(x: 320, y: 150))
	//[adapter addLabel:@"Times-Roman 16pt" atPoint:NSMakePoint(320, 150) angle:0.0 align:AQTAlignLeft];
	adapter.takeColor(fromColormapEntry: 2)
	adapter.fontName = "Times-Italic"
	adapter.fontSize = 16.0
	adapter.addLabel("Times-Italic 16pt", at: NSPoint(x: 320, y: 130), angle: 0.0, align: [])
	adapter.takeColor(fromColormapEntry: 4)
	adapter.fontName = "Zapfino"
	adapter.fontSize = 12.0
	adapter.addLabel("Zapfino 12pt", at: NSPoint(x: 320, y: 104), angle: 0.0, align: [])
	
	adapter.takeColor(fromColormapEntry: 2)
	adapter.lineWidth = 0.5
	adapter.move(to: NSPoint(x: 510.5, y: 160))
	adapter.addLine(to: NSPoint(x: 510.5, y: 100))
	pos = NSPoint(x: 540.5, y: 75.5);
	adapter.move(to: NSPoint(x: pos.x + 5, y: pos.y))
	adapter.addLine(to: NSPoint(x: pos.x - 5, y: pos.y))
	adapter.move(to: NSPoint(x: pos.x, y: pos.y + 5))
	adapter.addLine(to: NSPoint(x: pos.x, y: pos.y - 5))
	
	adapter.takeColor(fromColormapEntry: 1)
	adapter.fontName = "Verdana"
	adapter.fontSize = 10.0
	adapter.addLabel("left align", at: NSPoint(x: 510.5, y: 150), angle: 0.0, align: [])
	adapter.addLabel("centered", at: NSPoint(x: 510.5, y: 130), angle: 0.0, align: .center)
	adapter.addLabel("right align", at: NSPoint(x: 510.5, y: 110), angle: 0.0, align: .right)
	adapter.fontName = "Times-Roman"
	adapter.fontSize = 14.0
	adapter.addLabel("-rotate", at: pos, angle: 90.0, align: [])
	adapter.addLabel("-rotate", at: pos, angle: 45.0, align: [])
	adapter.addLabel("-rotate", at: pos, angle: -30.0, align: [])
	adapter.addLabel("-rotate", at: pos, angle: -60.0, align: [])
	adapter.addLabel("-rotate", at: pos, angle: -90.0, align: [])
	// Shear
	adapter.fontName = "Arial"
	adapter.fontSize = 12.0
	adapter.addLabel("Rotate & shear", at: NSPoint(x: 430, y: 105), angle:45.0, shearAngle: 45.0, align: [])
}

	// MARK: Some styling is possible
autoreleasepool() {
	let attrStr = NSMutableAttributedString(string: "Underline, super- and subscript123")
	attrStr.addAttribute("NSUnderline", value:1, range: NSMakeRange(0,9))
	attrStr.addAttribute("NSSuperScript", value:-1, range: NSMakeRange(31,1))
	attrStr.addAttribute("NSSuperScript", value:1, range:NSMakeRange(32,2))
	adapter.addLabel(attrStr, at:NSMakePoint(320, 75), angle:0.0, align: [])
}
adapter.takeColor(fromColormapEntry: 2)
adapter.lineWidth = 0.5
adapter.move(to: NSMakePoint(320, 45.5))
adapter.addLine(to: NSMakePoint(520, 45.5))
adapter.takeColor(fromColormapEntry: 1)
adapter.fontName = "Times-Italic"
adapter.fontSize = 14.0
adapter.addLabel("Top", at: NSMakePoint(330, 45.5), angle: 0.0, align: [.top])
adapter.addLabel("Bottom", at: NSMakePoint(360, 45.5), angle: 0.0, align: [.bottom])
adapter.addLabel("Middle", at: NSMakePoint(410, 45.5), angle: 0.0, align: [])
adapter.addLabel("Baseline", at: NSMakePoint(460, 45.5), angle:0.0, align: [.baseline])

	// MARK: Equations
autoreleasepool() {
	adapter.fontName = "Helvetica"
	adapter.fontSize = 12
	adapter.addLabel("Equation style", at: NSMakePoint(260, 95), angle: 0.0, align: .center)
	
	adapter.fontName = "Times-Roman"
	adapter.fontSize = 14
	
	var attrStr = NSMutableAttributedString(string: "e-ip+1= 0")
	attrStr.addAttribute("AQTFontname", value: "Symbol", range: NSMakeRange(3, 1)) // Greek
	attrStr.addAttribute("NSSuperScript", value: 1, range: NSMakeRange(1,3)) // exponent
	attrStr.addAttribute("AQTFontsize", value: 6.0, range: NSMakeRange(7,1)) // extra spacing
	
	adapter.addLabel(attrStr, at: NSMakePoint(260, 75), angle: 0.0, align: .center)
	
	attrStr = NSMutableAttributedString(string: "mSke-wk2")
	attrStr.addAttribute("AQTFontname", value: "Symbol", range: NSMakeRange(0,2))
	attrStr.addAttribute("AQTFontsize", value: 20.0, range: NSMakeRange(1,1))
	attrStr.addAttribute("AQTBaselineAdjust", value: -0.25, range: NSMakeRange(1,1)) // Lower symbol 25%
	attrStr.addAttribute("NSSuperScript", value: -1, range: NSMakeRange(2,1))
	attrStr.addAttribute("AQTFontname", value: "Times-Roman", range: NSMakeRange(3,1))
	attrStr.addAttribute("NSSuperScript", value: 1, range: NSMakeRange(4,2))
	attrStr.addAttribute("AQTFontname", value: "Symbol", range: NSMakeRange(5,1))
	attrStr.addAttribute("NSSuperScript", value: -2, range: NSMakeRange(6,1))
	attrStr.addAttribute("NSSuperScript", value: 2, range: NSMakeRange(7,1))
	
	adapter.addLabel(attrStr, at: NSPoint(x: 260, y: 45), angle: 0.0, align: .center)
}

adapter.renderPlot()
// [NSException raise:@"AQTFatalException" format:@"Testing"];

adapter.closePlot()
