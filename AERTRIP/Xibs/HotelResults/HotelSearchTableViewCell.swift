//
//  HotelSearchTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 04/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelSearchTableViewCell: AppStoreAnimationTableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var topConstraintDividerView: NSLayoutConstraint!
    @IBOutlet weak var topDividerView: ATDividerView!
    @IBOutlet weak var hotelNameLabel : UILabel!
    @IBOutlet weak var favouriteStatusImageView: UIImageView!
    @IBOutlet weak var hotelPriceLabel : UILabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var tripAdvisorRatingView: FloatRatingView!
    @IBOutlet weak var addressLabel : UILabel!
    @IBOutlet weak var tripLogoImage: UIImageView!
    @IBOutlet weak var starContainerView: UIStackView!
    @IBOutlet weak var taImageLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    var searchText = ""
    
    var hotelData: HotelSearched?  {
        didSet {
            configureCell()
        }
    }
    
    // MARK: - View Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        //-------------------------- Golu Change ---------------------
           self.disabledHighlightedAnimation = false
           //-------------------------- End ---------------------
        self.setUpFonts()
        self.setUpColor()
        
    }
    
    // MARK: - Helper methods
    
    private func setUpFonts() {
        self.hotelNameLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.hotelPriceLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.addressLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    private func setUpColor() {
        self.hotelPriceLabel.textColor = AppColors.themeBlack
        self.hotelPriceLabel.textColor = AppColors.themeBlack
        self.addressLabel.textColor = AppColors.themeGray60
    }
    
    private func configureCell() {
        guard let hotel = self.hotelData else {
            printDebug("hotel not found ")
            return
        }
        self.favouriteStatusImageView.isHidden = hotel.fav == "0"
        self.hotelNameLabel.attributedText = getAttributeBoldTextForHotelName(text: hotel.hotelName ?? "", boldText: searchText)
        self.hotelPriceLabel.attributedText = hotel.price.getConvertedAmount(using: AppFonts.SemiBold.withSize(18.0))
        self.starRatingView.isHidden = true
        self.starContainerView.isHidden = true
        if hotel.star > 0.0 {
            self.starContainerView.isHidden = false
            self.starRatingView.isHidden = false
            self.starRatingView.rating = hotel.star
        } else {
            self.starRatingView.isHidden = true
        }
        
        self.tripAdvisorRatingView.isHidden = true
        self.tripLogoImage.isHidden = true
        if hotel.rating > 0.0 {
            self.taImageLeadingConstraint.constant = (hotel.star > 0.0) ? 0.0 : -10.0
            self.starContainerView.isHidden = false
            self.tripAdvisorRatingView.isHidden = false
            self.tripLogoImage.isHidden = false
            self.tripAdvisorRatingView.rating = hotel.rating
        } else {
            self.tripAdvisorRatingView.isHidden = true
            self.tripLogoImage.isHidden = true
        }
        self.starRatingView.isHidden = hotel.star == 0
        self.starRatingView.rating = hotel.star
        self.tripAdvisorRatingView.rating = hotel.rating
        self.tripAdvisorRatingView.isHidden = hotel.rating == 0
        self.tripLogoImage.isHidden = hotel.rating == 0
        self.addressLabel.attributedText = getAttributeBoldTextForAddress(text: hotel.address ?? "", boldText: searchText)
    }
    

    private func getAttributeBoldTextForHotelName(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.SemiBold.withSize(18.0), .foregroundColor: AppColors.themeBlack])
        
        attString.addAttributes([
            .font: AppFonts.SemiBold.withSize(18.0),
            .foregroundColor: AppColors.themeGreen
            ], range:(text.lowercased() as NSString).range(of: boldText.lowercased()))
        return attString
    }
    
    private func getAttributeBoldTextForAddress(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), .foregroundColor: AppColors.themeGray60])
        
        attString.addAttributes([
            .font: AppFonts.Regular.withSize(14.0),
            .foregroundColor: AppColors.themeGreen
            ], range:(text as NSString).range(of: boldText))
        return attString
    }

}


