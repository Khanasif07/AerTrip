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
        //Font
        self.guestNameLabel.font = AppFonts.Regular.withSize(14.0)
        //Color
        self.guestNameLabel.textColor = AppColors.themeBlack
    }
    
    ///Config Cell
    internal func configCell(name: String, imageUrl: String) {
        self.guestNameLabel.text = name
        self.guestImageView.setImageWithUrl(imageUrl, placeholder: #imageLiteral(resourceName: "profilePlaceholder"), showIndicator: false)
    }
}
