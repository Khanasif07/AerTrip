//
//  FlightTimeLocationInfoTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 10/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightTimeLocationInfoTableViewCell: UITableViewCell {

    
    // MARK: - IBOutlets
    
    // source
    @IBOutlet weak var sourceFlightCodeLabel: UILabel!
    @IBOutlet weak var sourceDateLabel: UILabel!
    @IBOutlet weak var sourceFlightNameLbel: UILabel!
    @IBOutlet weak var sourceFlightAddressLabel: UILabel!
     @IBOutlet weak var sourceTerminalLabel: UILabel!
    
    // Destination
    @IBOutlet weak var destinationFlightCodeLabel: UILabel!
    @IBOutlet weak var destinationDateLabel: UILabel!
    @IBOutlet weak var destinationFlightNameLbel: UILabel!
    @IBOutlet weak var destinationFlightAddressLabel: UILabel!
    @IBOutlet weak var destinationTerminalLabel: UILabel!
    

    // Travel Time Label
    
    @IBOutlet weak var dayNightImageView: UIImageView!
    @IBOutlet weak var travelTimeLabel: UILabel!
    @IBOutlet weak var  dottedView: UIView!
    @IBOutlet weak var wingNameLabel: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.setUpFonts()
        self.setUpTextColor()
        
    }
    
    
    func configureCell() {
        
        
        // source
        self.sourceFlightCodeLabel.text = "BOM 02:55"
        self.sourceDateLabel.text =  "Fri, 20 Nov 2017"
        self.sourceFlightNameLbel.text =  "Chhatrapati Shivaji International Airport,"
        self.sourceFlightAddressLabel.text =  "Mumbai, IN"
        self.sourceTerminalLabel.text =  "T-3"
    
        // Destination
        self.destinationFlightCodeLabel.text = "BOM 02:55"
        self.destinationDateLabel.text =  "Fri, 20 Nov 2017"
        self.destinationFlightNameLbel.text =  "Chhatrapati Shivaji International Airport,"
        self.destinationFlightAddressLabel.text =  "Mumbai, IN"
        self.destinationTerminalLabel.text =  "T-3"
        
        
        // Travel 
        
        self.travelTimeLabel.text = "15h 34m"
        self.wingNameLabel.text = "Boeing 777-888 Passenger Aircraft (wingman) 3 - 3 - 3 . "
        
        
    }

    
    // MARK: - Helper methods
    
    private func setUpFonts() {
        self.sourceFlightCodeLabel.font = AppFonts.SemiBold.withSize(24.0)
         self.sourceDateLabel.font = AppFonts.Regular.withSize(14.0)
         self.sourceFlightNameLbel.font = AppFonts.Regular.withSize(14.0)
         self.sourceFlightAddressLabel.font = AppFonts.Regular.withSize(14.0)
         self.sourceTerminalLabel.font = AppFonts.Regular.withSize(14.0)
        
        //Destination
        self.destinationFlightCodeLabel.font = AppFonts.SemiBold.withSize(24.0)
        self.destinationDateLabel.font = AppFonts.Regular.withSize(14.0)
        self.destinationFlightNameLbel.font = AppFonts.Regular.withSize(14.0)
        self.destinationFlightAddressLabel.font = AppFonts.Regular.withSize(14.0)
        self.destinationTerminalLabel.font = AppFonts.Regular.withSize(14.0)
        
        // Travel Time
        self.travelTimeLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.wingNameLabel.font = AppFonts.Regular.withSize(12.0)
        
    }
    
    private func setUpTextColor() {
        self.sourceFlightCodeLabel.textColor = AppColors.themeBlack
        self.sourceDateLabel.textColor = AppColors.themeBlack
        self.sourceFlightNameLbel.textColor = AppColors.themeGray40
        self.sourceFlightAddressLabel.textColor = AppColors.themeBlack
        self.sourceTerminalLabel.textColor = AppColors.themeBlack
        
        self.destinationFlightCodeLabel.textColor = AppColors.themeBlack
        self.destinationDateLabel.textColor = AppColors.themeBlack
        self.destinationFlightNameLbel.textColor = AppColors.themeGray40
        self.destinationFlightAddressLabel.textColor = AppColors.themeBlack
        self.destinationTerminalLabel.textColor = AppColors.themeBlack
        
        // Travel Time
        self.travelTimeLabel.textColor = AppColors.themeGray60
        self.wingNameLabel.textColor = AppColors.themeGray40
    }
 
}
