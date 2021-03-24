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
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.inputTextField.text = ""
        self.titleLabel.text = ""
        self.characterCountLabel.isHidden = true
        self.dividerView.isHidden = false
    }
    
    override func doInitialSetup() {
      inputTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        self.characterCountLabel.isHidden = true
    }
    
    weak var delegate: BookingAddCommonInputTableViewCellDelegate?
    
    
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.inputTextField.font = AppFonts.Regular.withSize(18.0)
        self.characterCountLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeGray40
        self.inputTextField.textColor = AppColors.themeTextColor
       self.characterCountLabel.textColor = AppColors.themeGray40

    }
    

    func configureCell(title: String,placeholderText: String,text: String = "") {
        self.inputTextField.placeholder(text: placeholderText, withColor: AppColors.themeGray20)
        self.inputTextField.delegate = self
            self.titleLabel.text = title
        self.inputTextField.text = text
        updateCharacterCount()
        }
    
    func updateCharacterCount() {
        let textCount = (inputTextField.text ?? "").count
//        self.characterCountLabel.text = "\(AppConstants.AddOnRequestTextLimit - textCount) /60 \(LocalizedString.CharactersRemaining.localized)"
        
        self.characterCountLabel.text = "\(textCount)/60" //\(LocalizedString.CharactersRemaining.localized)"

    }
}

extension BookingAddCommonInputTableViewCell: UITextFieldDelegate {
    @objc func textFieldDidChanged(_ textField: UITextField) {
        updateCharacterCount()
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
