//
//  AQTCoreTextLine.swift
//  AquaTerm
//
//  Created by C.W. Betts on 9/3/22.
//  Copyright © 2022 AquaTerm Team. All rights reserved.
//

import Cocoa
import AquaTerm
import AquaTerm.AQTGraphic
import AquaTerm.AQTGraphic.AQTLabel
import CoreText

private func convertSymbolsTextToUnicode(_ symTXT: String) -> String {
   let symUTF = symTXT.utf16.map { codeUnit -> unichar in
      return _aqtMapAdobeSymbolEncodingToUnicode(codeUnit)
   }
   return String.decodeCString(symUTF, as: UTF16.self)!.result
}

@available(macOS 10.13, *)
private func convertAttributedStringToCoreTextAttributes(oldString: NSAttributedString, label: AQTLabel, normalFont: NSFont) -> NSAttributedString? {
   let convertSymbolFontToUnicode = UserDefaults.standard.bool(forKey: ConvertSymbolFontKey)

   let strLength = oldString.length
   let defaultAttrs: [NSAttributedString.Key: Any] =
   [NSAttributedString.Key(kCTLigatureAttributeName as String): 1,
    NSAttributedString.Key(kCTForegroundColorFromContextAttributeName as String): true,
    NSAttributedString.Key(kCTBaselineReferenceInfoAttributeName as String): [(kCTBaselineReferenceInfoAttributeName as String): normalFont]]
   let toRet = NSMutableAttributedString(attributedString: oldString)
   toRet.addAttributes(defaultAttrs, range: NSRange(location: 0, length: strLength))
   
   var range = NSRange()
   var i = 0
//   var attributedSublevel = 0
   while i < strLength {
      let attrDict = oldString.attributes(at: i, effectiveRange: &range)
      let attributedFontname: String = (attrDict[.aqtFontName] as? String) ?? label.fontName
      let attributedFontsize: CGFloat = (attrDict[.aqtFontSize] as? CGFloat) ?? label.fontSize
      let attributedSublevel: Int = (attrDict[.superscript] as? Int) ?? 0
      let baselineAdjust: CGFloat = (attrDict[.aqtBaselineAdjust] as? CGFloat) ?? 0
      let isVisible: Bool = ((attrDict[.aqtNonPrintingChar] as? Int) == nil
                        || (attrDict[.aqtNonPrintingChar] as? Int) == 0)
      let newUnderlining: Bool = (attrDict[.underlineStyle] != nil
                                  && (attrDict[.underlineStyle] as? Int) == 1)
      
      var newAttributes = [NSAttributedString.Key : Any]()
      
      let aFont = NSFont(name: attributedFontname, size: attributedFontsize) ?? NSFont.systemFont(ofSize: attributedFontsize)
      newAttributes[NSAttributedString.Key(kCTFontAttributeName as String)] = aFont
      // Perform neccessary conversion to Unicode
      if aFont.fontName == "Symbol", convertSymbolFontToUnicode {
         let preUni = oldString.attributedSubstring(from: range)
         let postUni = convertSymbolsTextToUnicode(preUni.string)
         toRet.replaceCharacters(in: range, with: postUni)
      }
      
      if !isVisible {
         newAttributes[NSAttributedString.Key(kCTForegroundColorFromContextAttributeName as String)] = false
         newAttributes[NSAttributedString.Key(kCTForegroundColorAttributeName as String)] = CGColor.clear
      }
      
      //TODO: work on a better way of doing superscripts that match the old behavior.
      if attributedSublevel != 0 {
         return nil
      }
      newAttributes[NSAttributedString.Key(kCTBaselineOffsetAttributeName as String)] = attributedSublevel

      if newUnderlining {
         newAttributes[NSAttributedString.Key(kCTUnderlineStyleAttributeName as String)] = CTUnderlineStyle.single.rawValue
      }
      
      if baselineAdjust != 0 {
         newAttributes[NSAttributedString.Key(kCTFontBaselineAdjustAttribute as String)] = baselineAdjust
      }
      
      toRet.addAttributes(newAttributes, range: range)
      
      i += range.length
   }
   
   return toRet
}


@available(macOS 10.13, *)
class AQTCoreTextLine: NSObject {
   let transform: AffineTransform
   let line: CTLine
   
   @objc func fill() {
      guard let ctx = NSGraphicsContext.current?.cgContext else {
         return
      }
      NSGraphicsContext.saveGraphicsState()
      defer {
         NSGraphicsContext.restoreGraphicsState()
      }
      (transform as NSAffineTransform).concat()
      //ctx.textPosition
      CTLineDraw(line, ctx)
   }
   
   @objc(initWithAttributedString:label:normalFont:) init?(_ attrString: NSAttributedString, label: AQTLabel, normalFont: NSFont) {
      let shearAngle = label.shearAngle
      let position = label.position
      guard let attrStr2 = convertAttributedStringToCoreTextAttributes(oldString: attrString, label: label, normalFont: normalFont) else {
         return nil
      }
      line = CTLineCreateWithAttributedString(attrStr2)
      var trans = AffineTransform()
      let lineBounds = CTLineGetBoundsWithOptions(line, [.useHangingPunctuation])
      var tmpSize = lineBounds.size
      var adjust = NSPoint()
      adjust.x = -CGFloat(label.justification.intersection(AQTAlign(rawValue: 0x03)).rawValue)*0.5*tmpSize.width; // hAlign:
      switch label.justification.intersection([.bottom, .top, .baseline]) {
         // align middle wrt *font size*
      case []:
         adjust.y = -(normalFont.descender + normalFont.capHeight)*0.5
         
         // align bottom wrt *bounding box*
      case .bottom:
         adjust.y = -lineBounds.origin.y
         
         // align top wrt *bounding box*
      case .top:
         adjust.y = -(lineBounds.origin.y + tmpSize.height)
         break
         
         // align baseline (do nothing)
      case .baseline:
         fallthrough
      default:
         // default to align baseline (do nothing) in case of error
         break
      }
      
      // Avoid multiples of 90 degrees (pi/2) since tan(k*pi/2)=inf, set beta to 0.0 instead.
      let beta = (abs(shearAngle - 90.0*round(shearAngle/90.0))<0.1) ? 0.0 : -shearAngle
      var ts = AffineTransform()
      ts.m21 = -tan(beta*atan(1.0)/45.0); // =-tan(beta*pi/180.0)
      trans.prepend(ts)
      // Now, place the sheared label correctly
      trans.translate(x: position.x, y: position.y)
      trans.rotate(byDegrees: label.angle)
      trans.translate(x: adjust.x, y: adjust.y)
      
      transform = trans
      super.init()
   }
   
   @objc(initWithString:label:normalFont:) convenience init?(_ str: String, label: AQTLabel, normalFont: NSFont) {
      self.init(NSAttributedString(string: str), label: label, normalFont: normalFont)
   }

   
   @objc var bounds: NSRect {
      return CTLineGetBoundsWithOptions(line, [.useHangingPunctuation])
   }
}
