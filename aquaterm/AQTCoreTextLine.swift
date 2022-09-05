//
//  AQTCoreTextLine.swift
//  AquaTerm
//
//  Created by C.W. Betts on 9/3/22.
//  Copyright © 2022 AquaTerm Team. All rights reserved.
//

import Cocoa
import AquaTerm.AQTGraphic.AQTLabel
import CoreText

private func convertSymbolsTextToUnicode(_ symTXT: String) -> String {
   let symUTF = symTXT.utf16.map { codeUnit -> unichar in
      return _aqtMapAdobeSymbolEncodingToUnicode(codeUnit)
   }
   return String.decodeCString(symUTF, as: UTF16.self)!.result
}

@available(macOS 10.13, *)
func convertAttributedStringToCoreTextAttributes(oldString: NSAttributedString, label: AQTLabel) -> NSAttributedString {
   let normalFont = NSFont(name: label.fontName, size: label.fontSize) ?? NSFont.systemFont(ofSize: label.fontSize)
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
                        || (attrDict[.aqtNonPrintingChar] as? Int) == 0);
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

/*
 static NSAttributedString *ConvertAttributedStringToCoreTextAttributes(id oldString, AQTLabel *label)
 {
    NSMutableAttributedString *toRet = nil;
    const BOOL prefConvertToUnicode = [[NSUserDefaults standardUserDefaults] boolForKey:ConvertSymbolFontKey];
    NSFont *normalFont;
    NSInteger strLen = [oldString length];
    if ((normalFont = [NSFont fontWithName:label.fontName size:label.fontSize]) == nil)
       normalFont = [NSFont systemFontOfSize:label.fontSize]; // Fall back to a system font
    NSDictionary *defaultAttrs = @{(id)kCTFontAttributeName: normalFont, (id)kCTLigatureAttributeName: @1, (id)kCTForegroundColorFromContextAttributeName: @YES};
    if ([oldString isKindOfClass:[NSString class]]) {
       BOOL convertSymbolFontToUnicode = [normalFont.fontName isEqualToString:@"Symbol"]
          && prefConvertToUnicode;
       if (convertSymbolFontToUnicode) {
          unichar * chars = calloc(strLen + 1, sizeof(unichar));
          for (NSInteger i = 0; i < strLen; i++) {
             unichar theChar = [oldString characterAtIndex:i];
             theChar = _aqtMapAdobeSymbolEncodingToUnicode(theChar);
             chars[i] = theChar;
          }
          toRet = [[NSMutableAttributedString alloc] initWithString:[[NSString alloc] initWithCharactersNoCopy:chars length:strLen freeWhenDone:YES] attributes:defaultAttrs];

       } else {
          toRet = [[NSMutableAttributedString alloc] initWithString:oldString attributes:defaultAttrs];
       }
    } else {
       toRet = [[NSMutableAttributedString alloc] initWithAttributedString:oldString];
       [toRet addAttributes:defaultAttrs range:NSMakeRange(0, toRet.length)];
       NSInteger i = 0;
       NSInteger strLen = [oldString length];
       NSRange range;
       while (i < strLen) {
          NSDictionary<NSAttributedStringKey,id> *attrDict = [oldString attributesAtIndex:i effectiveRange:&range];
          NSMutableDictionary<NSAttributedStringKey,id> *newAttrs = [[NSMutableDictionary alloc] initWithCapacity:attrDict.count];
          NSFont *tmpFont = normalFont;
          for (NSAttributedStringKey key in attrDict) {
             id value = attrDict[key];
             if ([key isEqualToString:AQTFontNameKey]) {
                tmpFont = [NSFont fontWithName:value size:tmpFont.pointSize];
                if ([tmpFont.fontName isEqualToString:@"Symbol"] && prefConvertToUnicode) {
                   NSString *toUTF = [[oldString string] substringWithRange:range];
                   NSInteger tmpLen = [toUTF length];
                   unichar * chars = calloc(tmpLen + 1, sizeof(unichar));
                   for (NSInteger i = 0; i < tmpLen; i++) {
                      unichar theChar = [toUTF characterAtIndex:i];
                      theChar = _aqtMapAdobeSymbolEncodingToUnicode(theChar);
                      chars[i] = theChar;
                   }
                   NSString *theUTF = [[NSString alloc] initWithCharactersNoCopy:chars length:tmpLen freeWhenDone:YES];
                   [toRet replaceCharactersInRange:range withString:theUTF];
                }
             } else if ([key isEqualToString:AQTFontSizeKey]) {
                tmpFont = [[NSFontManager sharedFontManager] convertFont:tmpFont toSize:[value doubleValue]];
             } else if ([key isEqualToString:AQTBaselineAdjustKey]) {
                if (@available(macOS 10.13, *)) {
                   newAttrs[(id)kCTBaselineOffsetAttributeName] = value;
                } else {
                   // Fallback on earlier versions
                }
             } else if ([key isEqualToString:NSSuperscriptAttributeName]) {
                newAttrs[(id)kCTSuperscriptAttributeName] = value;
             }
             
             
          }
          if (![tmpFont isEqual: normalFont]) {
             newAttrs[(id)kCTFontAttributeName] = tmpFont;
          }
          
          [toRet addAttributes:newAttrs range:range];
          
          i += range.length;
       }
    }
    
    return toRet;
 }

 */

@available(macOS 10.13, *)
class AQTCoreTextLine: NSObject {
   let transform: AffineTransform = AffineTransform()
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
      CTLineDraw(line, ctx)
   }
   
   @objc(initWithAttributedString:label:) init(_ attrString: NSAttributedString, label: AQTLabel) {
      let attrStr2 = convertAttributedStringToCoreTextAttributes(oldString: attrString, label: label)
      line = CTLineCreateWithAttributedString(attrStr2)
      super.init()
   }
   
   @objc(initWithString:label:) convenience init(_ str: String, label: AQTLabel) {
      self.init(NSAttributedString(string: str), label: label)
   }

   
   @objc var bounds: NSRect {
      return .zero
   }
}
