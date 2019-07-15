//
//  BookingTravellersDetailsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingTravellersDetailsTableViewCell: UITableViewCell {
    // Mark:- Variables
    //================
    
    // Mark:- IBOutlets
    //================
    @IBOutlet var containerView: UIView!
    @IBOutlet var travellersLabel: UILabel!
    @IBOutlet var travellerNameLabel: UILabel!
    @IBOutlet var travellerImageView: UIImageView!
    @IBOutlet var dividerView: ATDividerView!
    // Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    // Mark:- Functions
    //================
    private func configUI() {
        self.travellersLabel.font = AppFonts.Regular.withSize(14.0)
        self.travellersLabel.textColor = AppColors.themeGray40
        self.travellerNameLabel.font = AppFonts.Regular.withSize(16.0)
        self.travellerNameLabel.textColor = AppColors.themeBlack
        self.travellersLabel.text = LocalizedString.Travellers.localized
        self.travellerImageView.makeCircular()
    }
    
    func configCell(travellersImage: String, travellerName: String, firstName: String, lastName: String) {
          self.travellerNameLabel.text = travellerName
        if !travellersImage.isEmpty {
            self.travellerImageView.setImageWithUrl(travellersImage, placeholder: #imageLiteral(resourceName: "profilePlaceholder"), showIndicator: true)
        } else {
            self.travellerImageView.makeCircular(borderWidth: 1.0, borderColor: AppColors.themeGray04)
            self.travellerImageView.image = AppGlobals.shared.getImageFor(firstName: firstName, lastName: lastName, font: AppFonts.Regular.withSize(35.0))
        }
    }
}

// Mark:- IBActions
//================
