//
//  NotificationSettingsCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 30/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class NotificationSettingsCell : UITableViewCell {

    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var settingTitleLabel: UILabel!
    @IBOutlet weak var settingDescriptionLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        settingTitleLabel.font = AppFonts.Regular.withSize(18)
        settingDescriptionLabel.font = AppFonts.Regular.withSize(14)
        settingDescriptionLabel.textColor = AppColors.themeGray20
        self.sepratorView.backgroundColor = AppColors.themeGray20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populateData(type : NotificationSettingsVM.NotificationSettingsType, desc : String){
        settingTitleLabel.text = type.rawValue
        settingDescriptionLabel.text = desc
        
        switch type {
        case .allNotifications:
            self.switch.setOn(toggleSettings.allNotificationS, animated: true)
            
        case .bookings:
            self.switch.setOn(toggleSettings.bookingNotifications, animated: true)

        case .tripEvents:
            self.switch.setOn(toggleSettings.tripEventsNotifications, animated: true)
            
        case .others:
            self.switch.setOn(toggleSettings.otherNotifications, animated: true)
            
        }
        
    }
    
}
