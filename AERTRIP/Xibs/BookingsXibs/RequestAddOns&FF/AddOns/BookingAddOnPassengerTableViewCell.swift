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
    
    @IBOutlet weak var passengerNameLabel: UILabel!
    @IBOutlet weak var requestInProcessLbl: UILabel!
    @IBOutlet weak var passengerImageView: UIImageView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        passengerNameLabel.attributedText = nil
    }
    
    override func setupFonts() {
        self.passengerNameLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.requestInProcessLbl.font = AppFonts.Regular.withSize(16)
        
    }
    
    override func setupColors() {
        self.passengerNameLabel.textColor = AppColors.themeBlack
        self.requestInProcessLbl.textColor = AppColors.themeRed
    }
    
    override func setupTexts() {
        self.requestInProcessLbl.text = LocalizedString.requestInProcess.localized
    }
    
    func configureCell(profileImage: String, salutationImage: UIImage, passengerName: String, age: String) {
        if profileImage.isEmpty {
            self.passengerImageView.image = salutationImage
           
        } else {
           self.passengerImageView.setImageWithUrl(profileImage, placeholder: AppPlaceholderImage.user, showIndicator: true)
        }
        self.passengerNameLabel.appendFixedText(text: passengerName, fixedText: age)
        if !age.isEmpty {
            self.passengerNameLabel.AttributedFontColorForText(text: age, textColor: AppColors.themeGray40)
        }
    }
}
