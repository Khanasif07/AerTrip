//
//  ContactTableCell.swift
//  AERTRIP
//
//  Created by Admin on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import PhoneNumberKit


protocol ContactTableCellDelegate: class {
    func textFieldText(_ textField:UITextField)
    func setIsdCode(_ countryDate:PKCountryModel,_ sender: UIButton)
}

class ContactTableCell: UITableViewCell {
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countryCodeContainerView: UIView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var contactNumberTextField: PhoneNumberTextField!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var contactTitleLabel: UILabel!
    @IBOutlet weak var dividerViewBottomConstraint: NSLayoutConstraint!
    
    
    private var preSelectedCountry: PKCountryModel?
    weak var delegate: ContactTableCellDelegate?
    var minContactLimit = 10
    
    //MARK:- Life Cycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func configUI() {
        titleLabel.font = AppFonts.Regular.withSize(14.0)
        titleLabel.textColor = AppColors.themeGray40
        titleLabel.text = LocalizedString.Mobile.localized
        
        countryCodeLabel.font = AppFonts.Regular.withSize(18.0)
        countryCodeLabel.textColor = AppColors.themeBlack
        
        contactTitleLabel.font = AppFonts.Regular.withSize(14.0)
        contactTitleLabel.textColor = AppColors.themeGray40
        contactTitleLabel.text = LocalizedString.Mobile.localized
        
         contactNumberTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        contactNumberTextField.font = AppFonts.Regular.withSize(18.0)
        contactNumberTextField.textColor = AppColors.themeBlack
        contactNumberTextField.placeholder = LocalizedString.Mobile.localized
        contactNumberTextField.text = UserInfo.loggedInUser?.mobile
        
        if let current = PKCountryPicker.default.getCountryData(forISDCode: UserInfo.loggedInUser?.isd ?? "+91") {
            preSelectedCountry = current
            flagImageView.image = current.flagImage
            countryCodeLabel.text = current.countryCode
            minContactLimit = current.minNSN
        }
        
        contactNumberTextField.delegate = self
    }

    //MARK:- Public
    @IBAction func selectCountruButtonAction(_ sender: UIButton) {
        if let vc = UIApplication.topViewController() {
            let prevSectdContry = preSelectedCountry
            self.delegate?.setIsdCode(prevSectdContry!, sender)
            PKCountryPicker.default.chooseCountry(onViewController: vc, preSelectedCountry: prevSectdContry) { [weak self] (selectedCountry,closePicker) in
                guard let sSelf = self else {return}
                sSelf.preSelectedCountry = selectedCountry
                sSelf.flagImageView.image = selectedCountry.flagImage
                sSelf.countryCodeLabel.text = selectedCountry.countryCode
                sSelf.contactNumberTextField.defaultRegion = selectedCountry.ISOCode
                sSelf.minContactLimit = selectedCountry.minNSN
                sSelf.contactNumberTextField.text = sSelf.contactNumberTextField.nationalNumber
                sSelf.delegate?.setIsdCode(selectedCountry,sender)
            }
        }
    }
    
    internal func checkForErrorStateOfTextfield() {
        let finalTxt = (contactNumberTextField.text ?? "").removeAllWhitespaces

        titleLabel.textColor = AppColors.themeGray40
        
        
//        self.editableTextField.isError = finalTxt.checkInvalidity(.Email)
        
        let isValidEmail = !(finalTxt.alphanumeric.count < self.minContactLimit)
        if !isValidEmail, !finalTxt.isEmpty {
           titleLabel.textColor = AppColors.themeRed
        }
        let firstName = self.contactNumberTextField.placeholder ?? ""
        self.contactNumberTextField.attributedPlaceholder = NSAttributedString(string: firstName, attributes: [NSAttributedString.Key.foregroundColor: isValidEmail ? AppColors.themeGray40 :  AppColors.themeRed])
    }
}

extension ContactTableCell : UITextFieldDelegate {
    @objc func textFieldDidChanged(_ textField: UITextField) {
        delegate?.textFieldText(textField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        PKCountryPicker.default.closePicker()
        titleLabel.textColor = AppColors.themeGray40
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        return (newString as String).alphanumeric.count <= self.minContactLimit
       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForErrorStateOfTextfield()
    }

}
