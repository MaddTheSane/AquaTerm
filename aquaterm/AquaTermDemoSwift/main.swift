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

extension NSPoint {
	init(x: Float, y: Float) {
		self.x = CGFloat(x)
		self.y = CGFloat(y)
	}
}

let adap = AQTAdapter()
func aqtTestview(adapter: AQTAdapter) {
	var points = [NSPoint](count: 128, repeatedValue: NSPoint())
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
	adapter.openPlotWithIndex(1)
	adapter.plotSize =  NSMakeSize(620,420)
	adapter.plotTitle = "TestView"
	adapter.setAcceptingEvents(true)
	
	// Set colormap
	adapter.setColormapEntry(0, red:1.0, green:1.0, blue:1.0) // white
	adapter.setColormapEntry(1, red:0.0, green:0.0, blue:0.0) //black
	adapter.setColormapEntry(2, red:1.0, green:0.0, blue:0.0) // red
	adapter.setColormapEntry(3, red:0.0, green:1.0, blue:0.0) // green
	adapter.setColormapEntry(4, red:0.0, green:0.0, blue:1.0) // blue
	adapter.setColormapEntry(5, red:1.0, green:0.0, blue:1.0) // purple
	adapter.setColormapEntry(6, red:1.0, green:1.0, blue:0.5) // yellow
	adapter.setColormapEntry(7, red:0.0, green:0.5, blue:0.5) // dark green
	// Set color directly
	adapter.setColorRed(0, green: 0, blue: 0)
	adapter.fontName = "Helvetica"
	adapter.fontSize = 12.0
	adapter.addLabel("Testview 620x420 pt", atPoint: NSPoint(x: 4, y: 412), angle: 0.0, align: .Left)
	// MARK: Frame plot
	adapter.moveToPoint(NSPoint(x: 20,y: 20))
	adapter.addLineToPoint(NSPoint(x: 600,y: 20))
	adapter.addLineToPoint(NSPoint(x: 600,y: 400))
	adapter.addLineToPoint(NSPoint(x: 20,y: 400))
	adapter.addLineToPoint(NSPoint(x: 20,y: 20))
	adapter.addLabel("Frame 600x400 pt", atPoint: NSPoint(x: 24,y: 30), angle:0.0, align:.Left)
	// MARK: Colormap
	adapter.addLabel("Custom colormap (8 out of 256)", atPoint:NSPoint(x: 30, y: 385), angle:0.0, align:.Left)
	// Display the colormap, but first create a background for the white box...
	adapter.setColorRed(0.8, green:0.8, blue:0.8)
	adapter.addFilledRect(NSRect(x: 28, y: 348, width: 24, height: 24))
	for i in 0..<8 {
		adapter.takeColorFromColormapEntry(Int32(i))
		adapter.addFilledRect(NSRect(x: 30+i*30, y: 350, width: 20, height: 20))
		// Print the color index
		adapter.setColorRed(0.5, green:0.5, blue:0.5)
		adapter.addLabel("\(i)" as NSString,
			atPoint: NSPoint(x: 40+i*30, y: 360),
			angle: 0,
			align: .Center)
	}
	// MARK: Contiouos colors
	adapter.takeColorFromColormapEntry(1)
	adapter.addLabel("\"Any color you like\"", atPoint:NSMakePoint(320, 385), angle:0.0, align:.Left)
	adapter.lineWidth = 1.0
	for i in 0..<256 {
		f = Float(i)/255.0;
		adapter.setColorRed(1.0, green:f, blue:f/2.0)
		adapter.addFilledRect(NSRect(x: 320+i, y: 350, width: 1, height: 20))
		adapter.setColorRed(0.0, green: f, blue: (1.0-f))
		adapter.addFilledRect(NSRect(x: 320+i, y: 328, width: 1, height: 20))
		adapter.setColorRed((1.0-f), green:(1.0-f), blue:(1.0-f))
		adapter.addFilledRect(NSRect(x: 320+i, y: 306, width: 1, height: 20))
	}
	
	// MARK: Lines
	let pat: [[Float]] = [[4,2,4,2],[4,2,2,2],[8,4,8,4],[2,2,2,2]]
	
	adapter.takeColorFromColormapEntry(1)
	adapter.addLabel("Specify linewidth and pattern", atPoint:NSPoint(x: 30, y: 325))
	for f=1.0; f<13.0; f+=2.0 {
		let lw = f/2.0;
		adapter.lineWidth = CGFloat(round(lw - 0.5))
		adapter.setLinestylePattern(pat[(Int(f)) % 3], count:4, phase:0.0)
		adapter.moveToPoint(NSPoint(x: 30, y: 200.5+f*10))
		adapter.addLineToPoint(NSPoint(x: 180, y: 200.5+f*10))
	}
	adapter.setLinestyleSolid()
	
	// MARK: Clip rect
	autoreleasepool() {
		let r = NSMakeRect(200, 200, 60, 120);
		adapter.addLabel("Clip rects", atPoint:NSPoint(x: 200, y: 325))
		adapter.setColorRed(0.9, green:0.9, blue:0.9)
		adapter.addFilledRect(r)
		adapter.setColorRed(0, green:0, blue:0)
		adapter.clipRect = r
		adapter.addLabel("Clipped text. Clipped text. Clipped text.", atPoint:NSMakePoint(180, 230), angle:30.0, align:[.Center, .Middle])
		adapter.lineWidth = 1.0
		for i in 0..<5 {
			let radians=Double(i)*M_PI*0.8
			let r=30.0
			points[i]=NSPoint(x: 240.0+r*cos(radians), y: 215.0+r*sin(radians));
		}
		adapter.takeColorFromColormapEntry(3)
		adapter.addPolygonWithVertexPoints(points, pointCount: 5)
		adapter.takeColorFromColormapEntry(1)
		points[5] = points[0];
		adapter.addPolylineWithPoints(points, pointCount:6)
		adapter.addImageWithBitmap(rgbImage, size:NSMakeSize(2,2), bounds:NSMakeRect(190, 280, 50, 50)) // ClipRect demo
		adapter.setDefaultClipRect()
		
		// ***** Reset clip rect! *****
	}
	// MARK: linecap styles
	adapter.fontSize = 8
	adapter.lineWidth = 11
	adapter.takeColorFromColormapEntry(1)
	adapter.lineCapStyle = .Butt
	adapter.moveToPoint(NSPoint(x: 40.5, y: 170.5))
	adapter.addLineToPoint(NSPoint(x: 150.5, y: 170.5))
	adapter.addLabel("AQTLineCapStyle.Butt", atPoint:NSMakePoint(160.5, 170.5), angle:0.0, align:.Left)
	adapter.lineWidth = 1.0
	adapter.takeColorFromColormapEntry(6)
	adapter.moveToPoint(NSPoint(x: 40.5, y: 170.5))
	adapter.addLineToPoint(NSPoint(x: 150.5, y: 170.5))
	
	adapter.lineWidth = 11
	adapter.takeColorFromColormapEntry(1)
	adapter.lineCapStyle = .Round
	adapter.moveToPoint(NSPoint(x: 40.5, y: 150.5))
	adapter.addLineToPoint(NSPoint(x: 150.5, y: 150.5))
	adapter.addLabel("AQTLineCapStyle.Round", atPoint: NSPoint(x: 160.5, y: 150.5), angle:0.0, align:.Left)
	adapter.lineWidth = 1.0
	adapter.takeColorFromColormapEntry(6)
	adapter.moveToPoint(NSPoint(x: 40.5, y: 150.5))
	adapter.addLineToPoint(NSPoint(x: 150.5, y: 150.5))
	
	adapter.lineWidth = 11
	adapter.takeColorFromColormapEntry(1)
	adapter.lineCapStyle = .Line
	adapter.moveToPoint(NSPoint(x: 40.5, y: 130.5))
	adapter.addLineToPoint(NSPoint(x: 150.5, y: 130.5))
	adapter.addLabel("AQTLineCapStyle.Line", atPoint: NSPoint(x: 160.5, y: 130.5), angle:0.0, align:.Left)
	adapter.lineWidth = 1.0
	adapter.takeColorFromColormapEntry(6)
	adapter.moveToPoint(NSPoint(x: 40.5, y: 130.5))
	adapter.addLineToPoint(NSPoint(x: 150.5, y: 130.5))
	adapter.fontSize = 12
	
	// MARK: line joins
	adapter.takeColorFromColormapEntry(1)
	adapter.addLabel("Line joins:", atPoint: NSPoint(x: 40, y: 90), angle: 0.0, align: .Left)
	adapter.lineWidth = 11
	adapter.lineCapStyle = .Butt
	adapter.moveToPoint(NSPoint(x: 40, y: 50))
	adapter.addLineToPoint(NSPoint(x: 75, y: 70))
	adapter.addLineToPoint(NSPoint(x: 110, y: 50))
	adapter.lineWidth = 1
	adapter.takeColorFromColormapEntry(6)
	adapter.moveToPoint(NSPoint(x: 40, y: 50))
	adapter.addLineToPoint(NSPoint(x: 75, y: 70))
	adapter.addLineToPoint(NSPoint(x: 110, y: 50))
	
	adapter.lineWidth = 11
	adapter.takeColorFromColormapEntry(1)
	adapter.moveToPoint(NSPoint(x: 130, y: 50))
	adapter.addLineToPoint(NSPoint(x: 150, y: 70))
	adapter.addLineToPoint(NSPoint(x: 170, y: 50))
	adapter.lineWidth = 1
	adapter.takeColorFromColormapEntry(6)
	adapter.moveToPoint(NSPoint(x: 130, y: 50))
	adapter.addLineToPoint(NSPoint(x: 150, y: 70))
	adapter.addLineToPoint(NSPoint(x: 170, y: 50))
	
	adapter.lineWidth = 11
	adapter.takeColorFromColormapEntry(1)
	adapter.lineCapStyle = .Butt
	adapter.moveToPoint(NSPoint(x: 190, y: 50))
	adapter.addLineToPoint(NSPoint(x: 200, y: 70))
	adapter.addLineToPoint(NSPoint(x: 210, y: 50))
	adapter.lineWidth = 1
	adapter.takeColorFromColormapEntry(6)
	adapter.moveToPoint(NSPoint(x: 190, y: 50))
	adapter.addLineToPoint(NSPoint(x: 200, y: 70))
	adapter.addLineToPoint(NSPoint(x: 210, y: 50))
	
	// MARK: Polygons
	adapter.takeColorFromColormapEntry(1)
	adapter.addLabel("Polygons", atPoint: NSPoint(x: 320, y: 290), angle: 0.0, align:. Left)
	for i in 0..<4 {
		let radians=Double(i)*M_PI/2.0
		let r=20.0;
		points[i]=NSPoint(x: 340.0 + r * cos(radians), y: 255.0 + r * sin(radians))
	}
	adapter.takeColorFromColormapEntry(2)
	adapter.addPolygonWithVertexPoints(points, pointCount:4)
	for i in 0..<5 {
		let radians=Double(i)*M_PI*0.8
		let r=20.0;
		points[i] = NSPoint(x: 400.0 + r * cos(radians), y: 255.0 + r * sin(radians))
	}
	adapter.takeColorFromColormapEntry(3)
	adapter.addPolygonWithVertexPoints(points, pointCount:5)
	adapter.takeColorFromColormapEntry(1)
	points[5] = points[0];
	adapter.addPolygonWithVertexPoints(points, pointCount:6)
	
	for i in 0..<8 {
		let radians = Double(i)*M_PI/4.0
		let r = 20.0;
		points[i] = NSPoint(x: 460.0+r*cos(radians), y: 255.0+r*sin(radians));
	}
	adapter.takeColorFromColormapEntry(4)
	adapter.addPolygonWithVertexPoints(points, pointCount:8)
	
	// Circles with alpha transparency
	adapter.takeColorFromColormapEntry(1)
	adapter.addLabel("Alpha channel", atPoint:NSMakePoint(530, 290), angle:0.0, align: .Center)
	do {
		let circleInfo: [(x: Double, y: Double, red: Float, green: Float, blue: Float)] = [
			(520, 255, 1, 0, 0),
			(540, 245, 0, 1, 0),
			(540, 265, 0, 0, 1)]
		
		for (x, y, red, green, blue) in circleInfo {
			for i in 0..<32 {
				let radians = Double(i)*M_PI/16.0, r = 20.0;
				points[i] = NSPoint(x: x+r*cos(radians), y: y+r*sin(radians));
			}
			adapter.setColorRed(red, green:green, blue:blue, alpha:0.5)
			adapter.addPolygonWithVertexPoints(points, pointCount:32)
		}
	}
	// MARK: Images
	adapter.takeColorFromColormapEntry(1)
	adapter.addLabel("Images", atPoint:NSMakePoint(320, 220), angle:0.0, align: .Left)
	adapter.addImageWithBitmap(rgbImage, size:NSMakeSize(2,2), bounds:NSMakeRect(328, 200, 4, 4))
	adapter.addLabel("bits", atPoint: NSMakePoint(330, 180), angle:0.0, align: .Center)
	adapter.addImageWithBitmap(rgbImage, size:NSMakeSize(2,2), bounds:NSMakeRect(360, 190, 40, 15))
	adapter.addLabel("fit bounds", atPoint:NSMakePoint(380, 180), angle:0.0, align: .Center)
	adapter.setImageTransformM11(9.23880, m12:3.82683, m21:-3.82683, m22:9.23880, tX:494.6, tY:186.9)
	adapter.addTransformedImageWithBitmap(rgbImage, size: NSMakeSize(2,2), clipRect:NSMakeRect(0, 0, 600, 400))
	adapter.addLabel("scale, rotate & translate", atPoint:NSMakePoint(500, 180), angle:0.0, align: .Center)
	adapter.resetImageTransform() // clean up
	
	// MARK: Text
	do {
		adapter.fontName = "Times-Roman"
		//NSString *s = [[NSString alloc] initWithFormat:@"Unicode: %C %C %C %C%C%C%C%C", (unichar)0x2124, (unichar)0x2133, (unichar)0x5925, (unichar)0x2654, (unichar)0x2655, (unichar)0x2656, (unichar)0x2657, (unichar)0x2658];
		let s = "Unicode: \u{2124} \u{2133} \u{5925} \u{2654}\u{2655}\u{2656}\u{2657}\u{2658}";
		let attrStr = NSMutableAttributedString(string: s)
		attrStr.setAttributes(["AQTFontname": "AppleSymbols"], range: NSMakeRange(9,11))
		attrStr.setAttributes(["AQTFontname": "STSong"], range:NSMakeRange(13,1))
		
		adapter.takeColorFromColormapEntry(1)
		adapter.fontName = "Times-Roman"
		adapter.fontSize = 12.0
		adapter.addLabel(attrStr, atPoint: NSPoint(x: 320, y: 150))
		//[adapter addLabel:@"Times-Roman 16pt" atPoint:NSMakePoint(320, 150) angle:0.0 align:AQTAlignLeft];
		adapter.takeColorFromColormapEntry(2)
		adapter.fontName = "Times-Italic"
		adapter.fontSize = 16.0
		adapter.addLabel("Times-Italic 16pt", atPoint: NSPoint(x: 320, y: 130), angle: 0.0, align: .Left)
		adapter.takeColorFromColormapEntry(4)
		adapter.fontName = "Zapfino"
		adapter.fontSize = 12.0
		adapter.addLabel("Zapfino 12pt", atPoint: NSPoint(x: 320, y: 104), angle: 0.0, align: .Left)
		
		adapter.takeColorFromColormapEntry(2)
		adapter.lineWidth = 0.5
		adapter.moveToPoint(NSPoint(x: 510.5, y: 160))
		adapter.addLineToPoint(NSPoint(x: 510.5, y: 100))
		pos = NSPoint(x: 540.5, y: 75.5);
		adapter.moveToPoint(NSPoint(x: pos.x+5, y: pos.y))
		adapter.addLineToPoint(NSPoint(x: pos.x-5, y: pos.y))
		adapter.moveToPoint(NSPoint(x: pos.x, y: pos.y+5))
		adapter.addLineToPoint(NSPoint(x: pos.x, y: pos.y-5))
		
		adapter.takeColorFromColormapEntry(1)
		adapter.fontName = "Verdana"
		adapter.fontSize = 10.0
		adapter.addLabel("left align", atPoint: NSPoint(x: 510.5, y: 150), angle: 0.0, align: .Left)
		adapter.addLabel("centered", atPoint: NSPoint(x: 510.5, y: 130), angle:0.0, align: .Center)
		adapter.addLabel("right align", atPoint: NSPoint(x: 510.5, y: 110), angle:0.0, align: .Right)
		adapter.fontName = "Times-Roman"
		adapter.fontSize = 14.0
		adapter.addLabel("-rotate", atPoint:pos, angle:90.0, align: .Left)
		adapter.addLabel("-rotate", atPoint:pos, angle:45.0, align: .Left)
		adapter.addLabel("-rotate", atPoint:pos, angle:-30.0, align: .Left)
		adapter.addLabel("-rotate", atPoint:pos, angle:-60.0, align: .Left)
		adapter.addLabel("-rotate", atPoint:pos, angle:-90.0, align: .Left)
		// Shear
		adapter.fontName = "Arial"
		adapter.fontSize = 12.0
		adapter.addLabel("Rotate & shear", atPoint: NSPoint(x: 430, y: 105), angle:45.0, shearAngle:45.0, align: .Left)
	}
	
	// MARK: Some styling is possible
	autoreleasepool() {
		let attrStr = NSMutableAttributedString(string: "Underline, super- and subscript123")
		attrStr.addAttribute("NSUnderline", value:1, range: NSMakeRange(0,9))
		attrStr.addAttribute("NSSuperScript", value:-1, range: NSMakeRange(31,1))
		attrStr.addAttribute("NSSuperScript", value:1, range:NSMakeRange(32,2))
		adapter.addLabel(attrStr, atPoint:NSMakePoint(320, 75), angle:0.0, align: .Left)
	}
	adapter.takeColorFromColormapEntry(2)
	adapter.lineWidth = 0.5
	adapter.moveToPoint(NSMakePoint(320, 45.5))
	adapter.addLineToPoint(NSMakePoint(520, 45.5))
	adapter.takeColorFromColormapEntry(1)
	adapter.fontName = "Times-Italic"
	adapter.fontSize = 14.0
	adapter.addLabel("Top", atPoint: NSMakePoint(330, 45.5), angle: 0.0, align:[.Left, .Top])
	adapter.addLabel("Bottom", atPoint: NSMakePoint(360, 45.5), angle: 0.0, align:[.Left, .Bottom])
	adapter.addLabel("Middle", atPoint: NSMakePoint(410, 45.5), angle: 0.0, align:[.Left, .Middle])
	adapter.addLabel("Baseline", atPoint: NSMakePoint(460, 45.5), angle:0.0, align:[.Left, .Baseline])
	
	// MARK: Equations
	autoreleasepool() {
		adapter.fontName = "Helvetica"
		adapter.fontSize = 12
		adapter.addLabel("Equation style", atPoint: NSMakePoint(260, 95), angle: 0.0, align: .Center)
		
		adapter.fontName = "Times-Roman"
		adapter.fontSize = 14
		
		var attrStr = NSMutableAttributedString(string: "e-ip+1= 0")
		attrStr.addAttribute("AQTFontname", value: "Symbol", range:NSMakeRange(3, 1)) // Greek
		attrStr.addAttribute("NSSuperScript", value:1, range:NSMakeRange(1,3)) // eponent
		attrStr.addAttribute("AQTFontsize", value:6.0, range:NSMakeRange(7,1)) // extra spacing
		
		adapter.addLabel(attrStr, atPoint: NSMakePoint(260, 75), angle: 0.0, align: .Center)
		
		attrStr = NSMutableAttributedString(string: "mSke-wk2")
		attrStr.addAttribute("AQTFontname", value: "Symbol", range: NSMakeRange(0,2))
		attrStr.addAttribute("AQTFontsize", value:20.0, range: NSMakeRange(1,1))
		attrStr.addAttribute("AQTBaselineAdjust", value:-0.25, range: NSMakeRange(1,1)) // Lower symbol 25%
		attrStr.addAttribute("NSSuperScript", value:-1, range: NSMakeRange(2,1))
		attrStr.addAttribute("AQTFontname", value: "Times-Roman", range: NSMakeRange(3,1))
		attrStr.addAttribute("NSSuperScript", value:1, range: NSMakeRange(4,2))
		attrStr.addAttribute("AQTFontname", value: "Symbol", range: NSMakeRange(5,1))
		attrStr.addAttribute("NSSuperScript", value:-2, range:NSMakeRange(6,1))
		attrStr.addAttribute("NSSuperScript", value: 2, range: NSMakeRange(7,1))
		
		adapter.addLabel(attrStr, atPoint: NSMakePoint(260, 45), angle:0.0, align: .Center)
	}
	
	adapter.renderPlot()
	// [NSException raise:@"AQTFatalException" format:@"Testing"];
	
	adapter.closePlot()
}

autoreleasepool() {
	aqtTestview(adap)
}
