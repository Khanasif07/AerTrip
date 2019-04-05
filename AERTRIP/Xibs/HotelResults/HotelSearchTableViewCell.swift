//
//  HotelSearchTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 04/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelSearchTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var hotelNameLabel : UILabel!
    @IBOutlet weak var favouriteStatusImageView: UIImageView!
    @IBOutlet weak var hotelPriceLabel : UILabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var tripAdvisorRatingView: FloatRatingView!
    @IBOutlet weak var addressLabel : UILabel!
    @IBOutlet weak var tripRatingView: UIView!
    @IBOutlet weak var tripLogoImage: UIImageView!
    
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
        self.hotelPriceLabel.text = AppConstants.kRuppeeSymbol + "\(hotel.price.delimiter)"
        self.starRatingView.isHidden = true
        if hotel.star > 0.0 {
            self.starRatingView.isHidden = false
            self.starRatingView.rating = hotel.star
        }
        
        self.tripAdvisorRatingView.isHidden = true
        self.tripLogoImage.isHidden = true
        if hotel.rating > 0.0 {
            self.tripAdvisorRatingView.isHidden = false
            self.tripLogoImage.isHidden = false
            self.tripAdvisorRatingView.rating = hotel.rating
        }
        self.starRatingView.isHidden = hotel.star == 0
        self.starRatingView.rating = hotel.star
        self.tripAdvisorRatingView.rating = hotel.rating
//        self.tripRatingView.isHidden = hotel.rating == 0
        self.tripAdvisorRatingView.isHidden = hotel.rating == 0
        self.tripLogoImage.isHidden = hotel.rating == 0
        self.addressLabel.attributedText = getAttributeBoldTextForAddress(text: hotel.address ?? "", boldText: searchText)
    }
    

    private func getAttributeBoldTextForHotelName(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.SemiBold.withSize(18.0), .foregroundColor: UIColor.black])
        
        attString.addAttributes([
            .font: AppFonts.SemiBold.withSize(18.0),
            .foregroundColor: AppColors.themeGreen
            ], range:(text as NSString).range(of: boldText))
        return attString
    }
    
    private func getAttributeBoldTextForAddress(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), .foregroundColor: UIColor.black])
        
        attString.addAttributes([
            .font: AppFonts.Regular.withSize(14.0),
            .foregroundColor: AppColors.themeGreen
            ], range:(text as NSString).range(of: boldText))
        return attString
    }

}

