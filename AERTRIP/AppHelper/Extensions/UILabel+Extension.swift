//
//  UILabel+Extension.swift
//  AERTRIP
//
//  Created by Appinventiv on 23/09/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

/// Set the text of the label but altering the kerning so that you can control the space between each characters.
///
/// - Parameters:
///   - text: New content of the label
///   - kerning: Set a value between 0 and 1 to lower the space between characters. Above 0, spacing will be increased. 0 disables kerning.
extension UILabel {
    
    func set(text: String, withKerning kerning: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text)
        
        // The value parameter defines your spacing amount, and range is
        // the range of characters in your string the spacing will apply to.
        // Here we want it to apply to the whole string so we take it from 0 to text.count.
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kerning, range: NSMakeRange(0, text.count))
        
        attributedText = attributedString
}
}

