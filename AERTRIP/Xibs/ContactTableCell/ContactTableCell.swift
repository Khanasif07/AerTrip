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
    func setIsdCode(_ countryDate:PKCountryModel)
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

    
    private var preSelectedCountry: PKCountryModel?
    weak var delegate: ContactTableCellDelegate?
    
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
        titleLabel.text = LocalizedString.Country.localized
        
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
        }
        
        contactNumberTextField.delegate = self
    }
    
    //MARK:- Public
    @IBAction func selectCountruButtonAction(_ sender: UIButton) {
        if let vc = UIApplication.topViewController() {
            let prevSectdContry = preSelectedCountry
            PKCountryPicker.default.chooseCountry(onViewController: vc, preSelectedCountry: prevSectdContry) { [weak self] (selectedCountry,closePicker) in
                guard let sSelf = self else {return}
                sSelf.preSelectedCountry = selectedCountry
                sSelf.flagImageView.image = selectedCountry.flagImage
                sSelf.countryCodeLabel.text = selectedCountry.countryCode
                sSelf.contactNumberTextField.defaultRegion = selectedCountry.ISOCode
                sSelf.contactNumberTextField.text = sSelf.contactNumberTextField.nationalNumber
                sSelf.delegate?.setIsdCode(selectedCountry)
            }
        }
    }
}

extension ContactTableCell : UITextFieldDelegate {
    @objc func textFieldDidChanged(_ textField: UITextField) {
        delegate?.textFieldText(textField)
    }
}
