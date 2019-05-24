//
//  BookingSchedulingPassengerTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 23/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingSchedulingPassengerTableViewCell: ATTableViewCell {

  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleValueLabel: UILabel!
    
   
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeGray40
        self.titleValueLabel.textColor = AppColors.themeGray40
    }
    
    override func setupFonts() {
      self.titleLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
}
