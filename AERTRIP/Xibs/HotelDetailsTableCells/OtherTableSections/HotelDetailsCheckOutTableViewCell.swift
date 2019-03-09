//
//  HotelDetailsCheckOutTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 28/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsCheckOutTableViewCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var hotelFeesLabel: UILabel!
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            //self.shadowView.shadowOnHotelDetailsTabelCell(color: AppColors.themeGray20, offset: CGSize(width: 0.0, height: 3.0), opacity: 0.7, shadowRadius: 4.0)
            
        }
    }

    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }

    //Mark:- PrivateFunctions
    //=======================
    
    ///ConfigureUI
    private func configureUI() {
        //Colors
        self.backgroundColor = AppColors.screensBackground.color
//        self.containerView.shadowOnHotelDetailsTabelCell(color: AppColors.themeGray20, offset: CGSize(width: 0.0, height: 5.0), opacity: 0.7, shadowRadius: 6.0)
        self.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
        let whiteColor = AppColors.themeWhite
        self.containerView.backgroundColor = AppColors.themeGreen
        self.hotelFeesLabel.textColor = whiteColor
        self.bookLabel.textColor = whiteColor
        self.containerView.roundBottomCorners(cornerRadius: 10.0)
        //Size
        let semiboldFontSize20 = AppFonts.SemiBold.withSize(20.0)
        self.hotelFeesLabel.font = semiboldFontSize20
        self.bookLabel.font = semiboldFontSize20
        
        //Text
        self.bookLabel.text = LocalizedString.Book.localized
    }
    
}
