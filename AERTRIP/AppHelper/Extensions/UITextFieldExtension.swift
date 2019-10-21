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
    func textFieldClearBtnSetUp() {
        if let clearButton : UIButton = self.value(forKey: "_clearButton") as? UIButton {
            clearButton.setImage(#imageLiteral(resourceName: "ic_toast_cross"), for: .normal)
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

}
