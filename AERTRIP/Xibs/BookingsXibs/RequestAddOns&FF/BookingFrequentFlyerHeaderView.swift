//
//  BookingFrequestFlyerHeaderView.swift
//  AERTRIP
//
//  Created by apple on 22/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingFrequentFlyerHeaderView: UITableViewHeaderFooterView {
    // MARK: - IB Outlets
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var passengerNameLabel: UILabel!
    @IBOutlet var dividerView: UIView!
    @IBOutlet var frequentFlyerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpText()
        self.setUpTextColor()
    }
    
    // MARK: - Helper methods
    
    func setUpFont() {
        self.passengerNameLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.frequentFlyerLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    func setUpText() {
        self.frequentFlyerLabel.text = LocalizedString.FrequentFlyer.localized
    }
    
    func setUpTextColor() {
        self.frequentFlyerLabel.textColor = AppColors.themeGray40
    }
    
    func configureCell(profileImage: String, salutationImage: UIImage, passengerName: String) {
        if profileImage.isEmpty {
            self.profileImageView.image = salutationImage
            
        } else {
            self.profileImageView.setImageWithUrl(profileImage, placeholder: AppPlaceholderImage.user, showIndicator: true)
        }
        
        self.passengerNameLabel.text = passengerName
    }
}
