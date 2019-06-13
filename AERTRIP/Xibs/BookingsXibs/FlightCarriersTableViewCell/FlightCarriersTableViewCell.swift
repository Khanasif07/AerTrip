//
//  FlightCarriersTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 29/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightCarriersTableViewCell: UITableViewCell {
    // MARK: - Variables
    
    // MARK: ===========
    
    // MARK: - IBOutlets
    
    // MARK: ===========
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var firstFlightCarriersContView: UIView!
    @IBOutlet var firstFlightCarriersImgVw: UIImageView!
    @IBOutlet var secondFlightCarriersContView: UIView!
    @IBOutlet var secondFlightCarriersImgVw: UIImageView!
    @IBOutlet var moreFlightCarriersContView: UIView!
    @IBOutlet var moreFlightCarriersImgVw: UIImageView!
    @IBOutlet var moreFlightCarriersLabel: UILabel!
    @IBOutlet var totalCarriersOrFlNameLabel: UILabel!
    @IBOutlet var flightCode: UILabel!
    @IBOutlet var remainingCodesLabel: UILabel!
    @IBOutlet var nextScreenImageView: UIImageView!
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    // MARK: - Functions
    
    // MARK: ===========
    
    private func configUI() {
        // Font
        self.moreFlightCarriersLabel.font = AppFonts.Regular.withSize(11.0)
        self.totalCarriersOrFlNameLabel.font = AppFonts.Regular.withSize(16.0)
        self.flightCode.font = AppFonts.Regular.withSize(16.0)
        self.remainingCodesLabel.font = AppFonts.Regular.withSize(14.0)
        
        // Color
        self.moreFlightCarriersLabel.textColor = AppColors.themeWhite
        self.totalCarriersOrFlNameLabel.textColor = AppColors.themeBlack
        self.flightCode.textColor = AppColors.themeBlack
        self.remainingCodesLabel.textColor = AppColors.themeGray40
        
        // SetUp
        self.secondFlightCarriersContView.isHidden = true
        self.moreFlightCarriersContView.isHidden = true
        
        self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
    }
    
    internal func configCell(carriers: [String], carrierCode: [String], flightNumbers: [String]) {
        self.remainingCodesLabel.text = "+\(flightNumbers.count - 1) \(LocalizedString.More.localized)"
        let firstCarrierCode = carrierCode.first ?? ""
        let firstFlightNumber = flightNumbers.first ?? ""
        self.flightCode.text = (firstCarrierCode + firstFlightNumber)
        self.remainingCodesLabel.isHidden = false
        switch carriers.count {
        case 1:
            self.secondFlightCarriersContView.isHidden = true
            if !carrierCode[0].isEmpty {
                let imageUrl = AppGlobals.shared.getAirlineCodeImageUrl(code: carrierCode[0])
                self.secondFlightCarriersImgVw.setImageWithUrl(imageUrl, placeholder: AppPlaceholderImage.default, showIndicator: true)
            }
            
            self.moreFlightCarriersContView.isHidden = true
            self.totalCarriersOrFlNameLabel.text = carriers[0]
            self.remainingCodesLabel.isHidden = true
        case 2:
            self.moreFlightCarriersContView.isHidden = true
            self.totalCarriersOrFlNameLabel.text = carriers[1]
        default:
            self.secondFlightCarriersContView.isHidden = false
            self.moreFlightCarriersContView.isHidden = false
            self.moreFlightCarriersLabel.text = "\(carriers.count - 2)"
            self.totalCarriersOrFlNameLabel.text = "\(carriers.count) \(LocalizedString.Carriers.localized)"
        }
    }
    
    // MARK: - IBActions
    
    // MARK: ===========
}

// MARK: - Extensions

// MARK: ============
