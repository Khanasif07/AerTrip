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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingTitleLabel.font = AppFonts.Regular.withSize(18)
        settingDescriptionLabel.font = AppFonts.Regular.withSize(14)
        settingDescriptionLabel.backgroundColor = AppColors.themeGray20
        self.sepratorView.backgroundColor = AppColors.themeGray20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func populateData(type : NotificationSettingsVM.NotificationSettingsType, desc : String){
        settingTitleLabel.text = type.rawValue
        settingDescriptionLabel.text = desc
    }
    
}
