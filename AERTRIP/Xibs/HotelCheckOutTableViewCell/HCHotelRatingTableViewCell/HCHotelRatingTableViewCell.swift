//
//  HCHotelRatingTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCHotelRatingTableViewCell: UITableViewCell {

    //Mark:- Variables
    //================
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var hotelRatingView: FloatRatingView!
    @IBOutlet weak var tripadviserImageView: UIImageView!
    @IBOutlet weak var hotelAdviserDotsView: FloatRatingView!
    @IBOutlet weak var deviderView: ATDividerView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Methods
    //==============
    private func configUI() {
        //Color
        self.hotelNameLabel.textColor = AppColors.themeBlack
        
        //Size
        self.hotelNameLabel.font = AppFonts.SemiBold.withSize(22.0)
    }
    
    internal func configCell() {
        self.hotelNameLabel.text = "Grand Hyatt Mumbai"
        self.hotelRatingView.rating = 3.5
        self.hotelAdviserDotsView.rating = 3.5
    }
}
