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
   var color: (red: Float, green: Float, blue: Float, alpha: Float) {
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
   
   var backgroundColor: (red: Float, green: Float, blue: Float, alpha: Float) {
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
}
