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
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var deviderView: ATDividerView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.roundTopCorners(cornerRadius: 10)
    }
    
    //Mark:- Methods
    //==============
    private func configUI() {
        //Color
        self.hotelNameLabel.textColor = AppColors.themeBlack
        //Size
        self.hotelNameLabel.font = AppFonts.Regular.withSize(26.0)
        self.tripadviserImageView.isHidden = true
        self.hotelAdviserDotsView.isHidden = true
        self.shadowView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.15), offset: CGSize.zero, opacity: 1, shadowRadius: 8.0)
        self.deviderView.isHidden = true
    }
    
    internal func configCell(hotelName: String ,hotelRating: Double , tripAdvisorRating: Double) {
        self.hotelNameLabel.text = hotelName
        self.hotelRatingView.rating = hotelRating
        self.hotelAdviserDotsView.rating = tripAdvisorRating
        self.tripadviserImageView.isHidden = tripAdvisorRating.isZero
        self.hotelAdviserDotsView.isHidden = tripAdvisorRating.isZero
    }
}
