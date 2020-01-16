//
//  EditProfileThreePartTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 22/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import PhoneNumberKit

protocol EditProfileThreePartTableViewCellDelegate:class {
    func editProfileThreePartDeleteCellTapped(_ indexPath: IndexPath)
    func threePartLeftViewTap(_ indexPath: IndexPath,_ gesture: UITapGestureRecognizer)
    func middleViewTap(_ indexPath: IndexPath,_ gesture: UITapGestureRecognizer)
    func editProfileThreePartTableViewCellTextFieldText(_ textField: UITextField, _ indexPath: IndexPath, _ text: String, isValide: Bool)
    
}

class EditProfileThreePartTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var blackDownImageView: UIImageView!
    @IBOutlet weak var leftSeparatorView: ATDividerView!
    
    @IBOutlet weak var rightViewTextField: PhoneNumberTextField!
    
    @IBOutlet weak var rightSeparatorView: ATDividerView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var middleSeparatorView: ATDividerView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    
    // MARK : - Variables
    weak var delegate : EditProfileThreePartTableViewCellDelegate?
    
    // MARK : - View Life cycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFonts()
        leftView.isUserInteractionEnabled = true
        rightViewTextField.placeholder = LocalizedString.Phone.localized
    }
    
    // MARK : - Helper methods
    
    func configureCell(_ isd:String,_ label : String, _ value: String) {
        self.leftTitleLabel.text = label.capitalizedFirst()
        self.rightViewTextField.text = value
        self.rightViewTextField.delegate = self
        self.countryCodeLabel.text = isd
        self.countryCodeLabel.font = AppFonts.Regular.withSize(18)
        self.flagImageView.image = nil
        if let countryData = PKCountryPicker.default.getCountryData(forISDCode: isd) {
            self.rightViewTextField?.defaultRegion = countryData.ISOCode
            self.rightViewTextField.text = self.rightViewTextField.nationalNumber
            self.countryCodeLabel.text = isd
            self.flagImageView.image = countryData.flagImage
        }
        self.rightViewTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.leftViewTap(gesture:)))
        gesture.numberOfTapsRequired = 1
        leftView.tag = indexPath?.row ?? 0
        leftView.addGestureRecognizer(gesture)
        
        let middleViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.middleViewTap(gesture:)))
        middleViewGesture.numberOfTapsRequired = 1
        middleView.isUserInteractionEnabled = true
        middleView.tag = indexPath?.row ?? 0
        middleView.addGestureRecognizer(middleViewGesture)
        
    }
    
    
    private func setUpFonts() {
        self.leftTitleLabel.font = AppFonts.Regular.withSize(18.0)
        self.rightViewTextField.font = AppFonts.Regular.withSize(18.0)
        self.countryCodeLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    
    @objc  func leftViewTap(gesture: UITapGestureRecognizer) {
        if let idxPath = indexPath {
            delegate?.threePartLeftViewTap(idxPath, gesture)
        }
        
    }
    
    @objc func middleViewTap(gesture: UITapGestureRecognizer) {
        if let idxPath = indexPath {
            delegate?.middleViewTap(idxPath,gesture)
        }
        printDebug("middle view tapped")
        
    }
    
    
    // MARK: - IB Actions
    
    @IBAction func deleteCellButtonTapped(_ sender: Any) {
        
        if let idxPath = indexPath {
            delegate?.editProfileThreePartDeleteCellTapped(idxPath)
        }
    }
    
    
}


// MARK:- TextFieldDelegateMethods

extension EditProfileThreePartTableViewCell : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        printDebug("text field text \(textField.text ?? " ")")
        guard let inputMode = textField.textInputMode else {
            return false
        }
        if inputMode.primaryLanguage == "emoji" || !(inputMode.primaryLanguage != nil) {
            return false
        }
        return true
    }
    @objc func textFieldDidChanged(_ textField: UITextField) {
        if let idxPath = indexPath {
            delegate?.editProfileThreePartTableViewCellTextFieldText(textField, idxPath, self.rightViewTextField.nationalNumber, isValide: self.rightViewTextField.isValidNumber)
            // delegate?.editProfileThreePartTableViewCellTextFieldText(textField, idxPath, self.rightViewTextField.text ?? "", isValide: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
