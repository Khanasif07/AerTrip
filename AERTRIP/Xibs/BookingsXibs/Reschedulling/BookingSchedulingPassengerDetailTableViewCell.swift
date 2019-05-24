//
//  BookingSchedulingPassengerDetailTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 23/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingSchedulingPassengerDetailTableViewCell: ATTableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleValueLabel: UILabel!
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.Regular.withSize(16.0)
        self.titleValueLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeGray40
        self.titleValueLabel.textColor = AppColors.themeGray40
    }
    
    func configureCell() {
        self.titleLabel.text = "Sale Amount"
        self.titleValueLabel.text = "₹ 27,000"
    }
}
