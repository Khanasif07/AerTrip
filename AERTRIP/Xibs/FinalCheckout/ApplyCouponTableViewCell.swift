//
//  ApplyCouponTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ApplyCouponTableViewCell: UITableViewCell {
    
    @IBOutlet weak var couponLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupFonts()
        self.setUpColors()
        self.setUpText()
    }

    // MARK: - Helper methods
    
    private func setupFonts() {
        couponLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    private func setUpColors() {
       couponLabel.textColor = AppColors.themeBlack
    }
    
    private func setUpText() {
        couponLabel.text = LocalizedString.ApplyCoupon.localized
    }
   
}
