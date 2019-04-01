//
//  GuestDetailTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol GuestDetailTableViewCellDelegate: class {
    func textField(_ textField: UITextField)
    func textFieldWhileEditing(_ textField: UITextField)
}

class GuestDetailTableViewCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet var guestTitleLabel: UILabel!
    @IBOutlet var salutationTextField: PKFloatLabelTextField!
    @IBOutlet var firstNameTextField: PKFloatLabelTextField!
    @IBOutlet var lastNameTextField: PKFloatLabelTextField!
    
    // MARK: - Properties
    
    weak var delegate: GuestDetailTableViewCellDelegate?
    let salutationPicker = UIPickerView()
    
    var guestDetail: ATContact? {
        didSet {
            configureCell()
        }
    }
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpColor()
        self.doInitalSetup()
    }
    
//    override func prepareForReuse() {
//        self.salutationTextField.text = ""
//        self.firstNameTextField.text = ""
//        self.lastNameTextField.text = ""
//    }
    
    // MARK: - Helper methods
    
    private func doInitalSetup() {
        self.salutationTextField.titleYPadding = -10.0
        self.firstNameTextField.titleYPadding = -10.0
        self.lastNameTextField.titleYPadding = -10.0
        self.salutationTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.salutationPicker.delegate = self
        self.salutationTextField.inputView = self.salutationPicker
        self.salutationTextField.inputAccessoryView = self.initToolBar(picker: self.salutationPicker)
        self.salutationTextField.tintColor = UIColor.clear
        self.firstNameTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        self.lastNameTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    private func setUpFont() {
        self.guestTitleLabel.font = AppFonts.SemiBold.withSize(16.0)
        let attributes = [NSAttributedString.Key.foregroundColor: AppColors.themeGray20,
                          .font: AppFonts.Regular.withSize(18.0)]
        salutationTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.Title.localized, attributes: attributes)
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.FirstName.localized, attributes: attributes)
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.LastName.localized, attributes: attributes)
        self.salutationTextField.font = AppFonts.Regular.withSize(18.0)
        self.firstNameTextField.font = AppFonts.Regular.withSize(18.0)
        self.lastNameTextField.font = AppFonts.Regular.withSize(18.0)
    }
    
    private func setUpColor() {
        self.guestTitleLabel.textColor = AppColors.themeBlack
        self.salutationTextField.textColor = AppColors.textFieldTextColor51
        self.firstNameTextField.textColor = AppColors.textFieldTextColor51
        
        self.lastNameTextField.textColor = AppColors.textFieldTextColor51
        self.salutationTextField.titleActiveTextColour = AppColors.themeGreen
        self.firstNameTextField.titleActiveTextColour = AppColors.themeGreen
        self.lastNameTextField.titleActiveTextColour = AppColors.themeGreen
    }
    
    private func configureCell() {
        if let type = self.guestDetail?.passengerType, let number = self.guestDetail?.numberInRoom, number >= 0 {
            self.guestTitleLabel.text = (type == PassengersType.Adult) ? "\(LocalizedString.Adult.localized) \(number)" : "\(LocalizedString.Child.localized) \(number)(\(self.guestDetail?.age ?? 0))"
        }
    }
    
    func initToolBar(picker: UIPickerView) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 14.0 / 255, green: 122.0 / 255, blue: 254.0 / 255, alpha: 1)
        toolBar.sizeToFit()
        // TODO: need to update actions for all buttons
        let cancelButton = UIBarButtonItem(title: LocalizedString.Cancel.localized, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        let doneButton = UIBarButtonItem()
        doneButton.title = LocalizedString.Done.localized
        
        cancelButton.tintColor = AppColors.themeGreen
        doneButton.tintColor = AppColors.themeGreen
        
        doneButton.addTargetForAction(self, action: #selector(self.pickerViewDoneButtonAction(_:)))
        cancelButton.addTargetForAction(self, action: #selector(self.cancleButtonAction(_:)))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    @objc func pickerViewDoneButtonAction(_ sender: UITextField) {
        let index = self.salutationPicker.selectedRow(inComponent: 0)
        self.salutationTextField.text = GuestDetailsVM.shared.salutation[index]
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    @objc func cancleButtonAction(_ sender: UITextField) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension GuestDetailTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.salutationTextField:
            self.delegate?.textField(self.salutationTextField)
            self.salutationTextField.becomeFirstResponder()
        case self.firstNameTextField:
            self.delegate?.textField(self.firstNameTextField)
        case self.lastNameTextField:
            self.delegate?.textField(self.lastNameTextField)
        default:
            break
        }
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        self.delegate?.textFieldWhileEditing(textField)
    }
}

// MARK: - Extension UIPickerViewDataSource, UIPickerViewDelegate

// MARK: -

extension GuestDetailTableViewCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GuestDetailsVM.shared.salutation.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return GuestDetailsVM.shared.salutation[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        printDebug(" selected title is \(GuestDetailsVM.shared.salutation[row])")
    }
}
