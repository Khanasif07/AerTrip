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
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var travellerFirstNameLabel: UILabel!
    @IBOutlet weak var travellerLastNameLabel: UILabel!
    @IBOutlet weak var travellerAgeLabel: UILabel!
    @IBOutlet weak var bottomSlideView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var lastNameAgeContainer: UIView!
    @IBOutlet weak var leadingOfStackView: NSLayoutConstraint!
    @IBOutlet weak var trailingOfStackView: NSLayoutConstraint!
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }
    
    private func doInitialSetup() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.layer.masksToBounds = true
        resetView()
    }
    
    private func setUpFont() {
        self.travellerFirstNameLabel.font = AppFonts.Regular.withSize(14.0)
        self.travellerLastNameLabel.font = AppFonts.Regular.withSize(14.0)
        self.travellerAgeLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    private func setUpTextColor() {
        self.travellerFirstNameLabel.textColor = AppColors.themeBlack
        self.travellerLastNameLabel.textColor = AppColors.themeBlack
        self.travellerAgeLabel.textColor = AppColors.themeGray40
        self.bottomSlideView.backgroundColor = AppColors.themeGreen
    }
    
    private func updateSelection() {
        self.bottomSlideView.isHidden = !self.isPaxSelected
    }
    
    private func resetView() {
        travellerLastNameLabel.isHidden = true
        travellerAgeLabel.isHidden = true
        lastNameAgeContainer.isHidden = true
        travellerAgeLabel.text = ""
        travellerAgeLabel.text = ""
    }
    
    private func configureCell() {
//        var travellerName = self.paxData?.fullName ?? ""
//        if self.paxData?.paxType == AppConstants.kChildPax {
//            travellerName += " ( \(LocalizedString.Child.localized))"
//        } else if  self.paxData?.paxType == AppConstants.kInfantPax {
//            travellerName += " (\(LocalizedString.Infant.localized))"
//        }
        self.travellerFirstNameLabel.text = self.paxData?.firstName ?? ""
        self.travellerLastNameLabel.text = self.paxData?.lastName ?? ""
        self.travellerAgeLabel.text = AppGlobals.shared.getAgeLastString(dob: self.paxData?.dob ?? "", formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
        lastNameAgeContainer.isHidden = (((self.paxData?.lastName ?? "").isEmpty) && ((self.paxData?.dob ?? "").isEmpty))
        self.travellerLastNameLabel.isHidden = (self.paxData?.lastName ?? "").isEmpty
        self.travellerAgeLabel.isHidden = (self.paxData?.dob ?? "").isEmpty
        
        let placeImage = AppGlobals.shared.getImageFor(firstName: self.paxData?.firstName, lastName: self.paxData?.lastName, font: AppFonts.Regular.withSize(35.0),backGroundColor: AppColors.blueGray)
        if self.paxData?.profileImage.isEmpty ?? false {
            self.profileImageView.image = placeImage
        } else {
            self.profileImageView.setImageWithUrl(self.paxData?.profileImage ?? "", placeholder: placeImage, showIndicator: false)
        }
    }
    
    func reduceLeadingAndTrailing(){
        
        self.leadingOfStackView.constant = 4
        self.trailingOfStackView.constant = 4
        
    }
    
    private func configureCellForGuest() {
//        var finalStr = self.guestData?.fullName ?? ""
        var ageToShow = ""
        if let age = self.guestData?.age.toInt, (age > 0 && age <= 12) {
            ageToShow = " (\(age)y)"
        }
        
        self.travellerFirstNameLabel.text = self.guestData?.firstName ?? ""
        self.travellerLastNameLabel.text = self.guestData?.lastname ?? ""
        self.travellerAgeLabel.text = ageToShow
        lastNameAgeContainer.isHidden = (((self.guestData?.lastname ?? "").isEmpty) && ((ageToShow).isEmpty))
        self.travellerLastNameLabel.isHidden = (self.guestData?.lastname ?? "").isEmpty
        self.travellerAgeLabel.isHidden = ageToShow.isEmpty
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
