//
//  FareDetailTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FareDetailTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet weak var fareDetailTitleLabel: UILabel!
    @IBOutlet weak var numberOfRoomAndLabel: UILabel!
    @IBOutlet weak var totalPayableNowLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpText()
        self.setUpFont()
        self.setUpColor()
    }

    
    private func setUpText() {
        self.fareDetailTitleLabel.text = LocalizedString.FareDetails.localized
        self.totalPayableNowLabel.text = LocalizedString.TotalPayableNow.localized
        self.totalPriceLabel.text = "67,000"
    }
    
    private func setUpFont() {
        self.fareDetailTitleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.numberOfRoomAndLabel.font = AppFonts.Regular.withSize(16.0)
        self.totalPayableNowLabel.font = AppFonts.Regular.withSize(20.0)
        self.totalPriceLabel.font = AppFonts.SemiBold.withSize(20.0)
        
    }
    
    private func setUpColor() {
        self.fareDetailTitleLabel.textColor = AppColors.themeBlack
        self.numberOfRoomAndLabel.textColor = AppColors.themeBlack
        self.totalPayableNowLabel.textColor = AppColors.themeBlack
        self.totalPriceLabel.textColor = AppColors.themeBlack
    }
  
    
}
