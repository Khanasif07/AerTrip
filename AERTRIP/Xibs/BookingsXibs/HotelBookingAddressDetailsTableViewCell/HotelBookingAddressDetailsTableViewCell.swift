//
//  HotelBookingAddressDetailsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 04/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelBookingAddressDetailsTableViewCell: UITableViewCell {
    
    //MARK:- Variables
    //MARK:===========
    
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var hotelRatingView: FloatRatingView!
    @IBOutlet weak var tripadviserImageView: UIImageView!
    @IBOutlet weak var hotelDotsView: FloatRatingView!
    @IBOutlet weak var deviderView: ATDividerView!
    @IBOutlet weak var hotelAddressLabel: UILabel!
    @IBOutlet weak var checkInOutContainerView: UIView!
    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var checkOutLabel: UILabel!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkInDayLabel: UILabel!
    @IBOutlet weak var checkOutDayLabel: UILabel!
    @IBOutlet weak var moonImageView: UIImageView!
    @IBOutlet weak var totalNightsLabel: UILabel!

    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setupColor()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func configureUI() {
//        self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        let shadow = AppShadowProperties()
        self.containerView.addShadow(cornerRadius: shadow.cornerRadius, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
        
        //Font
        self.hotelNameLabel.font = AppFonts.SemiBold.withSize(22)
        self.hotelAddressLabel.font = AppFonts.Regular.withSize(16)
        self.checkInLabel.font = AppFonts.Regular.withSize(14)
        self.checkOutLabel.font = AppFonts.Regular.withSize(14)
        self.checkInDateLabel.font = AppFonts.Regular.withSize(22)
        self.checkOutDateLabel.font = AppFonts.Regular.withSize(22)
        self.checkInDayLabel.font = AppFonts.Regular.withSize(14)
        self.checkOutDayLabel.font = AppFonts.Regular.withSize(14)
        self.totalNightsLabel.font = AppFonts.SemiBold.withSize(14)

        //Text
        self.checkInLabel.text = LocalizedString.CheckIn.localized
        self.checkOutLabel.text = LocalizedString.CheckOut.localized
        
        //Color
        self.hotelNameLabel.textColor = AppColors.themeBlack
        self.hotelAddressLabel.textColor = AppColors.themeGray60
        self.checkInLabel.textColor = AppColors.themeGray40
        self.checkOutLabel.textColor = AppColors.themeGray40
        self.checkInDateLabel.textColor = AppColors.themeBlack
        self.checkOutDateLabel.textColor = AppColors.themeBlack
        self.checkInDayLabel.textColor = AppColors.themeGray40
        self.checkOutDayLabel.textColor = AppColors.themeGray40
        self.totalNightsLabel.textColor = AppColors.themeBlack
        self.setupColor()
    }
    
    
    private func setupColor(){
        self.containerView.backgroundColor = AppColors.themeWhiteDashboard
        self.checkInOutContainerView.backgroundColor = AppColors.themeWhiteDashboard
    }
    
    internal func configCell(hotelName: String, hotelAddress: String, hotelStarRating: Double, tripAdvisorRating: Double, checkInDate: Date? , checkOutDate: Date? , totalNights: Int) {
        self.hotelNameLabel.text = hotelName
        self.hotelAddressLabel.text = hotelAddress
        self.hotelRatingView.rating = hotelStarRating
        self.hotelDotsView.rating = tripAdvisorRating
        self.ratingStackView.isHidden = (hotelStarRating.isZero && tripAdvisorRating .isZero) ? true : false
        self.hotelRatingView.isHidden = hotelStarRating.isZero ? true : false
        self.hotelDotsView.isHidden = tripAdvisorRating.isZero ? true : false
        self.tripadviserImageView.isHidden = tripAdvisorRating.isZero ? true : false
        
        let checkInStr = checkInDate?.toString(dateFormat: "dd MMM") ?? ""
        let checkOutStr = checkOutDate?.toString(dateFormat: "dd MMM") ?? ""
        self.checkInDateLabel.text = checkInStr.isEmpty ? LocalizedString.na.localized : checkInStr
        self.checkOutDateLabel.text = checkOutStr.isEmpty ? LocalizedString.na.localized : checkOutStr
        
        var finalNight = totalNights
        if totalNights == 0, let inDate = checkInDate, let outDate = checkOutDate {
            finalNight = outDate.daysFrom(inDate)
        }
        self.totalNightsLabel.text = (finalNight == 1) ? "\(finalNight) \(LocalizedString.Night.localized)" : "\(finalNight) \(LocalizedString.Nights.localized)"

        
        self.checkInDayLabel.text = checkInDate?.toString(dateFormat: "EEEE") ?? LocalizedString.na.localized
        self.checkOutDayLabel.text = checkOutDate?.toString(dateFormat: "EEEE") ?? LocalizedString.na.localized
    }
}

//MARK:- Extensions
//MARK:============
