//
//  DiscountCell.swift
//  AERTRIP
//
//  Created by apple on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class DiscountCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpText()
        self.setUpFont()
        self.setUpColor()
    }
    
    private func setUpText() {
        self.titleLabel.text = LocalizedString.CouponDiscount.localized
        self.amountLabel.text = AppConstants.kRuppeeSymbol + "\(Double(500).delimiter)"
    }
    
    private func setUpFont() {
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.amountLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    private func setUpColor() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.amountLabel.textColor = AppColors.themeBlack
    }
}
