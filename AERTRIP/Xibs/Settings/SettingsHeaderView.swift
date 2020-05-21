//
//  SettingsHeaderView.swift
//  AERTRIP
//
//  Created by Appinventiv on 31/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SettingsHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var topSepratorView: ATDividerView!
    @IBOutlet weak var bottomSepratorView: ATDividerView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = AppColors.themeGray04
        self.titleLabel.textColor = AppColors.themeGray60
        titleLabel.numberOfLines = 0
        titleLabel.font = AppFonts.Regular.withSize(14)
    }

}
