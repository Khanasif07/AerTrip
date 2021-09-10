//
//  UITextFieldExtension.swift
//  AERTRIP
//
//  Created by Admin on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

extension UITextField {
    
    ///Attributed text for textfield placeholder
    func setAttributedPlaceHolder(placeHolderText: String, color: UIColor = AppColors.themeGray20, font: UIFont = AppFonts.Regular.withSize(18.0)) {
        self.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: [NSAttributedString.Key.foregroundColor: color,NSAttributedString.Key.font: font])
    }
    
    ///Right View Button in textfield
    func modifyClearButton(with image : UIImage, size: CGSize) {
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(image, for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        rightButton.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(self.rightButtonAction(_:)), for: .touchUpInside)
        rightView = rightButton
        rightViewMode = .whileEditing
    }
    
    @objc private func rightButtonAction(_ sender : AnyObject) {
        self.text = ""
        sendActions(for: .editingChanged)
    }
    
    ///Text field clear button setUp
    func textFieldClearBtnSetUp(with img: UIImage? = AppImages.ic_toast_cross) {
        if let clearButton : UIButton = self.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(img, for: .normal)
            clearButton.size = CGSize(width: 16.0, height: 16.0)
        }
    }
    
    func setUpAttributedPlaceholder(placeholderString: String,with symbol: String = "*",foregroundColor: UIColor = AppColors.themeGray40) {
        let attriburedString = NSMutableAttributedString(string: placeholderString)
        let asterix = NSAttributedString(string: symbol, attributes: [.foregroundColor: foregroundColor])
        attriburedString.append(asterix)
        
        self.attributedPlaceholder = attriburedString
    }
    
    func setButtonToRightView(btn : UIButton, selectedImage : UIImage?, normalImage : UIImage?, size: CGSize?) {
        
        self.rightViewMode = .always
        self.rightView = btn
        
        btn.isSelected = false
        
        if let selectedImg = selectedImage { btn.setImage(selectedImg, for: .selected) }
        if let unselectedImg = normalImage { btn.setImage(unselectedImg, for: .normal) }
        if let btnSize = size {
            self.rightView?.frame = CGRect(x: self.frame.width - btnSize.width,
                                           y: 0,
                                           width: btnSize.width,
                                           height: self.frame.height)
        } else {
            self.rightView?.frame = CGRect(x: self.frame.width - (btn.intrinsicContentSize.width+10),
                                           y: 0,
                                           width: (btn.intrinsicContentSize.width+10),
                                           height: self.frame.height)
        }
    }
    
    
    func setUpTextField(placehoder: String,with symbol: String = "",foregroundColor: UIColor = AppColors.themeGray40,
                           textColor: UIColor = AppColors.themeBlack,
                           keyboardType: UIKeyboardType,
                           returnType: UIReturnKeyType,
                           isSecureText: Bool) {
           
           self.keyboardType       = keyboardType
           self.placeholder        = placehoder
           self.textColor          = textColor
           self.isSecureTextEntry  = isSecureText
           self.returnKeyType      = returnType
           self.font           = AppFonts.Regular.withSize(18)
           self.tintColor = AppColors.themeGreen
           let attriburedString = NSMutableAttributedString(string: placehoder)
           let asterix = NSAttributedString(string: symbol, attributes: [.foregroundColor: foregroundColor])
           attriburedString.append(asterix)
           
           self.attributedPlaceholder = attriburedString
       }
    
    func AttributedBackgroundColorForText(text : String, textColor : UIColor) {
        
        //self.textColor = UIColor.black
        guard let labelString = self.text else { return }
        
        let main_string = labelString as NSString
        let range = main_string.range(of: text)
        
        var  attribute = NSMutableAttributedString.init(string: main_string as String)
        if let labelAttributedString = self.attributedText {
            attribute = NSMutableAttributedString.init(attributedString: labelAttributedString)
        }
        attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: textColor , range: range)
        // attribute.addAttribute(NSBaselineOffsetAttributeName, value: 0, range: range)
        self.attributedText = attribute
    }
    
    func addLeftPaddingView(width: CGFloat) {
        self.leftViewMode = UITextField.ViewMode.always
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftView = paddingView
        self.layoutSubviews()
    }
    
    func addRightPaddingView(width: CGFloat) {
        self.rightViewMode = UITextField.ViewMode.always
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.rightView = paddingView
        self.layoutSubviews()
    }
}
