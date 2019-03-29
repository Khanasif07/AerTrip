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
    
    @IBOutlet var hotelCardImageView: UIImageView!
    @IBOutlet var hotelNameLabel: UILabel!
    @IBOutlet var hotelPriceLabel: UILabel!
    @IBOutlet var starRatingView: FloatRatingView!
    @IBOutlet var tripRatingView: FloatRatingView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    
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
        self.cellBackgroundView.layer.borderWidth = 0.5
        self.cellBackgroundView.clipsToBounds = true
        self.cellBackgroundView.layer.borderColor = AppColors.themeGray40.cgColor
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
        if let image = UIImage(named: "hotelCardPlaceHolder") {
            self.hotelCardImageView.setImageWithUrl(self.favHotel?.thumbnail?.first ?? "", placeholder: image, showIndicator: true)
        }
        self.hotelNameLabel.text = self.favHotel?.hotelName
        self.hotelPriceLabel.text = AppConstants.kRuppeeSymbol + "\(favHotel.price.delimiter)"
        self.starRatingView.rating = favHotel.star
        self.tripRatingView.rating = favHotel.rating
        self.addressLabel.text = favHotel.address
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
