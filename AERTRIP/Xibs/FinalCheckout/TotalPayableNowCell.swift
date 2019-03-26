//
//  TotalPayableNowCell.swift
//  AERTRIP
//
//  Created by apple on 26/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TotalPayableNowCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet var totalPayableNowLabel: UILabel!
    @IBOutlet var totalPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpText()
        self.setUpFont()
        self.setUpColor()
    }
    
    private func setUpText() {
        self.totalPayableNowLabel.text = LocalizedString.TotalPayableNow.localized
        self.totalPriceLabel.text = AppConstants.kRuppeeSymbol + "\(Double(67000).delimiter)"
    }
    
    private func setUpFont() {
        self.totalPayableNowLabel.font = AppFonts.Regular.withSize(20.0)
        self.totalPriceLabel.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    private func setUpColor() {
        self.totalPayableNowLabel.textColor = AppColors.themeBlack
        self.totalPriceLabel.textColor = AppColors.themeBlack
    }
}
