//
//  ThingsToAskHeader.swift
//  AERTRIP
//
//  Created by Appinventiv on 10/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit


class ThingsToAskHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var sectionTitleImageView: UIImageView!
    @IBOutlet weak var sectionTionTitleLabel : UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.contentView.backgroundColor = AppColors.themeGray04
        sectionTionTitleLabel.font = AppFonts.SemiBold.withSize(18)
        sectionTionTitleLabel.textColor = AppColors.themeTextColor
    }
    
    func populateData(section : Int){
        if section == 0{
            sectionTionTitleLabel.text = LocalizedString.Flight.localized
            sectionTitleImageView.image = AppImages.blueflight
        }else{
            sectionTionTitleLabel.text = LocalizedString.Hotel.localized
            sectionTitleImageView.image = AppImages.hotelCopy4
        }
    }

}

