//
//  TripAdvisorTravelerRatingTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TripAdvisorTravelerRatingTableViewCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
//    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tripAdviserImageView: UIImageView!
    @IBOutlet weak var tripAdviserRatingView: FloatRatingView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var hotelNumberLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var reviewsButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    private func configureUI() {
//        self.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.reviewsLabel.font = AppFonts.Regular.withSize(16.0)
        self.hotelNumberLabel.font = AppFonts.Regular.withSize(18.0)
        //Color
//        self.titleLabel.textColor = AppColors.themeBlack
        self.reviewsLabel.textColor = AppColors.reviewGreen
        self.hotelNumberLabel.textColor = AppColors.themeBlack
    }
    
    internal func configCell(reviewsLabel: String , tripAdvisorRating: Double , ranking: String) {
        self.reviewsLabel.text = reviewsLabel
        self.tripAdviserRatingView.rating = tripAdvisorRating
        self.hotelNumberLabel.text = ranking
    }
}
