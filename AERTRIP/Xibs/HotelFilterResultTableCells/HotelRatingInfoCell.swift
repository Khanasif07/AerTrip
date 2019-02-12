//
//  HotelRatingInfoCell.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelRatingInfoCell: UITableViewCell {

    //Mark:- Variables
    //================
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var hotelRatingView: FloatRatingView!
    @IBOutlet weak var tripadviserImageView: UIImageView!
    @IBOutlet weak var hotelDotsView: FloatRatingView!
    @IBOutlet weak var shareButtonOutlet: UIButton!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var deviderView: UIView!
    
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
        self.hotelNameLabel.textColor = AppColors.themeBlack
        self.distanceLabel.textColor = AppColors.themeGray60
        
        //Size
        self.hotelNameLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.distanceLabel.font = AppFonts.Regular.withSize(16.0)
        
        //Text
        self.hotelNameLabel.text = "Grand Hyatt Mumbai"
        self.distanceLabel.text = "0.1 km •🚶🏻 4 min"
    }
    
    //Mark:- IBActions
    //================
    @IBAction func shareButtonAction(_ sender: UIButton) {
    }
}
