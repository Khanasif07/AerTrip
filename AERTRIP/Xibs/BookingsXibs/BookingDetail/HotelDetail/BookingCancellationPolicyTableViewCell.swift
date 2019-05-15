//
//  BookingCancellationPolicyTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BookingCancellationPolicyTableViewCellDelegate: class {
    func bookingPolicyButtonTapped()
    func cancellationPolicyButonTapped()
}

class BookingCancellationPolicyTableViewCell: ATTableViewCell {
    // MARK: - IBOultet
    
    @IBOutlet var bookingPolicyButton: UIButton!
    @IBOutlet var cancellationPolicyButton: UIButton!
    
    // MARK: - Variables
    
    weak var delegate: BookingCancellationPolicyTableViewCellDelegate?
    
    override func setupFonts() {
        self.bookingPolicyButton.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        self.cancellationPolicyButton.titleLabel?.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupColors() {
       
          // for normal state
        self.bookingPolicyButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.cancellationPolicyButton.setTitleColor(AppColors.themeGreen, for: .normal)
       
            // For selected state
        self.bookingPolicyButton.setTitleColor(AppColors.themeGreen, for: .selected)
        self.cancellationPolicyButton.setTitleColor(AppColors.themeGreen, for: .selected)
    }
    
    override func setupTexts() {
        // for normal state
        self.bookingPolicyButton.setTitle(LocalizedString.BookingPolicy.localized, for: .normal)
        self.cancellationPolicyButton.setTitle(LocalizedString.cancellationPolicy.localized, for: .normal)
        
        // For selected state
        self.bookingPolicyButton.setTitle(LocalizedString.BookingPolicy.localized, for: .selected)
        self.cancellationPolicyButton.setTitle(LocalizedString.cancellationPolicy.localized, for: .selected)
    }
}
