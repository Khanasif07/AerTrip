//
//  UILabelExtension.swift
//  AERTRIP
//
//  Created by Apple on 09/10/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

extension UILabel {
    
    func AttributedFontColorForText(text : String, textColor : UIColor) {
        
        //self.textColor = UIColor.black
        guard let labelString = self.text else { return }
        
        let main_string = labelString as NSString
        let range = main_string.range(of: text)
        
        var  attribute = NSMutableAttributedString.init(string: main_string as String)
        if let labelAttributedString = self.attributedText {
            attribute = NSMutableAttributedString.init(attributedString: labelAttributedString)
        }
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor , range: range)
        // attribute.addAttribute(NSBaselineOffsetAttributeName, value: 0, range: range)
        self.attributedText = attribute
    }
    
    func AttributedFontForText(text : String, textFont : UIFont) {
        
        //  self.textColor = UIColor.black
        guard let labelString = self.text else { return }
        
        let main_string = labelString as NSString
        let range = main_string.range(of: text)
        
        var  attribute = NSMutableAttributedString.init(string: main_string as String)
        if let labelAttributedString = self.attributedText {
            attribute = NSMutableAttributedString.init(attributedString: labelAttributedString)
        }
        
        attribute.addAttribute(NSAttributedString.Key.font, value: textFont , range: range)
        // attribute.addAttribute(NSBaselineOffsetAttributeName, value: 0, range: range)
        self.attributedText = attribute
    }
    
    func AttributedFontAndColorForText(atributedText : String, textFont : UIFont, textColor : UIColor) {
        
        guard let labelString = self.text else { return }
        
        let main_string = labelString as NSString
        //let range = main_string.range(of: atributedText)
        
        var  attribute = NSMutableAttributedString.init(string: main_string as String)
        if let labelAttributedString = self.attributedText {
            attribute = NSMutableAttributedString.init(attributedString: labelAttributedString)
        }
        
        
        if let regularExpression = try? NSRegularExpression(pattern: atributedText, options: .caseInsensitive) {
            let matchedResults = regularExpression.matches(in: labelString, options: [], range: NSRange(location: 0, length: labelString.count))
            for matched in matchedResults {
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor , range: matched.range)
                
                attribute.addAttribute(NSAttributedString.Key.font, value: textFont , range: matched.range)
                
            }
        }
        
        
        // attribute.addAttribute(NSBaselineOffsetAttributeName, value: 0, range: range)
        self.attributedText = attribute
    }
    
    func AttributedFontColorForTextBackwards(text : String, textColor : UIColor) {
        
        guard let labelString = self.text else { return }
        
        let main_string = labelString as NSString
        let range = main_string.range(of: text, options: NSString.CompareOptions.backwards)
        
        var  attribute = NSMutableAttributedString.init(string: main_string as String)
        if let labelAttributedString = self.attributedText {
            attribute = NSMutableAttributedString.init(attributedString: labelAttributedString)
        }
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor , range: range)
        
        self.attributedText = attribute
        
    }
    
    // for multiAttributed Text in single text
    func multiAttributedFontAndColorForText(atributedText : String, textFont : UIFont,textColor : UIColor) {
        
        guard let labelString = self.text else { return }
        
        let main_string = labelString as NSString
        let range = main_string.range(of: atributedText)
        
        var  attribute = NSMutableAttributedString.init(string: main_string as String)
        if let labelAttributedString = self.attributedText {
            attribute = NSMutableAttributedString.init(attributedString: labelAttributedString)
        }
        
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor , range: range)
        
        attribute.addAttribute(NSAttributedString.Key.font, value: textFont , range: range)
        
        // attribute.addAttribute(NSBaselineOffsetAttributeName, value: 0, range: range)
        self.attributedText = attribute
    }
    
    
    func AttributedBaseLineFontColorForText(text : String, textColor : UIColor) {
        
        //self.textColor = UIColor.black
        guard let labelString = self.text else { return }
        
        let main_string = labelString as NSString
        let range = main_string.range(of: text)
        
        var  attribute = NSMutableAttributedString.init(string: main_string as String)
        if let labelAttributedString = self.attributedText {
            attribute = NSMutableAttributedString.init(attributedString: labelAttributedString)
        }
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor , range: range)
        attribute.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: range)
        attribute.addAttribute(NSAttributedString.Key.underlineColor, value: textColor, range: range)
        self.attributedText = attribute
    }
    
    
    var isTruncated: Bool {
        
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
    
    
    func appendFixedText(text: String, fixedText: String) {
        var labelText = text 
        self.text = text + fixedText
        while self.isTruncated {
            labelText =  String(labelText.dropLast(2))
          self.text = labelText + "…" + fixedText
        }
    }
}


