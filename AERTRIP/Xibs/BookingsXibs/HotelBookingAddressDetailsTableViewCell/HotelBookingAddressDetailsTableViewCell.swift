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
    
    //MARK:- Functions
    //MARK:===========
    private func configureUI() {
        self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        //Font
        self.hotelNameLabel.font = AppFonts.Regular.withSize(26.1)
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
    }
    
    internal func configCell(hotelName: String, hotelAddress: String, hotelStarRating: Double, tripAdvisorRating: Double, checkInDate: String , checkOutDate: String , totalNights: Int) {
        self.hotelNameLabel.text = hotelName
        self.hotelAddressLabel.text = hotelAddress
        self.hotelRatingView.rating = hotelStarRating
        self.hotelDotsView.rating = tripAdvisorRating
        self.ratingStackView.isHidden = (hotelStarRating.isZero && tripAdvisorRating .isZero) ? true : false
        self.hotelRatingView.isHidden = hotelStarRating.isZero ? true : false
        self.hotelDotsView.isHidden = tripAdvisorRating .isZero ? true : false
        self.checkInDateLabel.text = Date.getDateFromString(stringDate: checkInDate , currentFormat: "yyyy-MM-dd", requiredFormat: "dd MMM")
        self.checkOutDateLabel.text = Date.getDateFromString(stringDate: checkOutDate , currentFormat: "yyyy-MM-dd", requiredFormat: "dd MMM")
        if totalNights == 0 {
            var numberOfNights = 0
            if !checkOutDate.isEmpty && !checkInDate.isEmpty{
                numberOfNights = checkOutDate.toDate(dateFormat: "yyyy-MM-dd")!.daysFrom(checkInDate.toDate(dateFormat: "yyyy-MM-dd")!)
            }
            self.totalNightsLabel.text = (numberOfNights == 1) ? "\(numberOfNights) \(LocalizedString.Night.localized)" : "\(numberOfNights) \(LocalizedString.Nights.localized)"
        } else {
            self.totalNightsLabel.text = (totalNights == 1) ? "\(totalNights) \(LocalizedString.Night.localized)" : "\(totalNights) \(LocalizedString.Nights.localized)"
        }
        self.checkInDayLabel.text = Date.getDateFromString(stringDate: checkInDate, currentFormat: "yyyy-MM-dd", requiredFormat: "EEEE")
        self.checkOutDayLabel.text = Date.getDateFromString(stringDate: checkOutDate, currentFormat: "yyyy-MM-dd", requiredFormat: "EEEE")
    }
}

//MARK:- Extensions
//MARK:============
