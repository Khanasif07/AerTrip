//
//  RecentHotelSearchCollectionViewCell.swift
//  AERTRIP
//
//  Created by Admin on 14/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class RecentHotelSearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            self.containerView.layer.cornerRadius = 10.0
            self.containerView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var searchTypeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var stateNameLabel: UILabel!
    @IBOutlet weak var totalNightsLabel: UILabel!
    @IBOutlet weak var totalAdultsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    private func initialSetUp() {
        ///Font
        let regularFont14 = AppFonts.Regular.withSize(14.0)
        self.searchTypeLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.timeLabel.font = AppFonts.Regular.withSize(14.0)
        self.cityNameLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.stateNameLabel.font = regularFont14
        self.totalNightsLabel.font = regularFont14
        self.totalAdultsLabel.font = regularFont14
        
        ///Colors
        let grayColor = AppColors.themeGray60
        let blackColor = AppColors.themeBlack
        let greenColor = AppColors.themeGreen
        self.searchTypeLabel.textColor = greenColor
        self.timeLabel.textColor = greenColor
        self.cityNameLabel.textColor = blackColor
        self.stateNameLabel.textColor = blackColor
        self.totalNightsLabel.textColor = grayColor
        self.totalAdultsLabel.textColor = grayColor
        
        ///Text
        
    }

    internal func configureCell() {
        
    }
    
}
