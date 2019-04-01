//
//  FareSectionHeader.swift
//  AERTRIP
//
//  Created by apple on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FareSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet var grossFareTitleLabel: UILabel!
    @IBOutlet var discountsTitleLabel: UILabel!
    @IBOutlet var grossPriceLabel: UILabel!
    @IBOutlet var discountPriceLabel: UILabel!
    
    override func awakeFromNib() {
        self.setUpText()
        self.setUpFont()
        self.setUpTextColor()
    }
    
    private func setUpText() {
        self.grossFareTitleLabel.text = LocalizedString.GrossFare.localized
        self.discountsTitleLabel.text = LocalizedString.Discounts.localized
    //    self.grossPriceLabel.text = AppConstants.kRuppeeSymbol + "\(Double(65000).delimiter)"
        self.discountPriceLabel.text = AppConstants.kRuppeeSymbol + "\(Double(500).delimiter)"
    }
    
    private func setUpFont() {
        self.grossFareTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.discountPriceLabel.font = AppFonts.Regular.withSize(16.0)
        self.grossPriceLabel.font = AppFonts.Regular.withSize(16.0)
        self.discountPriceLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    private func setUpTextColor() {
        self.grossFareTitleLabel.textColor = AppColors.themeBlack
        self.discountPriceLabel.textColor = AppColors.themeBlack
        self.grossPriceLabel.textColor = AppColors.themeBlack
        self.discountPriceLabel.textColor = AppColors.themeBlack
    }
}
