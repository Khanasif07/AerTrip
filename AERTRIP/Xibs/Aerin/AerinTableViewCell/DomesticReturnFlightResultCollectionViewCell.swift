//
//  DomesticReturnFlightResultCollectionViewCell.swift
//  AERTRIP
//
//  Created by apple on 07/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class DomesticReturnFlightResultCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
   
    // One way View
    @IBOutlet weak var sourceFlightImageview: UIImageView!
    @IBOutlet weak var sourceCodeLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var travelTimeLabel: UILabel!
    @IBOutlet weak var sourceAirportNameLabel: UILabel!
    @IBOutlet weak var destinationAirportNameLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    
    // Return View
    @IBOutlet weak var returnSourceFlightImageView:UIImageView!
    @IBOutlet weak var returnDepartureTimeLabel: UILabel!
    @IBOutlet weak var returnArrivalTimeLabel: UILabel!
    @IBOutlet weak var returnTravelTimeLabel: UILabel!
    @IBOutlet weak var returnSourceAirportNameLabel: UILabel!
    @IBOutlet weak var returnDestinationAirportNameLabel: UILabel!
    
    @IBOutlet weak var returnPriceLabel: UILabel!
    
    // Price View
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var showAllTextLabel: UILabel!
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
      
        
    }
    
    
    private func setUpFont() {
        
        // One way
        self.sourceCodeLabel.font           =   AppFonts.Regular.withSize(14.0)
        self.sourceAirportNameLabel.font    =   AppFonts.Regular.withSize(16.0)
        self.destinationAirportNameLabel.font = AppFonts.Regular.withSize(16.0)
        self.departureTimeLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.arrivalTimeLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.travelTimeLabel.font = AppFonts.Regular.withSize(14.0)
        
        // Return View
        self.returnDepartureTimeLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.returnArrivalTimeLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.returnTravelTimeLabel.font = AppFonts.Regular.withSize(14.0)
        self.returnPriceLabel.font = AppFonts.Regular.withSize(16.0)
        
        // Price View
        
        self.totalPriceLabel.font  = AppFonts.SemiBold.withSize(18.0)
        self.bookButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        self.showAllTextLabel.font = AppFonts.Regular.withSize(16.0)
        
    }
    
    private func setUpColor() {
        // One way
        self.sourceCodeLabel.textColor           =   AppColors.themeGray60
        self.sourceAirportNameLabel.textColor    =   AppColors.themeGray40
        self.destinationAirportNameLabel.textColor =  AppColors.themeGray40
        self.departureTimeLabel.textColor = AppColors.themeBlack
        self.arrivalTimeLabel.textColor = AppColors.themeBlack
        self.travelTimeLabel.textColor =  AppColors.themeBlack
        
        // Return View
        self.returnDepartureTimeLabel.textColor = AppColors.themeBlack
        self.returnArrivalTimeLabel.textColor = AppColors.themeBlack
        self.returnTravelTimeLabel.textColor = AppColors.themeBlack
        self.returnPriceLabel.textColor = AppColors.themeBlack
        
        // Price View
        
        self.totalPriceLabel.textColor  = AppColors.themeWhite
        self.bookButton.titleLabel?.textColor = AppColors.themeWhite
        self.showAllTextLabel.textColor = AppColors.themeGray40
    }
    

}
