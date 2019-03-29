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
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var shadowViewBottomConstraints: NSLayoutConstraint!
    
    
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
        self.shadowView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize(width: 0.0, height: 5.0), opacity: 0.7, shadowRadius: 8.0)
//        self.shadowView.addshadowOnSelectedEdge(top: false, left: true, bottom: true, right: true, opacity: 0.7, shadowRadius: 8.0, color: AppColors.themeBlack.withAlphaComponent(0.14))
        self.containerView.addGredient(isVertical: false, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
        self.containerView.backgroundColor = AppColors.themeGreen
        self.hotelFeesLabel.textColor = AppColors.themeWhite
        self.bookLabel.textColor = AppColors.themeWhite
        self.containerView.roundBottomCorners(cornerRadius: 10.0)
        //Size
        self.hotelFeesLabel.font = AppFonts.SemiBold.withSize(20.0)
        self.bookLabel.font = AppFonts.SemiBold.withSize(20.0)
        
        //Text
        self.bookLabel.text = LocalizedString.Book.localized
    }
    
}
