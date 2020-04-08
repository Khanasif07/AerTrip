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
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var passengerNameLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var frequentFlyerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.setUpFont()
        self.setUpText()
        self.setUpTextColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        passengerNameLabel.attributedText = nil
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
    
    func configureCell(profileImage: String, salutationImage: UIImage, passengerName: String, age: String) {
        self.contentView.layoutSubviews()
        if profileImage.isEmpty {
            self.profileImageView.image = salutationImage
            
        } else {
            self.profileImageView.setImageWithUrl(profileImage, placeholder: AppPlaceholderImage.user, showIndicator: true)
        }
        
        self.passengerNameLabel.appendFixedText(text: passengerName, fixedText: age)
        if !age.isEmpty {
            self.passengerNameLabel.AttributedFontColorForText(text: age, textColor: AppColors.themeGray40)
        }
    }
}
