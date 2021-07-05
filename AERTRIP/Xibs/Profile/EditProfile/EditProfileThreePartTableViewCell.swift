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
    func threePartLeftViewTap(_ indexPath: IndexPath,_ gesture: UITapGestureRecognizer, textField: UITextField)
    func middleViewTap(_ indexPath: IndexPath,_ gesture: UITapGestureRecognizer)
    func editProfileThreePartTableViewCellTextFieldText(_ textField: UITextField, _ indexPath: IndexPath, _ text: String, isValide: Bool)
    
}

class EditProfileThreePartTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var blackDownImageView: UIImageView!
    @IBOutlet weak var leftSeparatorView: ATDividerView!
    @IBOutlet weak var leftViewTextField: UITextField!
    
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var rightViewTextField: PhoneNumberTextField!
    
    @IBOutlet weak var rightSeparatorView: ATDividerView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var middleSeparatorView: ATDividerView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    @IBOutlet weak var setMobileNumberLabel: UILabel!
    
    @IBOutlet weak var grayShadeView: UIView!
    @IBOutlet weak var middleViewDropDownImage: UIImageView!
    
    @IBOutlet weak var leftSeparatorLeading: NSLayoutConstraint!
    @IBOutlet weak var middleSeparatorLeading: NSLayoutConstraint!
    @IBOutlet weak var rightSeparatorLeading: NSLayoutConstraint!
    
    
    // MARK : - Variables
    weak var delegate : EditProfileThreePartTableViewCellDelegate?
    
    // MARK : - View Life cycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = AppColors.profileContentBackground
        self.setUpFonts()
        leftView.isUserInteractionEnabled = true
        rightViewTextField.placeholder = LocalizedString.Phone.localized
        self.setMobileNumberLabel.textColor = AppColors.themeGreen
        self.setMobileNumberLabel.text = "Set Mobile Number"
        self.setMobileNumberLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    var isSettingForEdit:Bool = false{
        didSet{
            if isSettingForEdit{
                self.deleteButton.setImage(AppImages.editPencel, for: .normal)
            }else{
                self.deleteButton.setImage(AppImages.redMinusButton, for: .normal)
            }
        }
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
            delegate?.threePartLeftViewTap(idxPath, gesture, textField: self.leftViewTextField)
        }
        
    }
    
    @objc func middleViewTap(gesture: UITapGestureRecognizer) {
        if let idxPath = indexPath {
            delegate?.middleViewTap(idxPath,gesture)
        }
        printDebug("middle view tapped")
        
    }
    
    
    func setupForGrayColor(_ isShowDisable: Bool){
        if isShowDisable{
            self.leftTitleLabel.textColor = AppColors.themeGray153
            self.rightViewTextField.textColor = AppColors.themeGray153
            self.countryCodeLabel.textColor = AppColors.themeGray153
            self.middleViewDropDownImage.isHidden = true
            self.countryCodeLabel.isEnabled = false
            self.grayShadeView.backgroundColor = AppColors.themeGray60.withAlphaComponent(0.3)
            self.grayShadeView.isHidden = false
        }else{
            self.leftTitleLabel.textColor = AppColors.themeBlack
            self.rightViewTextField.textColor = AppColors.themeBlack
            self.countryCodeLabel.textColor = AppColors.themeBlack
            self.middleViewDropDownImage.isHidden = false
            self.countryCodeLabel.isEnabled = true
            self.grayShadeView.backgroundColor = AppColors.clear
            self.grayShadeView.isHidden = true
        }
        
    }
    
    func isSettingForSetMobileNumber(isSettingMobile: Bool){
        if isSettingMobile{
            self.middleView.isHidden = true
            self.rightView.isHidden = true
            self.setMobileNumberLabel.isHidden = false
        }else{
            self.middleView.isHidden = false
            self.rightView.isHidden = false
            self.setMobileNumberLabel.isHidden = true
        }
    }
    
    
    // MARK: - IB Actions
    
    @IBAction func deleteCellButtonTapped(_ sender: Any) {
        
        if let idxPath = indexPath {
            delegate?.editProfileThreePartDeleteCellTapped(idxPath)
        }
    }
    
    func setSeparator(isNeeded:Bool, isError:Bool, isLast:Bool, mobile : Mobile?){
        self.leftSeparatorView.isHidden = !isNeeded
        self.middleSeparatorView.isHidden = !isNeeded
        self.rightSeparatorView.isHidden = !isNeeded
        self.leftSeparatorLeading.constant = (isLast && isNeeded) ? 0.0 : 16.0
        self.middleSeparatorLeading.constant = (isLast && isNeeded) ? 0.0 : 16.0
        self.rightSeparatorLeading.constant = (isLast && isNeeded) ? 0.0 : 16.0
        if let mobile = mobile, isError{
            var isValidMobile = true
            if mobile.isd == "+91" {
                if mobile.value.count < mobile.minValidation {
                    isValidMobile = false
                }
            } else {
                if mobile.minValidation != mobile.maxValidation {
                    isValidMobile = ((mobile.value.count >= mobile.minValidation) && (mobile.value.count <= mobile.maxValidation))
                }
            }
            if isLast{
                self.leftSeparatorView.isSettingForErrorState = (!isValidMobile || mobile.isDuplicate)
                self.middleSeparatorView.isSettingForErrorState = (!isValidMobile || mobile.isDuplicate)
            }
            self.rightSeparatorView.isSettingForErrorState = (!isValidMobile || mobile.isDuplicate)
        }else{
            self.leftSeparatorView.isSettingForErrorState = false
            self.rightSeparatorView.isSettingForErrorState = false
            self.middleSeparatorView.isSettingForErrorState = false
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.leftSeparatorView.isSettingForErrorState = false
        self.rightSeparatorView.isSettingForErrorState = false
        self.middleSeparatorView.isSettingForErrorState = false
    }
}
