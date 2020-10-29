//
//  TravellersDetailsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 04/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TravellersDetailsTableViewCell: UITableViewCell {
    // MARK: - Variables
    
    // MARK: ===========
    
    // MARK: - IBOutlets
    
    // MARK: ===========
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var travellerProfileImage: UIImageView!
    @IBOutlet weak var travellerName: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var travellerImgViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.travellerName.attributedText = nil
    }
    // MARK: - Functions
    
    // MARK: ===========
    
    private func configureUI() {
        self.dividerView.isHidden = true
        self.travellerName.font = AppFonts.Regular.withSize(16.0)
        self.travellerName.textColor = AppColors.themeBlack
        
        self.travellerProfileImage.makeCircular(borderWidth: 1.0, borderColor: AppColors.themeGray20)
    }
    
    internal func configCell(travellersImage: String, travellerName: String,firstName: String,lastName: String, isLastTravellerInRoom: Bool, isLastTraveller: Bool, isOtherBookingData: Bool = false, dob: String, salutation: String, age: String, congigureForHotelDetail: Bool ) {
        //self.travellerName.text = travellerName
        self.travellerImgViewBottomConstraint.constant = (isLastTraveller || isLastTravellerInRoom) ? 16.0 : 4.0
        self.containerViewBottomConstraint.constant = isLastTraveller ? 16 : 0.0 // 21 : 0.0
        if !isOtherBookingData {
            self.lastCellShadowSetUp(isLastCell: isLastTraveller)
        }
        if !travellersImage.isEmpty {
            self.travellerProfileImage.setImageWithUrl(travellersImage, placeholder: #imageLiteral(resourceName: "profilePlaceholder"), showIndicator: true)
            self.travellerProfileImage.contentMode = .scaleAspectFill
        } else {
            //self.travellerProfileImage.image = AppGlobals.shared.getImageFor(firstName: firstName, lastName: lastName, font: AppFonts.Regular.withSize(35.0))
            if congigureForHotelDetail {
                self.travellerProfileImage.image = AppGlobals.shared.getEmojiIconFromAge(ageString: age, salutation: salutation)
            } else {
                self.travellerProfileImage.image = AppGlobals.shared.getEmojiIcon(dob: dob, salutation: salutation, dateFormatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            }
            
            self.travellerProfileImage.contentMode = .center
        }
        var ageString = ""
        if congigureForHotelDetail {
            if !age.isEmpty, let intAge = Int(age), (intAge > 0 && intAge <= 12) {
                ageString = " (\(age)y)"
                //travelName += age
            }
        } else {
            if !dob.isEmpty {
                ageString = AppGlobals.shared.getAgeLastString(dob: dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            }
        }
        // self.travellerNameLabel.text = travelName
        self.travellerName.appendFixedText(text: travellerName, fixedText: ageString)
        if !age.isEmpty {
            self.travellerName.AttributedFontColorForText(text: ageString, textColor: AppColors.themeGray40)
        }
        
    }
    
    private func lastCellShadowSetUp(isLastCell: Bool) {
        if isLastCell {
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        } else {
            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        }
    }
}

