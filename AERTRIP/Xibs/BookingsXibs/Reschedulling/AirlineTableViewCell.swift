//
//  AirlineTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 23/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AirlineTableViewCell: ATTableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet weak var airlineNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var airlineImageView: UIImageView!
    
   
    
    
    // MARK: - Override methods
    
    
    override func setupColors() {
        self.airlineNameLabel.textColor = AppColors.themeBlack
        self.infoLabel.textColor = AppColors.textFieldTextColor51
    }
    
    override func setupFonts() {
        self.airlineNameLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.infoLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    
    
    // MARK: - Helper methods
    
    func configureCell(airlineName: String,info:String) {
        self.airlineNameLabel.text = airlineName
        self.infoLabel.text = info
    }

   
}
