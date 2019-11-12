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
    @IBOutlet weak var guestFirstNameLabel: UILabel!
    @IBOutlet weak var guestLastNameLabel: UILabel!
    @IBOutlet weak var guestAgeLabel: UILabel!
    @IBOutlet weak var guestImageView: UIImageView!
    @IBOutlet weak var lastNameAgeContainer: UIView!

    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }
    
    //Mark:- Functions
    //================
    ///Config UI
    private func configUI() {
        //UI
        self.guestImageView.makeCircular()
//        self.guestImageView.backgroundColor = AppColors.themeGray60
        //Font
        self.guestFirstNameLabel.font = AppFonts.Regular.withSize(14.0)
        self.guestLastNameLabel.font = AppFonts.Regular.withSize(14.0)
        self.guestAgeLabel.font = AppFonts.Regular.withSize(14.0)
        //Color
        self.guestFirstNameLabel.textColor = AppColors.themeBlack
        self.guestLastNameLabel.textColor = AppColors.themeBlack
        self.guestAgeLabel.textColor = AppColors.themeGray40
        resetView()
    }
    
    private func resetView() {
        guestLastNameLabel.isHidden = true
        guestAgeLabel.isHidden = true
        lastNameAgeContainer.isHidden = true
        guestAgeLabel.text = ""
        guestLastNameLabel.text = ""
    }
    
    ///Config Cell
    internal func configCell(name: String, firstName: String , lastName: String , age: String , imageUrl: String) {
        self.guestFirstNameLabel.text = firstName
        self.guestLastNameLabel.text = lastName
        self.guestAgeLabel.text = "(\(age)y)"
        lastNameAgeContainer.isHidden = (lastName.isEmpty && age.isEmpty)
        guestLastNameLabel.isHidden = lastName.isEmpty
        guestAgeLabel.isHidden = age.isEmpty

        let placeholderImage = AppGlobals.shared.getImageFor(firstName: firstName, lastName: lastName , font: AppFonts.Light.withSize(36.0), textColor: AppColors.themeGray60 , backGroundColor: AppColors.imageBackGroundColor)
        self.guestImageView.setImageWithUrl(imageUrl, placeholder: placeholderImage, showIndicator: false)
    }
}
