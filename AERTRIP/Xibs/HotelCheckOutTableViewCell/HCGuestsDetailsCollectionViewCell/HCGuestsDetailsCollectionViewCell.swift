//
//  HCGuestsDetailsCollectionViewCell.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCGuestsDetailsCollectionViewCell: UICollectionViewCell {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var guestNameLabel: UILabel!
    @IBOutlet weak var guestImageView: UIImageView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }

    //Mark:- Functions
    //================
    ///Config UI
    private func configUI() {
        //UI
        self.guestImageView.makeCircular()
//        self.guestImageView.backgroundColor = AppColors.themeGray60
        //Font
        self.guestNameLabel.font = AppFonts.Regular.withSize(14.0)
        //Color
        self.guestNameLabel.textColor = AppColors.themeBlack
    }
    
    ///Config Cell
    internal func configCell(name: String, firstName: String , lastName: String , imageUrl: String) {
        self.guestNameLabel.text = name
        let placeholderImage = AppGlobals.shared.getImageFor(firstName: firstName, lastName: lastName , font: AppFonts.Light.withSize(36.0), textColor: AppColors.themeGray60 , backGroundColor: AppColors.imageBackGroundColor)
        self.guestImageView.setImageWithUrl(imageUrl, placeholder: placeholderImage, showIndicator: false)
    }
}
