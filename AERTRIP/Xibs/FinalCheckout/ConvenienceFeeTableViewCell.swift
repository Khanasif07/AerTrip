//
//  ConvenienceFeeTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 04/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ConvenienceFeeTableViewCell: UITableViewCell {
    @IBOutlet weak var convenienceFeeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpColor()
    }
    
    private func setUpFont() {
        self.convenienceFeeLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    private func setUpColor() {
        self.convenienceFeeLabel.textColor = AppColors.themeBlack
    }
}
