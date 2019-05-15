//
//  BookingHDWebPhoneTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingHDWebPhoneTableViewCell: ATTableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleValueLabel: UILabel!
    
    @IBOutlet weak var dividerView: UIView!
   
    
    override func setupFonts() {
    self.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.titleValueLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleValueLabel.textColor = AppColors.themeBlack
    }
    
    func configureCell() {
        self.titleLabel.text = "Website"
        self.titleValueLabel.text = "www.ramadapowai.com"
    }
    

}

