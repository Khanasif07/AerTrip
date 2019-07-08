//
//  EconomySaverTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class EconomySaverTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlet
    @IBOutlet weak var economySaverTitleLabel: UILabel!
    @IBOutlet weak var refundInfoLabel: UILabel!
   @IBOutlet weak var dividerView: ATDividerView!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.setUpTextColor()
        self.setUpFont()
        
    }

    
    
    
    func setUpTextColor() {
        self.economySaverTitleLabel.textColor = AppColors.themeBlack
        self.refundInfoLabel.textColor = AppColors.themeGray40
    }
    
    func setUpFont() {
        self.economySaverTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.refundInfoLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    func configureCell() {
        self.economySaverTitleLabel.text = "Economy Saver (SS50322)"
        self.refundInfoLabel.text         = "Non-refundable • Non-reschedulable"
    }
}
