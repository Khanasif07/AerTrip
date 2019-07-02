//
//  BookingAddCommonInputTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 27/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol  BookingAddCommonInputTableViewCellDelegate: class {
    func textFieldText(textField: UITextField)
}

class BookingAddCommonInputTableViewCell: ATTableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    override func doInitialSetup() {
      inputTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    weak var delegate: BookingAddCommonInputTableViewCellDelegate?
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.inputTextField.font = AppFonts.Regular.withSize(18.0)
    }
    
    
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeGray40
        self.inputTextField.textColor = AppColors.themeTextColor
       
    }
    
    
    func configureCell(title: String,placeholderText: String) {
        self.inputTextField.placeholder(text: placeholderText, withColor: AppColors.themeGray20)
        self.inputTextField.delegate = self
            self.titleLabel.text = title
        
        
        
        }

}


extension BookingAddCommonInputTableViewCell: UITextFieldDelegate {
    @objc func textFieldDidChanged(_ textField: UITextField) {
        delegate?.textFieldText(textField: textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
         return newString.length <= AppConstants.AddOnRequestTextLimit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
