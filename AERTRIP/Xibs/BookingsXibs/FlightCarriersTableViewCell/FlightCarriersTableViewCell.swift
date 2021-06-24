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
    @IBOutlet weak var containerTopConstraints: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        self.setupColors()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setupColors()
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
        self.remainingCodesLabel.textColor = AppColors.themeGray153
        
        // SetUp
        self.secondFlightCarriersContView.isHidden = true
        self.moreFlightCarriersContView.isHidden = true
        
        [firstFlightCarriersImgVw, secondFlightCarriersImgVw, moreFlightCarriersImgVw].forEach{ imgView in
            imgView?.roundedCorners(cornerRadius: 3.0)
        }
        
        
        //self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
//        self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        let shadow = AppShadowProperties(self.isLightTheme())
        self.containerView.addShadow(cornerRadius: shadow.cornerRadius, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
    }
    
    internal func configCell(carriers: [String], carrierCode: [String], flightNumbers: [String]) {
        self.remainingCodesLabel.text = "+\(flightNumbers.count - 1) \(LocalizedString.More.localized)"
        let firstCarrierCode = carrierCode.first ?? ""
        let firstFlightNumber = flightNumbers.first ?? ""
        self.flightCode.text = (firstCarrierCode + " " + firstFlightNumber)
        self.remainingCodesLabel.isHidden = false
        self.setupImageWith(carrierCode: carrierCode, carriers: carriers)
        
    }
    
    
    func setupColors(){
        [containerView, firstFlightCarriersContView, secondFlightCarriersContView, moreFlightCarriersContView].forEach { view in
            view?.backgroundColor = AppColors.themeWhiteDashboard
        }
        self.contentView.backgroundColor = AppColors.themeBlack26
    }
    
    func setupImageWith(carrierCode:[String], carriers:[String]){
        
        // logic for carrier image and name label :
        /*
         if one carrier show carrier image and name
         if two carrier then show only two carrier image
         if three carrier then show only three carrier image
         else more than 3 carrier then show two carrier and third carrier(blurred) and count above it
         
         */
        let uniqueCarrierCode = carrierCode.removeDuplicates()
        let uniqueCarriers = carriers.removeDuplicates()
        switch carriers.count {
        case 1:
            if uniqueCarrierCode.indices.contains(0),!uniqueCarrierCode[0].isEmpty {
                let imageUrl = AppGlobals.shared.getAirlineCodeImageUrl(code: uniqueCarrierCode[0])
                self.firstFlightCarriersImgVw.setImageWithUrl(imageUrl, placeholder: AppPlaceholderImage.default, showIndicator: true)
            } else {
                self.firstFlightCarriersContView.isHidden = true
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
            if uniqueCarrierCode.indices.contains(0),!uniqueCarrierCode[0].isEmpty {
            self.firstFlightCarriersImgVw.setImageWithUrl(AppGlobals.shared.getAirlineCodeImageUrl(code: uniqueCarrierCode[0]), placeholder: AppPlaceholderImage.default, showIndicator: true)
            }else {
                self.firstFlightCarriersContView.isHidden = true
            }
            if uniqueCarrierCode.indices.contains(1),!uniqueCarrierCode[1].isEmpty {
                self.secondFlightCarriersImgVw.setImageWithUrl(AppGlobals.shared.getAirlineCodeImageUrl(code: uniqueCarrierCode[1]), placeholder: AppPlaceholderImage.default, showIndicator: true)
            }else {
                self.secondFlightCarriersContView.isHidden = true
            }
            
        case 3:
            self.secondFlightCarriersContView.isHidden = false
            self.moreFlightCarriersLabel.isHidden = true
            self.moreFlightCarriersContView.isHidden = false
            self.moreFlightBlurOverlayView.isHidden = true
            self.totalCarriersOrFlNameLabel.isHidden = true
            if uniqueCarrierCode.indices.contains(0),!uniqueCarrierCode[0].isEmpty {
            self.firstFlightCarriersImgVw.setImageWithUrl(AppGlobals.shared.getAirlineCodeImageUrl(code: uniqueCarrierCode[0]), placeholder: AppPlaceholderImage.default, showIndicator: true)
            }else {
                self.firstFlightCarriersContView.isHidden = true
            }
            if uniqueCarrierCode.indices.contains(1),!uniqueCarrierCode[1].isEmpty {
            self.secondFlightCarriersImgVw.setImageWithUrl(AppGlobals.shared.getAirlineCodeImageUrl(code: uniqueCarrierCode[1]), placeholder: AppPlaceholderImage.default, showIndicator: true)
            }else {
                self.secondFlightCarriersContView.isHidden = true
            }
            if uniqueCarrierCode.indices.contains(2),!uniqueCarrierCode[2].isEmpty {
            self.moreFlightCarriersImgVw.setImageWithUrl(AppGlobals.shared.getAirlineCodeImageUrl(code: uniqueCarrierCode[2]), placeholder: AppPlaceholderImage.default, showIndicator: true)
            }else {
                self.moreFlightCarriersLabel.isHidden = true
                self.moreFlightCarriersContView.isHidden = true
            }
            
        default:
            self.secondFlightCarriersContView.isHidden = false
            self.moreFlightCarriersContView.isHidden = false
            if uniqueCarrierCode.indices.contains(2),!uniqueCarrierCode[2].isEmpty {
            self.moreFlightCarriersImgVw.setImageWithUrl(AppGlobals.shared.getAirlineCodeImageUrl(code: uniqueCarrierCode[2]), placeholder: AppPlaceholderImage.default, showIndicator: true)
            }else {
                self.moreFlightCarriersContView.isHidden = true
            }
            self.moreFlightCarriersLabel.text = "+ \(carriers.count - 3)"
            self.totalCarriersOrFlNameLabel.text = "\(carriers.count) \(LocalizedString.Carriers.localized)"
        }
        
        if uniqueCarriers.count == 1 {
           self.totalCarriersOrFlNameLabel.text = carriers[0]
            self.totalCarriersOrFlNameLabel.isHidden = false
        }
        
    }
    
    
    func configureCellWith(_ leg: IntLeg, airLineDetail:[String:String]){
        let firstCarrierCode = leg.al.first ?? ""
        let firstFlightNumber = leg.flightsWithDetails.first?.fn ?? ""
        self.flightCode.text = (firstCarrierCode + " " + firstFlightNumber)
        self.remainingCodesLabel.isHidden = false
        let codes = leg.flightsWithDetails.map{$0.al}
        var carriers = [String]()
        for code in codes{
            carriers.append(airLineDetail[code] ?? "")
        }
        self.remainingCodesLabel.text = "+\(codes.count - 1) \(LocalizedString.More.localized)"
        self.setupImageWith(carrierCode: codes, carriers: carriers)
        
    }
    
    // MARK: - IBActions
    
    // MARK: ===========
}

// MARK: - Extensions

// MARK: ============
