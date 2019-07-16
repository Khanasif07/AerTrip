//
//  BookingTravellerCollectionViewCell.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingTravellerCollectionViewCell: UICollectionViewCell {
    // MARK: -  IBOutlet
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var travellerNameLabel: UILabel!
    @IBOutlet var bottomSlideView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var paxData: Pax? {
        didSet {
            self.configureCell()
        }
    }
    
    var guestData: GuestDetail? {
        didSet {
            self.configureCellForGuest()
        }
    }
    
    var isPaxSelected: Bool = false {
        didSet {
            self.updateSelection()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpTextColor()
        self.setUpFont()
        self.doInitialSetup()
        self.profileImageView.cornerRadius = self.profileImageView.height / 2.0
    }
    
    private func doInitialSetup() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.layer.masksToBounds = true
    }
    
    private func setUpFont() {
        self.travellerNameLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    private func setUpTextColor() {
        self.travellerNameLabel.textColor = AppColors.themeBlack
        self.bottomSlideView.backgroundColor = AppColors.themeGreen
    }
    
    private func updateSelection() {
        self.bottomSlideView.isHidden = !self.isPaxSelected
    }
    
    private func configureCell() {
        var travellerName = self.paxData?.fullName ?? ""
        if self.paxData?.paxType == AppConstants.kChildPax {
            travellerName += " ( \(LocalizedString.Child.localized))"
        } else if  self.paxData?.paxType == AppConstants.kInfantPax {
            travellerName += " (\(LocalizedString.Infant.localized))"
        }
        self.travellerNameLabel.text = travellerName
        let placeImage = AppGlobals.shared.getImageFor(firstName: self.paxData?.firstName, lastName: self.paxData?.lastName, font: AppFonts.Regular.withSize(35.0),backGroundColor: AppColors.blueGray)
        if self.paxData?.profileImage.isEmpty ?? false {
            self.profileImageView.image = placeImage
        } else {
            self.profileImageView.setImageWithUrl(self.paxData?.profileImage ?? "", placeholder: placeImage, showIndicator: false)
        }
    }
    
    private func configureCellForGuest() {
        self.travellerNameLabel.text = self.guestData?.fullName ?? ""
        self.bottomConstraint.constant = 0
        self.topConstraint.constant = 10
        let placeImage = AppGlobals.shared.getImageFor(firstName: self.guestData?.firstName, lastName: self.guestData?.lastname, font: AppFonts.Regular.withSize(35.0),backGroundColor: AppColors.blueGray)
        if self.guestData?.profileImage.isEmpty ?? false {
            self.profileImageView.image = placeImage
        } else {
            self.profileImageView.setImageWithUrl(self.guestData?.profileImage ?? "", placeholder: placeImage, showIndicator: false)
        }
    }
}
