//
//  SettingsCellTableViewCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var settingsValueLavel: UILabel!
    @IBOutlet weak var sepratorView: ATDividerView!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        settingsValueLavel.font = AppFonts.Regular.withSize(18)
        settingsLabel.font = AppFonts.Regular.withSize(18)
//        settingsLabel.textColor = UIColor.black
        settingsValueLavel.textColor = AppColors.themeGray40
        self.sepratorView.backgroundColor = AppColors.themeGray20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func populateCell(type : SettingsVM.SettingsOptions){
        settingsLabel.text = type.rawValue
        self.settingsValueLavel.isHidden = true
        self.switch.isHidden = true
       
        switch type {
            
        case .country:
            self.settingsValueLavel.isHidden = false
            self.settingsValueLavel.text = "India"
        
        case .currency:
            self.settingsValueLavel.isHidden = false
            self.settingsValueLavel.text = CurrencyControler.shared.selectedCurrency.currencySymbol

        case .notification:
            self.settingsValueLavel.isHidden = false
            self.settingsValueLavel.text = ""
            
        case .calenderSync:
            self.switch.isHidden = false
            self.arrowImageView.isHidden = true
            self.switch.setOn(toggleSettings.calenderSyncSettings, animated: false)

        case .changePassword:
            self.settingsValueLavel.isHidden = false
            self.settingsValueLavel.text = ""
            let title = (UserInfo.loggedInUser?.hasPassword == true) ? LocalizedString.ChangePassword.localized : LocalizedString.Set_password.localized
            settingsLabel.text = title
            
        case .changeMobileNumber:
            self.settingsValueLavel.isHidden = false
            self.settingsValueLavel.text = ""
            let title = (UserInfo.loggedInUser?.mobile != "" ) ? LocalizedString.changeMobileNumber.localized : LocalizedString.setMobileNumner.localized
            settingsLabel.text = title
            
        case .disableWalletOtp:
            self.settingsValueLavel.isHidden = false
            self.settingsValueLavel.text = ""
            let title = (UserInfo.loggedInUser?.isWalletEnable == true) ? "Disable OTP for Wallet Payments" : "Enable OTP for Wallet Payments"
            settingsLabel.text = title
            
        default:
            self.settingsValueLavel.isHidden = true

        }
    }
}
