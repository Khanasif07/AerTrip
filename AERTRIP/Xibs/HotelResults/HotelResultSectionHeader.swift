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
    @IBOutlet weak var labelBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.layer.cornerRadius = titleLabel.frame.size.height / 2
        labelBackgroundView.layer.cornerRadius =  labelBackgroundView.frame.size.height / 2
        labelBackgroundView.layer.masksToBounds = true
        titleLabel.layer.masksToBounds = true
        labelBackgroundView.addBlurEffect(backgroundColor: AppColors.themeGray10.withAlphaComponent(0.85), style:  UIBlurEffect.Style.light, alpha: 1)
        labelBackgroundView.backgroundColor = AppColors.clear
        titleLabel.font = AppFonts.Regular.withSize(14.0)
    }
}
