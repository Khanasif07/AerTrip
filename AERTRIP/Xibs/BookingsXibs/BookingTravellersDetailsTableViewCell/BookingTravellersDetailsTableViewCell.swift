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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var travellersLabel: UILabel!
    @IBOutlet weak var travellerNameLabel: UILabel!
    @IBOutlet weak var travellerImageView: UIImageView!
    @IBOutlet weak var travellerImageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerView: ATDividerView!
    // Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.travellerNameLabel.attributedText = nil
    }
    
    // Mark:- Functions
    //================
    private func configUI() {
        self.travellersLabel.font = AppFonts.Regular.withSize(14.0)
        self.travellersLabel.textColor = AppColors.themeGray40
        self.travellerNameLabel.font = AppFonts.Regular.withSize(16.0)
        self.travellerNameLabel.textColor = AppColors.themeBlack
        self.travellersLabel.text = LocalizedString.Travellers.localized
        self.dividerView.isHidden = true
        self.travellerImageView.makeCircular()
    }
    
    func configCell(travellersImage: String, travellerName: String, firstName: String, lastName: String, dob: String, salutation: String) {
//          self.travellerNameLabel.text = travellerName
        if !travellersImage.isEmpty {
            self.travellerImageView.setImageWithUrl(travellersImage, placeholder: #imageLiteral(resourceName: "profilePlaceholder"), showIndicator: true)
            self.travellerImageView.contentMode = .scaleAspectFit
        } else {
            self.travellerImageView.makeCircular(borderWidth: 1.0, borderColor: AppColors.themeGray20)
            //self.travellerImageView.image = AppGlobals.shared.getImageFor(firstName: firstName, lastName: lastName, font: AppFonts.Regular.withSize(35.0))
            self.travellerImageView.image = AppGlobals.shared.getEmojiIcon(dob: dob, salutation: salutation, dateFormatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            self.travellerImageView.contentMode = .center
        }
        var age = ""
        if !dob.isEmpty {
            age = AppGlobals.shared.getAgeLastString(dob: dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            //travelName += age
        }
        // self.travellerNameLabel.text = travelName
        self.travellerNameLabel.appendFixedText(text: travellerName, fixedText: age)
        if !age.isEmpty {
            self.travellerNameLabel.AttributedFontColorForText(text: age, textColor: AppColors.themeGray40)
        }
    }
}

// Mark:- IBActions
//================
