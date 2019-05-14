//
//  BookingTravellerDetailTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingTravellerDetailTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleValueLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpColor()
        
    }
    
    
    private func setUpFont() {
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.titleValueLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    private func setUpColor() {
        self.titleLabel.textColor = AppColors.themeGray40
        self.titleValueLabel.textColor = AppColors.textFieldTextColor51
    }
    
    func configureCell() {
        self.titleLabel.text = "PNR"
         self.titleValueLabel.text = "GRE7456 (Booked)"
    }
}
