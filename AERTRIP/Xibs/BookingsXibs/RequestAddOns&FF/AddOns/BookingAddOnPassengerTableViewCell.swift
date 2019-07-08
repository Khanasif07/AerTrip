//
//  BookingAddOnPassengerTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 22/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingAddOnPassengerTableViewCell: ATTableViewCell {
    // MARK: - IBOutlet
    
    @IBOutlet var passengerNameLabel: UILabel!
    @IBOutlet var passengerImageView: UIImageView!
    
    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    override func setupFonts() {
        self.passengerNameLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    override func setupColors() {
        self.passengerNameLabel.textColor = AppColors.themeBlack
    }
    
    func configureCell(profileImage: String, salutationImage: UIImage, passengerName: String) {
        if profileImage.isEmpty {
            self.passengerImageView.image = salutationImage
           
        } else {
           self.passengerImageView.setImageWithUrl(profileImage, placeholder: AppPlaceholderImage.user, showIndicator: true)
        }
        
        self.passengerNameLabel.text = passengerName
    }
}
