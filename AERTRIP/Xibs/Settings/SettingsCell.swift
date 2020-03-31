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
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var settingsLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        settingsValueLavel.font = AppFonts.Regular.withSize(18)
        settingsLabel.font = AppFonts.Regular.withSize(18)
        settingsLabel.textColor = UIColor.black
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

        switch type {
            
        case .country:
            self.settingsValueLavel.isHidden = false
            self.settingsValueLavel.text = "India"
        case .currency:
            self.settingsValueLavel.isHidden = false
            self.settingsValueLavel.text = "$"

        case .notification:
            self.settingsValueLavel.isHidden = false
            self.settingsValueLavel.text = "All"

        default:
            self.settingsValueLavel.isHidden = true

            
            
        }
        
    }
    
    
}
