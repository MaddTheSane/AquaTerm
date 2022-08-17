//
//  NSWindowAdditions.swift
//  AquaTerm
//
//  Created by C.W. Betts on 8/15/22.
//  Copyright © 2022 AquaTerm Team. All rights reserved.
//

import AppKit.NSWindow

extension NSWindow {
	@objc var titlebarHeight: CGFloat {
		frame.height - contentRect(forFrameRect: frame).height
	}
}
