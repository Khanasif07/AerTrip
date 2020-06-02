//
//  FlightContactCell.swift
//  Aertrip
//
//  Created by Apple  on 04.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit
import PhoneNumberKit

protocol FlightContactCellDelegate: class {
    func textFieldText(_ textField:PhoneNumberTextField)
    func setIsdCode(_ countryDate:PKCountryModel,_ sender: UIButton)
}

class FlightContactCell: UITableViewCell {
    
    //MARK:- IBOutlet
    //MARK:-
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countryCodeContainerView: UIView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var contactNumberTextField: PhoneNumberTextField!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var contactTitleLabel: UILabel!
    @IBOutlet weak var dividerViewBottomConstraint: NSLayoutConstraint!
    
    
    private var preSelectedCountry: PKCountryModel?
    weak var delegate: FlightContactCellDelegate?
    var vc: UIViewController?
    var isdCode = ""
    var mobile = ""
    
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
        titleLabel.text = "Country"
        
        countryCodeLabel.font = AppFonts.Regular.withSize(18.0)
        countryCodeLabel.textColor = AppColors.themeBlack
        
        contactTitleLabel.font = AppFonts.Regular.withSize(14.0)
        contactTitleLabel.textColor = AppColors.themeGray40
        contactTitleLabel.text = "Mobile"
        
         contactNumberTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        contactNumberTextField.font = AppFonts.Regular.withSize(18.0)
        contactNumberTextField.textColor = AppColors.themeBlack
        contactNumberTextField.placeholder = "Mobile"//LocalizedString.Mobile.localized
//        contactNumberTextField.text = UserInfo.loggedInUser?.mobile
        
        if let current = PKCountryPicker.default.getCountryData(forISDCode: "+91") {
            preSelectedCountry = current
            flagImageView.image = current.flagImage
            countryCodeLabel.text = current.countryCode
        }
        
        contactNumberTextField.delegate = self
    }
    
    
    func setupData(){
        let isd = (self.isdCode != "") ? self.isdCode : "+91"
        if let current = PKCountryPicker.default.getCountryData(forISDCode: isd) {
            preSelectedCountry = current
            flagImageView.image = current.flagImage
            countryCodeLabel.text = current.countryCode
        }
         self.contactNumberTextField.text = self.mobile
        
    }
    
    

    //MARK:- Public
    @IBAction func selectCountruButtonAction(_ sender: UIButton) {
        if let vc = self.vc {
            let prevSectdContry = preSelectedCountry
            self.delegate?.setIsdCode(prevSectdContry!, sender)
            PKCountryPicker.default.chooseCountry(onViewController: vc, preSelectedCountry: prevSectdContry) { [weak self] (selectedCountry,closePicker) in
                guard let self = self else {return}
                self.preSelectedCountry = selectedCountry
                self.flagImageView.image = selectedCountry.flagImage
                self.countryCodeLabel.text = selectedCountry.countryCode
                self.contactNumberTextField.defaultRegion = selectedCountry.ISOCode
                self.contactNumberTextField.text = self.contactNumberTextField.nationalNumber
                self.delegate?.setIsdCode(selectedCountry,sender)
            }
        }
    }
}

extension FlightContactCell : UITextFieldDelegate {
    @objc func textFieldDidChanged(_ textField: PhoneNumberTextField) {
        delegate?.textFieldText(textField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        PKCountryPicker.default.closePicker()
        return true
    }
}
