//
//  main.swift
//  AquaTermTimingSwift
//
//  Created by C.W. Betts on 9/11/17.
//  Copyright © 2017 AquaTerm Team. All rights reserved.
//

import Foundation
import AquaTerm

func aqtLineDrawingTest(_ adapter: AQTAdapter) {
	let maxLineLength: Int32 = 64
	var index: UInt32 = 0
	// test 1
	for l in stride(from: 2, through: maxLineLength, by: 2) {
		index += 1
		let cMax = (64 * 16) / l
		adapter.openPlot(with: l)
		adapter.plotSize = NSSize(width: 620, height: 420)
		adapter.plotTitle = "Line test l = \(l), cMax = \(cMax)"
		for _ in 0 ..< cMax {
			adapter.move(to: NSPoint(x: drand48()*600+10, y: drand48()*400+10))
			for _ in 1 ... l {
				adapter.addLine(to: NSPoint(x: drand48()*600+10, y: drand48()*400+10))
			}
		}
		adapter.renderPlot()
		// Tag bits:
		// 0-5:   index
		// 6-15:  test
		// 16-23: client
		// 24-31: reserved
		adapter.timingTest(withTag: index + 1*64 + 1*65536)
		adapter.closePlot()
	}
	
	// test 2
	adapter.openPlot(with: 1)
	adapter.plotSize = NSSize(width: 620, height: 420)
	adapter.plotTitle = "Test 2"
	for x in stride(from: 10, to: 610, by: 10) {
		adapter.move(to: NSPoint(x: x, y: 10))
		adapter.addLine(to: NSPoint(x: 620 - x, y: 410))
	}
	adapter.renderPlot()
	// Tag bits:
	// 0-5:   index
	// 6-15:  test
	// 16-23: client
	// 24-31: reserved
	adapter.timingTest(withTag: index + 2*64 + 1*65536)
	adapter.closePlot()
}

autoreleasepool { () -> Void in
	let adapter = AQTAdapter()!
	aqtLineDrawingTest(adapter)
}
