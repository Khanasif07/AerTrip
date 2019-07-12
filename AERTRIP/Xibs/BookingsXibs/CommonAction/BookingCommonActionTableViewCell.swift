//
//  BookingCommonActionTableViewCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 09/07/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

enum BookingCommonActionUsingFor {
    case addToCalender
    case addToAppleWallet
    case addToTrips
    case bookSameFlight
}

class BookingCommonActionTableViewCell: ATTableViewCell {
    // MARK: - IB Outlet
    
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var topBackgroundView: UIView!
    
    // MARK: - Variables
    
    var usingFor: BookingCommonActionUsingFor = .addToCalender
    
    override func doInitialSetup() {
        self.actionButton.layer.cornerRadius = 10.0
        self.actionButton.layer.masksToBounds = true
        self.actionButton.imageView?.size = CGSize(width: 30.0, height: 22.0)
        self.actionButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -20.0, bottom: 0.0, right: 0.0)
        self.actionButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 16, bottom: 0.0, right: 0.0)
        self.topBackgroundView.layer.cornerRadius = 10
        self.topBackgroundView.layer.borderWidth = 1.0
        self.topBackgroundView.layer.borderColor = AppColors.themeGreen.cgColor
    }
    
    override func setupFonts() {
        self.actionButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.actionButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.actionButton.setTitleColor(AppColors.themeGreen, for: .selected)
    }
    
    func configureCell(buttonImage: UIImage, buttonTitle: String) {
        if buttonTitle == LocalizedString.AddToAppleWallet.localized {
            self.topBackgroundView.backgroundColor = AppColors.themeBlack
            self.actionButton.setTitleColor(AppColors.themeWhite, for: .normal)
            self.actionButton.setTitleColor(AppColors.themeWhite, for: .selected)
            
        } else {
            self.topBackgroundView.backgroundColor = AppColors.themeWhite
            self.actionButton.setTitleColor(AppColors.themeGreen, for: .normal)
            self.actionButton.setTitleColor(AppColors.themeGreen, for: .selected)
        }
        self.actionButton.setImage(buttonImage, for: .normal)
        self.actionButton.setImage(buttonImage, for: .selected)
        self.actionButton.setTitle(buttonTitle, for: .normal)
        self.actionButton.setTitle(buttonTitle, for: .selected)
    }
}
