//
//  SingleFlightResultTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 06/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class SingleFlightResultTableViewCell: UITableViewCell {

    //MARK: - IBOutlet

    @IBOutlet weak var titleLabel: UILabel!
    
    // First row
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var departureStationLabel: UILabel!
  
    // Second row
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var arrivalStationLabel: UILabel!
    
    // Third row
     @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    
    // Fourth row
    @IBOutlet weak var ForLabel: UILabel!
    @IBOutlet weak var adulteChildLabel: UILabel!
    
    // Fifth  row
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var classValue: UILabel!
    
    // Sixth row return row
    @IBOutlet weak var returnLabel: UILabel!
    @IBOutlet weak var returnDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.setUpText()
        self.setUpFont()
        self.setUpColor()
        
    }

   
    private func setUpText() {
        // Left hand side text setup
        self.fromLabel.text = LocalizedString.From.localized
        self.toLabel.text = LocalizedString.To.localized
        self.departureLabel.text = LocalizedString.Departure.localized
        self.returnLabel.text = LocalizedString.Return.localized
        self.ForLabel.text = LocalizedString.For.localized
        self.classLabel.text = LocalizedString.Class.localized
        
        
        
    }
    
    private func setUpFont() {
        // Left hand side text setup
        self.titleLabel.font     = AppFonts.Regular.withSize(18.0)
        self.fromLabel.font      = AppFonts.Regular.withSize(18.0)
        self.toLabel.font        = AppFonts.Regular.withSize(18.0)
        self.departureLabel.font = AppFonts.Regular.withSize(18.0)
        self.returnLabel.font    = AppFonts.Regular.withSize(18.0)
        self.ForLabel.font       = AppFonts.Regular.withSize(18.0)
        self.classLabel.font     = AppFonts.Regular.withSize(18.0)
        
        // Right hand side text setup
        self.departureStationLabel.font = AppFonts.Regular.withSize(18.0)
        self.arrivalStationLabel.font = AppFonts.Regular.withSize(18.0)
        self.departureDateLabel.font = AppFonts.Regular.withSize(18.0)
        self.returnDateLabel.font = AppFonts.Regular.withSize(18.0)
        self.adulteChildLabel.font = AppFonts.Regular.withSize(18.0)
        self.classValue.font = AppFonts.Regular.withSize(18.0)
        
    }
    
    private func setUpColor() {
        // Left hand side text setup
        self.titleLabel.textColor        = AppColors.themeBlack
        self.fromLabel.textColor         = AppColors.themeBlack
        self.toLabel.textColor           = AppColors.themeBlack
        self.departureLabel.textColor    = AppColors.themeBlack
        self.returnLabel.textColor       = AppColors.themeBlack
        self.ForLabel.textColor          = AppColors.themeBlack
        self.classLabel.textColor        = AppColors.themeBlack
        
         // Right hand side text setup
        
        self.departureStationLabel.textColor = AppColors.themeGreen
        self.arrivalStationLabel.textColor = AppColors.themeGreen
        self.departureDateLabel.textColor = AppColors.themeGreen
        self.returnDateLabel.textColor = AppColors.themeGreen
        self.adulteChildLabel.textColor = AppColors.themeGreen
        self.classValue.textColor = AppColors.themeGreen
        
        
    }
    
}
