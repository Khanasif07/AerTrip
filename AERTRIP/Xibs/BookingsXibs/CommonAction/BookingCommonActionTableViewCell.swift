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
    case bookAnotherRoom
}

class BookingCommonActionTableViewCell: ATTableViewCell {
    // MARK: - IB Outlet
    
    @IBOutlet weak var actionButton: ATButton!
    @IBOutlet weak var topBackgroundView: UIView!
    
    // MARK: - Variables
    
    var usingFor: BookingCommonActionUsingFor = .addToCalender
    
    override func prepareForReuse() {
        super.prepareForReuse()
        actionButton.isLoading = false
    }
    
    override func doInitialSetup() {
        self.actionButton.layer.cornerRadius = 10.0
        self.actionButton.layer.masksToBounds = true
        self.actionButton.imageView?.size = CGSize(width: 30.0, height: 22.0)
        self.actionButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -20.0, bottom: 0.0, right: 0.0)
        self.actionButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 16, bottom: 0.0, right: 0.0)
        self.topBackgroundView.layer.cornerRadius = 10
        self.actionButton.isSocial = true
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
            self.actionButton.titleLabel?.font = AppFonts.Regular.withSize(16.0)
            self.actionButton.setTitleFont(font: AppFonts.SemiBold.withSize(16), for: .highlighted)
            self.actionButton.setTitleFont(font: AppFonts.SemiBold.withSize(16), for: .normal)
            self.actionButton.setTitleFont(font: AppFonts.SemiBold.withSize(16), for: .selected)

            self.topBackgroundView.backgroundColor = AppColors.themeBlack
            self.actionButton.setTitleColor(AppColors.themeWhite, for: .normal)
            self.actionButton.setTitleColor(AppColors.themeWhite, for: .selected)
            
            self.topBackgroundView.layer.borderWidth = 0.0
            self.topBackgroundView.layer.borderColor = AppColors.clear.cgColor
            self.actionButton.gradientColors = [AppColors.themeBlack, AppColors.themeBlack]

        } else {
            self.actionButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
            self.actionButton.setTitleFont(font: AppFonts.SemiBold.withSize(18.0), for: .highlighted)
            self.actionButton.setTitleFont(font: AppFonts.SemiBold.withSize(18.0), for: .normal)
            self.actionButton.setTitleFont(font: AppFonts.SemiBold.withSize(18.0), for: .selected)
            self.topBackgroundView.backgroundColor = AppColors.themeWhite
            self.actionButton.setTitleColor(AppColors.themeGreen, for: .normal)
            self.actionButton.setTitleColor(AppColors.themeGreen, for: .selected)
            
            self.actionButton.gradientColors = [AppColors.themeWhite, AppColors.themeWhite]
            self.topBackgroundView.layer.borderWidth = 1.0
            self.topBackgroundView.layer.borderColor = AppColors.themeGreen.cgColor
        }
        self.actionButton.setImage(buttonImage, for: .normal)
       // self.actionButton.setImage(buttonImage, for: .selected)
        
        self.actionButton.setTitle(buttonTitle, for: .normal)
       // self.actionButton.setTitle(buttonTitle, for: .selected)
    }
}
