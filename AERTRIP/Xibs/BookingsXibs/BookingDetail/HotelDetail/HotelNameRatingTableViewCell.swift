//
//  HotelNameRatingTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelNameRatingTableViewCell: ATTableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var starRatingViewLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var mainStackBtmConst: NSLayoutConstraint!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var starRatingContatinerView: UIStackView!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var tripRatingView: FloatRatingView!
    @IBOutlet weak var tripAdvisorImageView: UIImageView!
    @IBOutlet weak var taImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setupFonts() {
         self.hotelNameLabel.font = AppFonts.SemiBold.withSize(22.0)
    }
    
   
    override func setupColors() {
        self.hotelNameLabel.textColor = AppColors.themeBlack
    }
    
    
    func configureCell(hoteName: String,starRating: Double,tripRating: Double) {
        self.hotelNameLabel.text = hoteName
        self.starRatingView.rating = starRating
        self.tripRatingView.rating = tripRating
        self.starRatingContatinerView.isHidden = (starRating.isZero && tripRating.isZero) ? true : false
        self.starRatingView.isHidden = starRating.isZero ? true : false
        self.tripRatingView.isHidden = tripRating.isZero ? true : false
        self.tripAdvisorImageView.isHidden = tripRating.isZero ? true : false
    }
}
