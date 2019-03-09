//
//  HotelDetailsAdvisorRatingSummaryTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsAdvisorRatingSummaryTableViewCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var sleepQualityLabel: UILabel!
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var cleanlinessLabel: UILabel!
    @IBOutlet weak var locationRatingView: FloatRatingView!
    @IBOutlet weak var sleepQualityRatingView: FloatRatingView!
    @IBOutlet weak var roomsRatingView: FloatRatingView!
    @IBOutlet weak var serviceRatingView: FloatRatingView!
    @IBOutlet weak var valueLRatingView: FloatRatingView!
    @IBOutlet weak var cleanlinessRatingView: FloatRatingView!
    @IBOutlet weak var dividerView: ATDividerView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    private func configureUI() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.locationLabel.font = AppFonts.Regular.withSize(18.0)
        self.sleepQualityLabel.font = AppFonts.Regular.withSize(18.0)
        self.roomsLabel.font = AppFonts.Regular.withSize(18.0)
        self.serviceLabel.font = AppFonts.Regular.withSize(18.0)
        self.valueLabel.font = AppFonts.Regular.withSize(18.0)
        self.cleanlinessLabel.font = AppFonts.Regular.withSize(18.0)
        
        //Color
        self.titleLabel.textColor = AppColors.themeBlack
        self.locationLabel.textColor = AppColors.themeBlack
        self.sleepQualityLabel.textColor = AppColors.themeBlack
        self.roomsLabel.textColor = AppColors.themeBlack
        self.serviceLabel.textColor = AppColors.themeBlack
        self.valueLabel.textColor = AppColors.themeBlack
        self.cleanlinessLabel.textColor = AppColors.themeBlack
    }
    
    internal func configCell(ratingSummary: [RatingSummary]) {
        self.locationLabel.text = ratingSummary[0].localizedName
        self.locationRatingView.rating = Double(ratingSummary[0].value) ?? 0.0
        
        self.sleepQualityLabel.text = ratingSummary[1].localizedName
        self.sleepQualityRatingView.rating = Double(ratingSummary[1].value) ?? 0.0

        self.roomsLabel.text = ratingSummary[2].localizedName
        self.roomsRatingView.rating = Double(ratingSummary[2].value) ?? 0.0

        self.serviceLabel.text = ratingSummary[3].localizedName
        self.serviceRatingView.rating = Double(ratingSummary[3].value) ?? 0.0

        self.valueLabel.text = ratingSummary[4].localizedName
        self.valueLRatingView.rating = Double(ratingSummary[4].value) ?? 0.0

        self.cleanlinessLabel.text = ratingSummary[5].localizedName
        self.cleanlinessRatingView.rating = Double(ratingSummary[5].value) ?? 0.0
    }

}
