//
//  BaggageInfoTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 10/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BaggageInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var baggageImageView: UIImageView!
    @IBOutlet weak var baggageTitleLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var baggageDetailLabel: UILabel!
    @IBOutlet weak var baggageAdditionalDetailLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.setUpFont()
        self.setUpTextColor()
        
    }

    
    
    // MARK: - Helper methods
    
    private func setUpFont() {
        self.baggageTitleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.baggageDetailLabel.font = AppFonts.Regular.withSize(16.0)
        self.baggageAdditionalDetailLabel.font = AppFonts.Regular.withSize(16.0)
        
    }
    
    private func setUpTextColor() {
        self.baggageTitleLabel.textColor = AppColors.themeBlack
        self.baggageDetailLabel.textColor = AppColors.themeBlack
        self.baggageAdditionalDetailLabel.textColor = AppColors.themeGray60
        
    }
 
    
}
