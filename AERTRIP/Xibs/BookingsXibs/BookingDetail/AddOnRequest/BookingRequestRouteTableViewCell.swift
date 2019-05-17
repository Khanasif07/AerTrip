//
//  BookingRequestRouteTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 16/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingRequestRouteTableViewCell: ATTableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var routeLabel: UILabel!
     @IBOutlet weak var routeIdLabel: UILabel!

    
    override func setupFonts() {
        self.routeLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.routeIdLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupTexts() {
        self.routeLabel.text = "BOM → DEL"
        self.routeIdLabel.text = "CS/16-17/453640"
    }
    
    override func setupColors() {
        self.routeLabel.textColor = AppColors.themeBlack
        self.routeIdLabel.textColor = AppColors.themeGray40
    }

   
}
