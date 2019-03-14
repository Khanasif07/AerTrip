//
//  UITextViewExtensions.swift
//  AERTRIP
//
//  Created by Admin on 12/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

extension UITextView{
    
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
}

extension UITextField {
    
    func setAttributedPlaceHolder(placeHolderText: String, color: UIColor = AppColors.themeGray20, font: UIFont = AppFonts.Regular.withSize(18.0)) {
        self.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: [NSAttributedString.Key.foregroundColor: color,NSAttributedString.Key.font: font])
    }
}
