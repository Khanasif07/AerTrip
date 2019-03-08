//
//  TripAdviserReviewsCell.swift
//  AERTRIP
//
//  Created by Admin on 18/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TripAdviserReviewsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var excellentLabel: UILabel!
    @IBOutlet weak var excellentRatingLabel: UILabel!
    @IBOutlet weak var veryGoodLabel: UILabel!
    @IBOutlet weak var veryGoodRatingLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    @IBOutlet weak var poorLabel: UILabel!
    @IBOutlet weak var poorRatingLabel: UILabel!
    @IBOutlet weak var terribleLabel: UILabel!
    @IBOutlet weak var terribleRatingLabel: UILabel!
    @IBOutlet weak var excellentProgressBar: PKProgressView!
    @IBOutlet weak var veryGoodProgressBar: PKProgressView!
    @IBOutlet weak var averageProgressBar: PKProgressView!
    @IBOutlet weak var poorProgressBar: PKProgressView!
    @IBOutlet weak var terribleProgressBar: PKProgressView!
    @IBOutlet weak var dividerView: ATDividerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
        self.excellentProgressBar.progressTint = AppColors.themeGreen
        self.veryGoodProgressBar.progressTint = AppColors.themeGreen
        self.averageProgressBar.progressTint = AppColors.themeGreen
        self.poorProgressBar.progressTint = AppColors.themeGreen
        self.terribleProgressBar.progressTint = AppColors.themeGreen
    }

    private func configureUI() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.excellentLabel.font = AppFonts.Regular.withSize(18.0)
        self.veryGoodLabel.font = AppFonts.Regular.withSize(18.0)
        self.averageLabel.font = AppFonts.Regular.withSize(18.0)
        self.poorLabel.font = AppFonts.Regular.withSize(18.0)
        self.terribleLabel.font = AppFonts.Regular.withSize(18.0)
        self.excellentRatingLabel.font = AppFonts.Regular.withSize(18.0)
        self.veryGoodRatingLabel.font = AppFonts.Regular.withSize(18.0)
        self.averageRatingLabel.font = AppFonts.Regular.withSize(18.0)
        self.poorRatingLabel.font = AppFonts.Regular.withSize(18.0)
        self.terribleRatingLabel.font = AppFonts.Regular.withSize(18.0)
        
        //Color
        self.titleLabel.textColor = AppColors.themeBlack
        self.excellentLabel.textColor = AppColors.themeBlack
        self.veryGoodLabel.textColor = AppColors.themeBlack
        self.averageLabel.textColor = AppColors.themeBlack
        self.poorLabel.textColor = AppColors.themeBlack
        self.terribleLabel.textColor = AppColors.themeBlack
        self.excellentRatingLabel.textColor = AppColors.themeBlack
        self.veryGoodRatingLabel.textColor = AppColors.themeBlack
        self.averageRatingLabel.textColor = AppColors.themeBlack
        self.poorRatingLabel.textColor = AppColors.themeBlack
        self.terribleRatingLabel.textColor = AppColors.themeBlack
    }
    
    internal func configCell(reviewRatingCount: JSONDictionary) {
        
        if let terribleRating = reviewRatingCount["1"] as? String, let progressValue = NumberFormatter().number(from: terribleRating) {
            self.terribleProgressBar.progress = CGFloat(truncating: progressValue)
        }
        if let poorRating = reviewRatingCount["2"] as? String, let progressValue = NumberFormatter().number(from: poorRating)  {
            self.poorProgressBar.progress = CGFloat(truncating: progressValue)
        }
        if let averageRating = reviewRatingCount["3"] as? String, let progressValue = NumberFormatter().number(from: averageRating)  {
            self.averageProgressBar.progress = CGFloat(truncating: progressValue)
        }
        if let veryGoodRating = reviewRatingCount["4"] as? String, let progressValue = NumberFormatter().number(from: veryGoodRating)  {
            self.veryGoodProgressBar.progress = CGFloat(truncating: progressValue)
        }
        if let excellentRating = reviewRatingCount["5"] as? String, let progressValue = NumberFormatter().number(from: excellentRating)  {
            self.excellentProgressBar.progress = CGFloat(truncating: progressValue)
        }
    }
}
