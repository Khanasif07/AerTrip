//
//  HotelDetailsBedsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 13/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsBedsTableViewCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var bedTypeLabel: UILabel!
    @IBOutlet weak var bedDiscriptionLabel: UILabel!
    @IBOutlet weak var bookmarkButtonOutlet: UIButton!
    @IBOutlet weak var bedsLabel: UILabel!
    @IBOutlet weak var deviderView: ATDividerView!
    @IBOutlet weak var bedSelectionDropDown: UIButton!
    
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
        self.containerView.roundCornersByClipsToBounds(cornerRadius: 10.0)
        self.containerView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.bedTypeLabel.textColor = AppColors.themeBlack
        self.bedDiscriptionLabel.textColor = AppColors.themeBlack
        self.bedsLabel.textColor = AppColors.themeBlack
        self.bedSelectionDropDown.setTitleColor(AppColors.themeGreen, for: .normal)

       //Size
        self.bedTypeLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.bedDiscriptionLabel.font = AppFonts.Regular.withSize(14.0)
        self.bedsLabel.font = AppFonts.Regular.withSize(16.0)
        self.bedSelectionDropDown.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        

//        //Text
//        self.hotelNameLabel.text = "Grand Hyatt Mumbai"
//        self.distanceLabel.text = "0.1 km •🚶🏻 4 min"
    }
    
    private func bedSelectionTitleImgSetUp() {
        self.bedSelectionDropDown.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.bedSelectionDropDown.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.bedSelectionDropDown.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    //Mark:- IBActions
    //================
    @IBAction func bookmarkButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func bedsDropDownButtonAction(_ sender: UIButton) {
    }
}
