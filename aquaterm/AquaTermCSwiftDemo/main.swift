//
//  main.swift
//  AquaTermCSwiftDemo
//
//  Created by C.W. Betts on 1/6/16.
//  Copyright © 2022 AquaTerm Team. All rights reserved.
//

import Swift
import AquaTerm.AquaTerm

private func internalMain() {
   let rgbImage: [UInt8] = [255, 0, 0,
                            0, 255, 0,
                            0, 0, 255,
                            0, 0, 0]
   var xPtr = [Float]()
   var yPtr = [Float]()

   let pi: Float = 4.0*atan(1.0)
   // Initialize. Do it or fail miserably...
   aqtInit()
   // Open up a plot for drawing
   aqtOpenPlot(1)
   aqtSetPlotSize(620, 420)
   aqtSetPlotTitle("Testview")
   // Set colormap
   aqtSetColormapEntry(0, 1.0, 1.0, 1.0) // white
   aqtSetColormapEntry(1, 0.0, 0.0, 0.0) // black
   aqtSetColormapEntry(2, 1.0, 0.0, 0.0) // red
   aqtSetColormapEntry(3, 0.0, 1.0, 0.0) // green
   aqtSetColormapEntry(4, 0.0, 0.0, 1.0) // blue
   aqtSetColormapEntry(5, 1.0, 0.0, 1.0) // purple
   aqtSetColormapEntry(6, 1.0, 1.0, 0.5) // yellow
   aqtSetColormapEntry(7, 0.0, 0.5, 0.5) // dark green
   // Set color explicitly
   aqtSetColor(0.0, 0.0, 0.0)
   aqtSetFontname("Helvetica")
   aqtSetFontsize(12.0)
   aqtAddLabel("Testview 620x420 pt", 4.0, 412.0, 0.0, [])
   // Frame plot
   aqtMoveTo(20, 20)
   aqtAddLineTo(600, 20)
   aqtAddLineTo(600, 400)
   aqtAddLineTo(20, 400)
   aqtAddLineTo(20, 20)
   aqtAddLabel("Frame 600x400 pt", 24, 30, 0.0, [])
   // Colormap
   aqtAddLabel("Custom colormap (8 out of 256)", 30, 390, 0.0, [])
   // Display the colormap, but first create a background for the white box...
   aqtSetColor(0.8, 0.8, 0.8)
   aqtAddFilledRect(28, 348, 24, 24)
   for i in Int32(0) ..< 8 {
      aqtTakeColorFromColormapEntry(i)
      aqtAddFilledRect(30+Float(i)*30, 350, 20, 20)
      // Print the color index
      aqtSetColor(0.5, 0.5, 0.5)
      aqtAddLabel("\(i)", 40+Float(i)*30, 360, 0.0, [.center])
   }
   // Continuos colors
   aqtTakeColorFromColormapEntry(1)
   aqtAddLabel(#""Any color you like""#, 320, 390, 0.0, [])
   aqtSetLinewidth(1.0)
   for i in stride(from: Float(0), to: 256, by: 1) {
      let f = i/255.0
      aqtSetColor(1.0, f, f/2.0)
      aqtAddFilledRect(320+i, 350, 1, 20)
      aqtSetColor(0.0, f, (1.0-f))
      aqtAddFilledRect(320 + i, 328, 1, 20)
      aqtSetColor(1.0-f, 1.0-f, 1.0-f)
      aqtAddFilledRect(320 + i, 306, 1, 20)
   }

   // Lines
   aqtTakeColorFromColormapEntry(1)
   for f in stride(from: Float(1), to: 13, by: 2) {
      let lw = f / 2.0
      aqtSetLinewidth(lw)
      aqtMoveTo(30, 200.5+f*10)
      aqtAddLineTo(200, 200.5+f*10)
      let strBuf = String(format: "linewidth %3.1f", lw)
      aqtAddLabel(strBuf, 210, 201.5+f*10, 0.0, [])
   }

   // linecap styles
   aqtSetLinewidth(11.0)
   aqtTakeColorFromColormapEntry(1)
   aqtSetLineCapStyle(.butt)
   aqtMoveTo(40.5, 170.5)
   aqtAddLineTo(150.5, 170.5)
   aqtAddLabel("AQTLineCapStyle.butt", 160.5, 170.5, 0.0, [])
   aqtSetLinewidth(1.0)
   aqtTakeColorFromColormapEntry(6)
   aqtMoveTo(40.5, 170.5)
   aqtAddLineTo(150.5, 170.5)

   aqtSetLinewidth(11.0)
   aqtTakeColorFromColormapEntry(1)
   aqtSetLineCapStyle(.round)
   aqtMoveTo(40.5, 150.5)
   aqtAddLineTo(150.5, 150.5)
   aqtAddLabel("AQTLineCapStyle.round", 160.5, 150.5, 0.0, [])
   aqtSetLinewidth(1.0)
   aqtTakeColorFromColormapEntry(6)
   aqtMoveTo(40.5, 150.5)
   aqtAddLineTo(150.5, 150.5)

   aqtSetLinewidth(11.0)
   aqtTakeColorFromColormapEntry(1)
   aqtSetLineCapStyle(.square)
   aqtMoveTo(40.5, 130.5)
   aqtAddLineTo(150.5, 130.5)
   aqtAddLabel("AQTLineCapStyle.square", 160.5, 130.5, 0.0, [])
   aqtSetLinewidth(1.0)
   aqtTakeColorFromColormapEntry(6)
   aqtMoveTo(40.5, 130.5)
   aqtAddLineTo(150.5, 130.5)

   // line joins
   aqtTakeColorFromColormapEntry(1)
   aqtAddLabel("Line joins:", 40, 90, 0.0, [])
   aqtSetLinewidth(11.0)
   aqtSetLineCapStyle(.butt)
   aqtMoveTo(40, 50)
   aqtAddLineTo(75, 70)
   aqtAddLineTo(110, 50)
   aqtSetLinewidth(1.0)
   aqtTakeColorFromColormapEntry(6)
   aqtMoveTo(40, 50)
   aqtAddLineTo(75, 70)
   aqtAddLineTo(110, 50)

   aqtSetLinewidth(11.0)
   aqtTakeColorFromColormapEntry(1)
   aqtMoveTo(130, 50)
   aqtAddLineTo(150, 70)
   aqtAddLineTo(170, 50)
   aqtSetLinewidth(1.0)
   aqtTakeColorFromColormapEntry(6)
   aqtMoveTo(130, 50)
   aqtAddLineTo(150, 70)
   aqtAddLineTo(170, 50)

   aqtSetLinewidth(11.0)
   aqtTakeColorFromColormapEntry(1)
   aqtSetLineCapStyle(AQTLineCapStyle.butt)
   aqtMoveTo(190, 50)
   aqtAddLineTo(200, 70)
   aqtAddLineTo(210, 50)
   aqtSetLinewidth(1.0)
   aqtTakeColorFromColormapEntry(6)
   aqtMoveTo(190, 50)
   aqtAddLineTo(200, 70)
   aqtAddLineTo(210, 50)

   // Polygons
   aqtTakeColorFromColormapEntry(1)
   aqtAddLabel("Polygons", 320, 290, 0.0, [])
   for i in 0 ..< 4 {
      let radians = Float(i) * pi/2.0
      let r: Float = 20.0
      xPtr.append(340.0+r*cos(radians))
      yPtr.append(255.0+r*sin(radians))
   }
   aqtTakeColorFromColormapEntry(2)
   aqtAddPolygon(&xPtr, &yPtr, 4)
   
   xPtr.removeAll(keepingCapacity: true)
   yPtr.removeAll(keepingCapacity: true)

   
   for i in 0 ..< 5 {
      let radians = Float(i)*pi*0.8
      let r: Float = 20.0
      xPtr.append(400.0+r*cos(radians))
      yPtr.append(255.0+r*sin(radians))
   }
   aqtTakeColorFromColormapEntry(3)
   aqtAddPolygon(&xPtr, &yPtr, 5)

   aqtTakeColorFromColormapEntry(1)
   xPtr.append(xPtr[0])
   yPtr.append(yPtr[0])
   aqtAddPolyline(&xPtr, &yPtr, 6)   // Overlay a polyline

   xPtr.removeAll(keepingCapacity: true)
   yPtr.removeAll(keepingCapacity: true)
   
   
   for i in 0 ..< 8 {
      let radians = Float(i)*pi/4.0
      let r: Float = 20.0
      xPtr.append(460.0+r*cos(radians))
      yPtr.append(255.0+r*sin(radians))
   }
   aqtTakeColorFromColormapEntry(4)
   aqtAddPolygon(&xPtr, &yPtr, 8)

   xPtr.removeAll(keepingCapacity: true)
   yPtr.removeAll(keepingCapacity: true)
   
   
   for i in 0 ..< 32 {
      let radians = Float(i)*pi/16.0
      let r: Float = 20.0
      xPtr.append(520.0+r*cos(radians))
      yPtr.append(255.0+r*sin(radians))
   }
   aqtTakeColorFromColormapEntry(5)
   aqtAddPolygon(&xPtr, &yPtr, 32)

   xPtr.removeAll(keepingCapacity: false)
   yPtr.removeAll(keepingCapacity: false)
   
   
   // Images
   aqtTakeColorFromColormapEntry(1)
   aqtAddLabel("Images", 320, 220, 0.0, [])
   aqtAddImageWithBitmap(rgbImage, 2, 2, 328, 200, 4, 4)
   aqtAddLabel("bits", 330, 180, 0.0, [.center])
   aqtAddImageWithBitmap(rgbImage, 2, 2, 360, 190, 40, 15)
   aqtAddLabel("fit bounds", 380, 180, 0.0, [.center])
   aqtSetImageTransform(9.23880, 3.82683, -3.82683, 9.23880, 494.6, 186.9)
   aqtAddTransformedImageWithBitmap(rgbImage, 2,2, 0.0, 0.0, 600.0, 400.0)
   aqtAddLabel("scale, rotate & translate", 500, 180, 0.0, .center)
   aqtResetImageTransform()
   
    // Text
    aqtTakeColorFromColormapEntry(1)
    aqtSetFontname("Times-Roman")
    aqtSetFontsize(16.0)
    aqtAddLabel("Times-Roman 16pt", 320, 150, 0.0, [])
    aqtTakeColorFromColormapEntry(2)
    aqtSetFontname("Times-Italic")
    aqtSetFontsize(16.0)
    aqtAddLabel("Times-Italic 16pt", 320, 130, 0.0, [])
    aqtTakeColorFromColormapEntry(4)
    aqtSetFontname("Zapfino")
    aqtSetFontsize(12.0)
    aqtAddLabel("Zapfino 12pt", 320, 104, 0.0, [])

   aqtTakeColorFromColormapEntry(2)
   aqtSetLinewidth(0.5)
   aqtMoveTo(510.5, 160)
   aqtAddLineTo(510.5, 100)
   let x: Float = 540.5
   let y: Float = 75.5
   aqtMoveTo(x+5, y)
   aqtAddLineTo(x-5, y)
   aqtMoveTo(x, y+5)
   aqtAddLineTo(x, y-5)
   
   aqtTakeColorFromColormapEntry(1)
   aqtSetFontname("Verdana")
   aqtSetFontsize(10.0)
   aqtAddLabel("left aligned", 510.5, 150, 0.0, [])
   aqtAddLabel("centered", 510.5, 130, 0.0, .center)
   aqtAddLabel("right aligned", 510.5, 110, 0.0, .right)
   aqtSetFontname("TimesNewRomanPSMT")
   aqtSetFontsize(14.0)
   aqtAddLabel("-rotate", x, y, 90.0, [])
   aqtAddLabel("-rotate", x, y, 45.0, [])
   aqtAddLabel("-rotate", x, y, -30.0, [])
   aqtAddLabel("-rotate", x, y, -60.0, [])
   aqtAddLabel("-rotate", x, y, -90.0, [])
   // String styling is _not_ possible from pure C
   aqtSetFontsize(12.0)
   aqtAddLabel(#"No underline, sub- or superscript from "C""#, 320, 75, 0.0, [])
   
   aqtTakeColorFromColormapEntry(2)
   aqtSetLinewidth(0.5)
   aqtMoveTo(320, 45.5)
   aqtAddLineTo(520, 45.5)
   aqtTakeColorFromColormapEntry(1)
   aqtSetFontname("TimesNewRomanPS-ItalicMT")
   aqtSetFontsize(14.0)
   aqtAddLabel("Top", 330, 45.5, 0.0, .top)
   aqtAddLabel("Bottom", 360, 45.5, 0.0, .bottom)
   aqtAddLabel("Middle", 410, 45.5, 0.0, [])
   aqtAddLabel("Baseline", 460, 45.5, 0.0, [.baseline])

   // Draw it
   aqtRenderPlot()
   // Let go of plot _when done_
   aqtClosePlot()
   aqtTerminate()
}

internalMain()
