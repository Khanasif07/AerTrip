//
//  HCPhoneTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCPhoneTableViewCell: UITableViewCell {

    //Mark:- Variables
    //================
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Methods
    //==============
    ///COnfigure UI
    private func configUI() {
        //Font
        self.phoneLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.phoneNumberLabel.font = AppFonts.Regular.withSize(18.0)
        //Text
        self.phoneLabel.text = LocalizedString.Phone.localized
        //Color
        self.phoneLabel.textColor = AppColors.themeBlack
        self.phoneNumberLabel.textColor = AppColors.themeBlack
        self.countryImageView.backgroundColor = .clear
        self.dividerView.isHidden = true
    }
    
    ///COnfigure Cell
    internal func configCell(countryImage: UIImage , phoneNumber: String) {
        self.countryImageView.image = countryImage
        self.phoneNumberLabel.text = phoneNumber
    }
}
