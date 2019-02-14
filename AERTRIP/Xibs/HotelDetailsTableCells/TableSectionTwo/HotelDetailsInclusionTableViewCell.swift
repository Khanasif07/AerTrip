//
//  HotelDetailsInclusionTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 13/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsInclusionTableViewCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var inclusionLabel: UILabel!
    @IBOutlet weak var inclusionTypeLabel: UILabel!

    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //Mark:- Methods
    //==============
    private func configureUI() {
        //Color
        self.backgroundColor = AppColors.screensBackground.color
        self.containerView.layoutMargins = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
//        self.hotelNameLabel.textColor = AppColors.themeBlack
//        self.distanceLabel.textColor = AppColors.themeGray60
//        self.deviderView.backgroundColor = AppColors.divider.color
//
//        //Size
//        self.hotelNameLabel.font = AppFonts.SemiBold.withSize(22.0)
//        self.distanceLabel.font = AppFonts.Regular.withSize(16.0)
//
//        //Text
//        self.hotelNameLabel.text = "Grand Hyatt Mumbai"
//        self.distanceLabel.text = "0.1 km •🚶🏻 4 min"
    }

}
