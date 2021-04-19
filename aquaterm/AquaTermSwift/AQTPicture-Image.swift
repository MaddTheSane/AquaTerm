//
//  AQTPath.swift
//  AquaTerm
//
//  Created by C.W. Betts on 8/15/16.
//  Copyright © 2016 AquaTerm Team. All rights reserved.
//

import Foundation
import AquaTerm
import AquaTerm.AQTGraphic.AQTPicture
import AquaTerm.AQTGraphic.AQTImage

extension AQTPicture {
	open var transformStruct: AQTAffineTransformStruct {
		get {
			let tmpTrans = transform
			return AQTAffineTransformStruct(m11: Float(tmpTrans.m11), m12: Float(tmpTrans.m12), m21: Float(tmpTrans.m21), m22: Float(tmpTrans.m22), tX: Float(tmpTrans.tX), tY: Float(tmpTrans.tY))
		}
		set {
			transform = AffineTransform(m11: CGFloat(newValue.m11), m12: CGFloat(newValue.m12), m21: CGFloat(newValue.m21), m22: CGFloat(newValue.m22), tX: CGFloat(newValue.tX), tY: CGFloat(newValue.tY))
		}
	}	
}
