//
//  FareRuleTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FareRuleTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var fareRulesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.setUpFont()
        self.setUpTextColor()
    }
    
    func setUpFont() {
        self.routeLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.fareRulesLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    func setUpTextColor() {
        self.routeLabel.textColor = AppColors.themeBlack
        self.fareRulesLabel.textColor = AppColors.themeGray60
    }
    
    
    
    func configureCell() {
        self.routeLabel.text = "BOM → JFK"
        self.fareRulesLabel.text = """
        APPLICATION AND OTHER CONDITIONS RULE - 001/IN04
        UNLESS OTHERWISE SPECIFIED
        FARES FROM INDIA TO USA
        APPLICATION
        AREA
        THESE FARES APPLY
        FROM INDIA TO THE UNITED STATES.
        CLASS OF SERVICE
        THESE FARES APPLY FOR FIRST/BUSINESS/ECONOMY CLASS
        SERVICE.
        TYPES OF TRANSPORTATION
        THIS RULE GOVERNS ONE-WAY AND ROUND-TRIP FARES.
        FARES GOVERNED BY THIS RULE CAN BE USED TO CREATE
        ONE-WAY/ROUND-TRIP/CIRCLE-TRIP/OPEN-JAW/SINGLE OPEN-
        JAW/DOUBLE OPEN-JAW JOURNEYS.
        CAPACITY LIMITATIONS
        THE CARRIER SHALL LIMIT THE NUMBER OF PASSENGERS CARRIED
        ON ANY ONE FLIGHT AT FARES GOVERNED BY THIS RULE AND SUCH
        FARES WILL NOT NECESSARILY BE AVAILABLE ON ALL FLIGHTS.
        THE NUMBER OF SEATS WHICH THE CARRIER SHALL MAKE
        AVAILABLE ON A GIVEN FLIGHT WILL BE DETERMINED BY THE
        CARRIERS BEST JUDGMENT
        DAY/TIME
        """
    }
   
}
