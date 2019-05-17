//
//  BookingVoucherTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 17/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingVoucherTableViewCell: ATTableViewCell {

    
    // MARK:- IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var payNowButton: UIButton!
    @IBOutlet weak var dateLabelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dividerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerView: ATDividerView!
    
    var voucherData: VoucherEvent = VoucherEvent() {
        didSet {
            self.configureCell()
        }
    }
    
    
    
    
    
    // MARK: - Override methods
    
    
    override func doInitialSetup() {
        self.payNowButton.addGredient(isVertical: false)
        self.payNowButton.layer.cornerRadius = 14.0
        self.payNowButton.layer.masksToBounds = true
        
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
           self.dateLabel.font = AppFonts.Regular.withSize(16.0)
           self.priceLabel.font = AppFonts.Regular.withSize(22.0)
        self.payNowButton.titleLabel?.font = AppFonts.SemiBold.withSize(16.0)
        
    
    }
    
    override func setupTexts() {
        self.payNowButton.setTitle(LocalizedString.PayNow.localized, for: .normal)
        self.payNowButton.setTitle(LocalizedString.PayNow.localized, for: .selected)
    }
   
    
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.textFieldTextColor51
        self.dateLabel.textColor = AppColors.themeGray40
        self.priceLabel.textColor = AppColors.textFieldTextColor51
        self.payNowButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.payNowButton.setTitleColor(AppColors.themeWhite, for: .normal)
    }
    
    func configureCell() {
        self.titleLabel.textColor = AppColors.textFieldTextColor51
       self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        self.dateLabel.font = AppFonts.Regular.withSize(16.0)
        self.dateLabel.textColor = AppColors.themeGray40
        if self.voucherData.type.lowercased() == "payment" {
            self.titleLabel.textColor = AppColors.themeBlack
            self.titleLabel.font = AppFonts.Regular.withSize(14.0)
            self.dateLabel.textColor = AppColors.themeBlack
            self.dateLabel.font = AppFonts.SemiBold.withSize(24.0)
            self.payNowButton.isHidden = false
            self.titleLabel.text = self.voucherData.title
            self.dateLabel.text = self.voucherData.price
            self.priceLabel.isHidden = true
            self.arrowImageView.isHidden = true
        } else {
            self.payNowButton.isHidden = true
            self.titleLabel.text = self.voucherData.title
            self.dateLabel.text = self.voucherData.date
            self.priceLabel.text = self.voucherData.price
            self.priceLabel.isHidden = false
            self.arrowImageView.isHidden = false
        }
        
    }
    
}
