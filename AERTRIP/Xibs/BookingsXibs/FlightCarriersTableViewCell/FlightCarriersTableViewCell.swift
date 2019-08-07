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
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var firstFlightCarriersContView: UIView!
    @IBOutlet weak var firstFlightCarriersImgVw: UIImageView!
    @IBOutlet weak var secondFlightCarriersContView: UIView!
    @IBOutlet weak var secondFlightCarriersImgVw: UIImageView!
    @IBOutlet weak var moreFlightCarriersContView: UIView!
    @IBOutlet weak var moreFlightCarriersImgVw: UIImageView!
    @IBOutlet weak var moreFlightCarriersLabel: UILabel!
    
    @IBOutlet weak var moreFlightBlurOverlayView: UIView!
    @IBOutlet weak var totalCarriersOrFlNameLabel: UILabel!
    @IBOutlet weak var flightCode: UILabel!
    @IBOutlet weak var remainingCodesLabel: UILabel!
    @IBOutlet weak var nextScreenImageView: UIImageView!
    
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
        
        // logic for carrier image and name label :
        /*
         if one carrier show carrier image and name
         if two carrier then show only two carrier image
         if three carrier then show only three carrier image
         else more than 3 carrier then show two carrier and third carrier(blurred) and count above it
         
         */
        switch carriers.count {
        case 1:
            if !carrierCode[0].isEmpty {
                let imageUrl = AppGlobals.shared.getAirlineCodeImageUrl(code: carrierCode[0])
                self.firstFlightCarriersImgVw.setImageWithUrl(imageUrl, placeholder: AppPlaceholderImage.default, showIndicator: true)
            }
            self.secondFlightCarriersContView.isHidden = true
            self.moreFlightCarriersContView.isHidden = true
            self.totalCarriersOrFlNameLabel.text = carriers[0]
            self.remainingCodesLabel.isHidden = true
        case 2:
            self.secondFlightCarriersContView.isHidden = false
            self.moreFlightCarriersLabel.isHidden = true
            self.moreFlightCarriersContView.isHidden = true
            self.totalCarriersOrFlNameLabel.isHidden = true
            self.firstFlightCarriersImgVw.setImageWithUrl(AppGlobals.shared.getAirlineCodeImageUrl(code: carrierCode[0]), placeholder: AppPlaceholderImage.default, showIndicator: true)
            self.secondFlightCarriersImgVw.setImageWithUrl(AppGlobals.shared.getAirlineCodeImageUrl(code: carrierCode[1]), placeholder: AppPlaceholderImage.default, showIndicator: true)
            
        case 3:
            self.secondFlightCarriersContView.isHidden = false
            self.moreFlightCarriersLabel.isHidden = true
            self.moreFlightCarriersContView.isHidden = false
            self.moreFlightBlurOverlayView.isHidden = true
            self.totalCarriersOrFlNameLabel.isHidden = true
            self.firstFlightCarriersImgVw.setImageWithUrl(AppGlobals.shared.getAirlineCodeImageUrl(code: carrierCode[0]), placeholder: AppPlaceholderImage.default, showIndicator: true)
            self.secondFlightCarriersImgVw.setImageWithUrl(AppGlobals.shared.getAirlineCodeImageUrl(code: carrierCode[1]), placeholder: AppPlaceholderImage.default, showIndicator: true)
            self.moreFlightCarriersImgVw.setImageWithUrl(AppGlobals.shared.getAirlineCodeImageUrl(code: carrierCode[2]), placeholder: AppPlaceholderImage.default, showIndicator: true)
            
        default:
            self.secondFlightCarriersContView.isHidden = false
            self.moreFlightCarriersImgVw.setImageWithUrl(AppGlobals.shared.getAirlineCodeImageUrl(code: carrierCode[2]), placeholder: AppPlaceholderImage.default, showIndicator: true)
            self.moreFlightCarriersContView.isHidden = false
            self.moreFlightCarriersLabel.text = "+ \(carriers.count - 3)"
            self.totalCarriersOrFlNameLabel.text = "\(carriers.count) \(LocalizedString.Carriers.localized)"
        }
    }
    
    // MARK: - IBActions
    
    // MARK: ===========
}

// MARK: - Extensions

// MARK: ============
