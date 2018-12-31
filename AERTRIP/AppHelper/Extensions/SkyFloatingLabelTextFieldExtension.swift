//
//  SkyFloatingLabelTextFieldExtension.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 05/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

extension SkyFloatingLabelTextField {
    
    func setupTextField(placehoder: String,
                        textColor: UIColor = AppColors.themeBlack,
                        placeholderColor: UIColor = AppColors.themeGray20,
                        selectedTitleColor: UIColor = AppColors.themeGreen,
                        selectedLineColor: UIColor = AppColors.themeGray20,
                        keyboardType: UIKeyboardType,
                        returnType: UIReturnKeyType,
                        isSecureText: Bool) {
        
        self.keyboardType       = keyboardType
        self.placeholder        = placehoder
        self.textColor          = textColor
        self.placeholderColor   = placeholderColor
        self.selectedTitleColor = selectedTitleColor
        self.selectedLineColor  = selectedLineColor
        self.isSecureTextEntry  = isSecureText
        self.returnKeyType      = returnType
        self.disabledColor      = placeholderColor
        self.lineColor          = AppColors.themeGray20
        self.titleColor       = selectedTitleColor
        self.placeholderFont    = AppFonts.Regular.withSize(18)
        self.font           = AppFonts.Regular.withSize(18)
        self.titleLabel.font   = AppFonts.Regular.withSize(14)
        self.tintColor = AppColors.themeGreen
        self.selectedLineHeight = 0.5
        self.selectedLineColor  = AppColors.themeGray20
    }
    
    func addRightViewInTextField(_ image: UIImage, width: Int, height: Int ) {
        
        let calendarImage = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
        calendarImage.setImage(image, for: .normal)
        calendarImage.isEnabled = false
        self.rightView = calendarImage
        self.rightViewMode = .always
        calendarImage.isUserInteractionEnabled = false
        
    }
}
