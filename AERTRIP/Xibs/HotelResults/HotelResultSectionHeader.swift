//
//  HotelResultSectionHeader.swift
//  AERTRIP
//
//  Created by Admin on 01/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelResultSectionHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.layer.cornerRadius = titleLabel.frame.size.height / 2
        titleLabel.layer.masksToBounds = true
        titleLabel.backgroundColor = AppColors.themeGray10
        titleLabel.font = AppFonts.Regular.withSize(14.0)
    }
}
