//
//  BookingHDRoomDetailTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingHDRoomDetailTableViewCell: ATTableViewCell {

    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleValueLabel: UILabel!
    
    
    //  Override methods
    override func setupFonts() {
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.titleValueLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeGray40
        self.titleValueLabel.textColor = AppColors.textFieldTextColor51
    }
    
    
    func configureCell(title: String, text: String) {
        self.titleLabel.text = title
        self.titleValueLabel.text = text
    }
    
   
    
}
