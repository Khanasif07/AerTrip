//
//  UseGSTINCell.swift
//  Aertrip
//
//  Created by Apple  on 04.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

enum GSTCellTextFields{
    case companyName, billingName, gstNumber
}

protocol UseGSTINCellDelegate:NSObjectProtocol {
    func changeSwitchValue(isOn:Bool)
    func tapOnSelectGST()
    func editTextFields(_ textFiledType: GSTCellTextFields, text: String)
}

class UseGSTINCell: UITableViewCell {

    @IBOutlet weak var useGSTTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var gstSwitch: UISwitch!
    @IBOutlet weak var subTitleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var useGSTTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectGSTDetailView: UIView!
    @IBOutlet weak var selectGSTTextField: PKFloatLabelTextField!
    @IBOutlet weak var selectGSTFieldSeparatorView: UIView!
    @IBOutlet weak var gSTDetailsLabel: UILabel!
    @IBOutlet weak var enterGSTView: UIView!
    @IBOutlet weak var companyNameTextField: PKFloatLabelTextField!
    @IBOutlet weak var companyNameSeparatorView: ATDividerView!
    @IBOutlet weak var billingNameTextField: PKFloatLabelTextField!
    @IBOutlet weak var billingNameSeperatorView: ATDividerView!
    @IBOutlet weak var gSTNumberTextField: PKFloatLabelTextField!
    @IBOutlet weak var gstNumberDivider: ATDividerView!
    weak var delegate:UseGSTINCellDelegate?
    var isErrorNeedToShowError = false
    var gstModel = GSTINModel(){
        didSet{
            self.configureCell()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFont()
        self.selectionStyle = .none
        self.selectGSTDetailView.isHidden = true
        self.enterGSTView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setSeperatorColor()
        self.selectGSTDetailView.isHidden = true
        self.enterGSTView.isHidden = true
    }
    
    func setSeperatorColor(){
        [companyNameSeparatorView, billingNameSeperatorView, selectGSTFieldSeparatorView].forEach {[weak self] view in
            guard let _ = self else {return}
            view?.backgroundColor = AppColors.divider.color
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapSwitch(_ sender: UISwitch) {
        self.delegate?.changeSwitchValue(isOn: sender.isOn)
    }
    
    @IBAction func tapSelectGSTBtn(_ sender: Any) {
        self.delegate?.tapOnSelectGST()
    }
    
    func setupFont(){
        useGSTTitleLabel.font = AppFonts.Regular.withSize(18.0)
        subTitleLabel.font = AppFonts.Regular.withSize(14.0)
        useGSTTitleLabel.textColor = AppColors.themeBlack
        subTitleLabel.textColor = AppColors.themeGray40
        gSTDetailsLabel.font = AppFonts.Regular.withSize(14)
        gSTDetailsLabel.textColor = AppColors.themeGray40
        selectGSTTextField.setUpAttributedPlaceholder(placeholderString: "Billing Company",with: "")
        companyNameTextField.setUpAttributedPlaceholder(placeholderString: "Company Name",with: "")
        gSTNumberTextField.setUpAttributedPlaceholder(placeholderString: "GSTIN Registration Number",with: "")
        self.billingNameTextField.setUpAttributedPlaceholder(placeholderString: "Billing Company",with: "")
        selectGSTTextField.lineColor = AppColors.clear
        selectGSTTextField.selectedLineColor = AppColors.clear
        selectGSTTextField.hintYPadding = -6
        selectGSTTextField.titleYPadding = 1.5
        [selectGSTTextField, companyNameTextField, gSTNumberTextField, billingNameTextField].forEach{[weak self] txt in
            guard let _ = self else {return}
            txt?.titleActiveTextColour = AppColors.themeGreen
            txt?.textColor =  AppColors.textFieldTextColor51
            txt?.font = AppFonts.Regular.withSize(18.0)
            txt?.titleFont = AppFonts.Regular.withSize(14.0)
            txt?.lineHeight = 0.33
            txt?.lineColor = AppColors.clear
            txt?.lineView.isHidden = true
            txt?.lineErrorColor = AppColors.clear
            txt?.selectedLineColor = AppColors.clear
            txt?.lineView.isHidden = true
            txt?.delegate = self
            txt?.addTarget(self, action: #selector(changeTextFiledValue), for: .editingDidEnd)
        }
        self.useGSTTopConstraint.constant = 10
    }
    
    func setupForNewGST(){
        self.enterGSTView.isHidden = !(self.gstSwitch.isOn)
        self.selectGSTDetailView.isHidden = true
    }
    
    func setupForSelectGST(){
        self.selectGSTDetailView.isHidden = !(self.gstSwitch.isOn)
        self.enterGSTView.isHidden = true
    }
    
    private func configureCell(){
        self.companyNameTextField.text = self.gstModel.companyName
        self.billingNameTextField.text = self.gstModel.billingName
        self.gSTNumberTextField.text = self.gstModel.GSTInNo
        if self.isErrorNeedToShowError{
            companyNameSeparatorView.defaultBackgroundColor = (self.gstModel.companyName.isEmpty) ? AppColors.themeRed : AppColors.divider.color
            billingNameSeperatorView.defaultBackgroundColor = (self.gstModel.billingName.isEmpty) ? AppColors.themeRed : AppColors.divider.color
            gstNumberDivider.defaultBackgroundColor = (!self.gstModel.GSTInNo.checkValidity(.gst)) ? AppColors.themeRed : AppColors.divider.color
        }
    }
    
}

extension UseGSTINCell: UITextFieldDelegate{
    
    @objc func changeTextFiledValue(_ textField: UITextField){
        if (textField.text?.removeAllWhitespaces.isEmpty ?? false){
            textField.text = ""
            return
        }
        switch textField {
        case self.companyNameTextField:
            self.delegate?.editTextFields(.companyName, text: textField.text ?? "")
        case self.billingNameTextField:
            self.delegate?.editTextFields(.billingName, text: textField.text ?? "")
        case self.gSTNumberTextField:
            self.delegate?.editTextFields(.gstNumber, text: textField.text ?? "")
        default:break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.companyNameTextField:
            self.delegate?.editTextFields(.companyName, text: textField.text ?? "")
        case self.billingNameTextField:
            self.delegate?.editTextFields(.billingName, text: textField.text ?? "")
        case self.gSTNumberTextField:
            self.delegate?.editTextFields(.gstNumber, text: textField.text ?? "")
        default:break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.companyNameTextField:
            companyNameSeparatorView.defaultBackgroundColor = AppColors.divider.color
        case self.billingNameTextField:
            billingNameSeperatorView.defaultBackgroundColor = AppColors.divider.color
        case self.gSTNumberTextField:
            gstNumberDivider.defaultBackgroundColor = AppColors.divider.color
        default:break
        }

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let txt = textField.text else { return false }
        
        if (range.location == 0 && string == " ") || string.containsEmoji {return false}

        if string.isBackSpace { return true }

        switch textField {
        case self.gSTNumberTextField:

            if txt.count > 14 { return false }

        default:
         return true
        }
        
        return true
    }
    
}
