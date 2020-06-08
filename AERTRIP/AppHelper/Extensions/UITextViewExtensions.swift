//
//  UITextViewExtensions.swift
//  AERTRIP
//
//  Created by Admin on 12/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

extension UITextView{
    
    var numberOfLines: Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
    
    func AttributedParagraphSpacing(paragraphSpacing: CGFloat) {
        
        //  self.textColor = UIColor.black
        guard let labelString = self.text else { return }
        
        let main_string = labelString as NSString
        let range = main_string.range(of: labelString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = paragraphSpacing
        
        var  attribute = NSMutableAttributedString.init(string: main_string as String)
        if let labelAttributedString = self.attributedText {
            attribute = NSMutableAttributedString.init(attributedString: labelAttributedString)
        }
        
        attribute.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle , range: range)
        // attribute.addAttribute(NSBaselineOffsetAttributeName, value: 0, range: range)
        self.attributedText = attribute
    }
    
     func asStylizedPrice(text: String, using font: UIFont) {
    //        let stylizedPrice = NSMutableAttributedString(string: self, attributes: [.font: font])
    //
    //        guard var changeRange = self.range(of: ".")?.asNSRange(inString: self) else {
    //            return stylizedPrice
    //        }
    //        let result = self.components(separatedBy: ".").last?.components(separatedBy: " ").first?.count
    //        print("result: \(result)")
    //        changeRange.length = self.count - changeRange.location
    //
    //        guard let font = UIFont(name: font.fontName, size: (font.pointSize * 0.75)) else {
    //            printDebug("font not found")
    //            return stylizedPrice
    //        }
    //        let changeFont = font
    //        let offset = 6.2
    //        stylizedPrice.addAttribute(.font, value: changeFont, range: changeRange)
    //        stylizedPrice.addAttribute(.baselineOffset, value: offset, range: changeRange)
    //        return stylizedPrice
            
            
            //self.textColor = UIColor.black
            guard text.contains("."), let labelString = self.text, let decimalText = text.components(separatedBy: ".").last, !decimalText.isEmpty else { return }
            
            let main_string = labelString as NSString
            let range = main_string.range(of: decimalText)
            
            var  attribute = NSMutableAttributedString.init(string: main_string as String)
            if let labelAttributedString = self.attributedText {
                attribute = NSMutableAttributedString.init(attributedString: labelAttributedString)
            }
            
            guard let font = UIFont(name: font.fontName, size: (font.pointSize * 0.75)) else {
                printDebug("font not found")
                return
            }
            let changeFont = font
            let offset = 6.2
            attribute.addAttribute(.font, value: changeFont, range: range)
            attribute.addAttribute(.baselineOffset, value: offset, range: range)
            self.attributedText = attribute
        }
}
