//
//  FlightInfoTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 10/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightInfoTableViewCell: UITableViewCell {
    // MARK: - IB Outlet
    
    @IBOutlet var flightImageView: UIImageView!
    @IBOutlet var flightNameLabel: UILabel!
    @IBOutlet var flightDetailsLabel: UILabel!
    
    var flightDetail: FlightDetail? {
        didSet {
            self.configureCell()
        }
    }
    
    // MARK: - View life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpTextColor()
    }
    
    // MARK: - Helper methods
    
    private func setUpFont() {
        self.flightNameLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.flightDetailsLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    private func setUpTextColor() {
        self.flightNameLabel.textColor = AppColors.themeBlack
        self.flightDetailsLabel.textColor = AppColors.themeGray40
    }
    
    private func configureCell() {
        self.flightNameLabel.text = self.flightDetail?.carrier ?? ""
        
        var finalDetails = ""
        if let obj = self.flightDetail?.operatedBy, !obj.isEmpty {
            finalDetails = obj
        }
        
        let detail = "\(self.flightDetail?.carrierCode ?? LocalizedString.na.localized)-\(self.flightDetail?.flightNumber ?? LocalizedString.na.localized)・\(self.flightDetail?.cabinClass ?? LocalizedString.na.localized)"
        
        finalDetails += finalDetails.isEmpty ? detail : "\n\(detail)"
        
        self.flightDetailsLabel.text = finalDetails
        
        if let code = self.flightDetail?.carrierCode, !code.isEmpty {
            let imageUrl = AppGlobals.shared.getAirlineCodeImageUrl(code: code)
            self.flightImageView.setImageWithUrl(imageUrl, placeholder: AppPlaceholderImage.default, showIndicator: true)
        }
    }
}
