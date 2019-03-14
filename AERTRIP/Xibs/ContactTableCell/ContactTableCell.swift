//
//  ContactTableCell.swift
//  AERTRIP
//
//  Created by Admin on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import PhoneNumberKit

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
        
        contactNumberTextField.font = AppFonts.Regular.withSize(18.0)
        contactNumberTextField.textColor = AppColors.themeBlack
        contactNumberTextField.placeholder = LocalizedString.Mobile.localized
        contactNumberTextField.text = UserInfo.loggedInUser?.mobile
        
        if let current = PKCountryPicker.default.getCurrentLocalCountryData() {
            preSelectedCountry = current
            flagImageView.image = current.flagImage
            countryCodeLabel.text = current.countryCode
        }
    }
    
    //MARK:- Public
    @IBAction func selectCountruButtonAction(_ sender: UIButton) {
        if let vc = UIApplication.topViewController() {
            PKCountryPicker.default.chooseCountry(onViewController: vc, preSelectedCountry: preSelectedCountry) { [weak self](country) in
                
                guard let sSelf = self else {return}
                sSelf.preSelectedCountry = country
                sSelf.flagImageView.image = country.flagImage
                sSelf.countryCodeLabel.text = country.countryCode
                sSelf.contactNumberTextField.defaultRegion = country.ISOCode
                sSelf.contactNumberTextField.text = sSelf.contactNumberTextField.nationalNumber
                
                PKCountryPicker.default.closePicker(animated: true)
            }
        }
    }
}
