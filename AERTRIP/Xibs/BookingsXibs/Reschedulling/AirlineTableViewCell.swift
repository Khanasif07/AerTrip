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
    
   
    var flightDetail: FlightDetail? {
        didSet {
            self.configureCell()
        }
    }
    
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
    
    private func configureCell() {
        
        var infoText = LocalizedString.dash.localized
        if let obj = flightDetail?.carrierCode, !obj.isEmpty {
            infoText = obj
        }
        
        if let obj = flightDetail?.flightNumber, !obj.isEmpty {
            infoText += infoText.isEmpty ? obj : " - \(obj)"
        }
        
        if let obj = flightDetail?.cabinClass, !obj.isEmpty {
            infoText += infoText.isEmpty ? obj : " ・ \(obj)"
        }
        
        if let obj = flightDetail?.bookingClass, !obj.isEmpty {
            infoText += infoText.isEmpty ? obj : " (\(obj))"
        }
        
        self.airlineNameLabel.text = flightDetail?.carrier ?? LocalizedString.dash.localized
        self.infoLabel.text = infoText
        
        self.airlineImageView.setImageWithUrl(AppGlobals.shared.getAirlineCodeImageUrl(code: flightDetail?.carrierCode ?? ""), placeholder: AppPlaceholderImage.default, showIndicator: false)
    }
}
