//
//  BookingDirectionTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 21/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingDirectionTableViewCell: ATTableViewCell {
    // MARK: - IBOutlet
    
    @IBOutlet weak var airportCodeLabel: UILabel!
    @IBOutlet weak var airportNameLabel: UILabel!
    @IBOutlet weak var aiportAddressLabel: UILabel!
    @IBOutlet weak var bottomDividerView: UIView!
    @IBOutlet weak var edgeToedgeBottomDividerView: UIView!
    
    // MARK: Override methods
    
    override func setupFonts() {
        self.airportCodeLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.airportNameLabel.font = AppFonts.Regular.withSize(18.0)
        self.aiportAddressLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    override func setupColors() {
        self.airportCodeLabel.textColor = AppColors.themeDarkGreen
        self.airportNameLabel.textColor = AppColors.themeBlack
        self.aiportAddressLabel.textColor = AppColors.themeGray40
    }
    
    func configureCell(airportCode: String, airportName: String, airportAddress: String) {
        self.airportCodeLabel.text = airportCode
        self.airportNameLabel.text = airportName
        self.aiportAddressLabel.text = airportAddress
    }
}
