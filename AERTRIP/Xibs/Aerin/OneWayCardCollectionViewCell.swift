//
//  OneWayCardCollectionViewCell.swift
//  AERTRIP
//
//  Created by apple on 06/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class OneWayCardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var flightImageView: UIImageView!
    @IBOutlet weak var flightNameLabel: UILabel!
    @IBOutlet weak var flightDepartureLabel: UILabel!
    @IBOutlet weak var travelTimeLabel: UILabel!
    @IBOutlet weak var flightArrivalLabel: UILabel!
    @IBOutlet weak var fromAirportCodeLabel: UILabel!
    @IBOutlet weak var toAirportCodeLabel: UILabel!
    @IBOutlet weak var ticketFareLabel: UILabel!
    @IBOutlet weak var leftSevicesStackView: UIStackView!
    @IBOutlet weak var rightServicesStackView: UIStackView!
    @IBOutlet weak var facility1: UIImageView!
    @IBOutlet weak var facility2: UIImageView!
    @IBOutlet weak var facility3: UIImageView!
    @IBOutlet weak var facility4: UIImageView!
    @IBOutlet weak var facility5: UIImageView!
    @IBOutlet weak var facility6:UIImageView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }
    
    private func setUpText() {
//        self.flightImageView.image = #imageLiteral(resourceName:ic_acc_cashback)
        self.fromAirportCodeLabel.text = "CCU"
        self.toAirportCodeLabel.text = "BOM"
        self.travelTimeLabel.text = "24h 20m"
        self.ticketFareLabel.text = "Sh.sl. 100,000"
        
        
        
    }
    
    private func setUpFont() {
        self.flightNameLabel.font = AppFonts.Regular.withSize(12.0)
        self.flightDepartureLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.travelTimeLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.fromAirportCodeLabel.font = AppFonts.Regular.withSize(16.0)
        self.toAirportCodeLabel.font = AppFonts.Regular.withSize(16.0)
        
        
        
        
    }
    
    private func setUpColor() {
        self.flightNameLabel.textColor = AppColors.themeBlack
        self.flightDepartureLabel.textColor = AppColors.themeBlack
        self.flightArrivalLabel.textColor = AppColors.themeBlack
        self.fromAirportCodeLabel.textColor = AppColors.themeBlack
        self.toAirportCodeLabel.textColor = AppColors.themeBlack
        
    }

}
