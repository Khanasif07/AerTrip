//
//  HotelMailComposerCardViewTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelMailComposerCardViewTableViewCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet weak var hotelCardImageView: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelPriceLabel: UILabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var tripRatingView: FloatRatingView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tripAdvisorImageView: UIImageView!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var starContainerView: UIStackView!
    @IBOutlet weak var backgroundBorderView: UIView!
    
    @IBOutlet weak var taImageLeadingConstraint: NSLayoutConstraint!
    var favHotel: HotelSearched? {
        didSet {
            self.configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doIntitialSetup()
        self.setUpColors()
    }
    
    // MARK: - Helper methods
    
    private func doIntitialSetup() {
        self.hotelNameLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.hotelPriceLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.addressLabel.font = AppFonts.Regular.withSize(18.0)
        self.cellBackgroundView.layer.cornerRadius = 5.0
        self.cellBackgroundView.clipsToBounds = true
        self.backgroundBorderView.layer.borderWidth = 0.5
        self.backgroundBorderView.layer.borderColor = AppColors.themeGray40.cgColor
        backgroundBorderView.roundBottomCorners(cornerRadius: 5)
        hotelCardImageView.contentMode = .scaleAspectFill
    }
    
    private func setUpColors() {
        self.hotelNameLabel.textColor = AppColors.themeBlack
        self.hotelPriceLabel.textColor = AppColors.themeBlack
        self.addressLabel.textColor = AppColors.themeBlack
    }
    
    private func configureCell() {
        guard let favHotel = self.favHotel else {
            printDebug("hotel not found ")
            return 
        }
        let image = AppImages.hotelCardPlaceHolder
        self.hotelCardImageView.setImageWithUrl(self.favHotel?.thumbnail?.first ?? "", placeholder: image, showIndicator: true)
        
        self.hotelNameLabel.text = self.favHotel?.hotelName
        self.hotelPriceLabel.text = favHotel.price.amountInDelimeterWithSymbol
        self.starRatingView.rating = favHotel.star
        self.tripRatingView.rating = favHotel.rating
        
        
       
        self.starRatingView.isHidden = true
        self.starContainerView.isHidden = true
        if favHotel.star > 0.0 {
            self.starContainerView.isHidden = false
            self.starRatingView.isHidden = false
            self.starRatingView.rating = favHotel.star
        } else {
            self.starRatingView.isHidden = true
        }
        
        self.tripRatingView.isHidden = true
        self.tripAdvisorImageView.isHidden = true
        if favHotel.rating > 0.0 {
            self.taImageLeadingConstraint.constant = (favHotel.star > 0.0) ? 0.0 : -10.0
            self.starContainerView.isHidden = false
            self.tripRatingView.isHidden = false
            self.tripAdvisorImageView.isHidden = false
            self.tripRatingView.rating = favHotel.rating
        } else {
            self.tripRatingView.isHidden = true
            self.tripAdvisorImageView.isHidden = true
        }
        self.starRatingView.isHidden = favHotel.star == 0
        self.starRatingView.rating = favHotel.star
        self.tripRatingView.rating = favHotel.rating
        self.tripRatingView.isHidden = favHotel.rating == 0
        self.tripAdvisorImageView.isHidden = favHotel.rating == 0
         self.addressLabel.text = favHotel.address
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
