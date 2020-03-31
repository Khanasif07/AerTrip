//
//  SettingsHeaderView.swift
//  AERTRIP
//
//  Created by Appinventiv on 31/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SettingsHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clear
        self.titleLabel.textColor = AppColors.themeGray60
    }

}
