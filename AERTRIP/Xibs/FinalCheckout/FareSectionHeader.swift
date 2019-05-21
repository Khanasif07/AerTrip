//
//  FareSectionHeader.swift
//  AERTRIP
//
//  Created by apple on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol FareSectionHeaderDelegate: class {
    func headerViewTapped()
}

class FareSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet var grossFareTitleLabel: UILabel!
    @IBOutlet var discountsTitleLabel: UILabel!
    @IBOutlet var grossPriceLabel: UILabel!
    @IBOutlet var discountPriceLabel: UILabel!
    @IBOutlet var topBackgroundView: UIView!
    
    @IBOutlet var cellTopViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var grossFareTopConstraint: NSLayoutConstraint!
    @IBOutlet var arrowButton: UIButton!
    @IBOutlet var discountViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var bottomViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    weak var delegate: FareSectionHeaderDelegate?
    var isTappedFirstTime: Bool = false
    
    override func awakeFromNib() {
        self.setUpText()
        self.setUpFont()
        self.setUpTextColor()
        self.addGesture()
    }
    
    private func setUpText() {
        self.grossFareTitleLabel.text = LocalizedString.GrossFare.localized
        self.discountsTitleLabel.text = LocalizedString.Discounts.localized
    }
    
    private func setUpFont() {
        self.grossFareTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.discountPriceLabel.font = AppFonts.Regular.withSize(16.0)
        self.discountsTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.grossPriceLabel.font = AppFonts.Regular.withSize(16.0)
        self.discountPriceLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    private func setUpTextColor() {
        self.grossFareTitleLabel.textColor = AppColors.themeBlack
        self.discountPriceLabel.textColor = AppColors.themeBlack
        self.grossPriceLabel.textColor = AppColors.themeBlack
        self.discountPriceLabel.textColor = AppColors.themeBlack
    }
    
    private func addGesture() {
        // Add tap gesture to your view
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleGesture))
        self.topBackgroundView.addGestureRecognizer(tap)
    }
    
    // GestureRecognizer
    @objc func handleGesture(gesture: UITapGestureRecognizer) {
        self.delegate?.headerViewTapped()
    }
    
    @IBAction func arrowButtonTapped(_ sender: Any) {
        self.delegate?.headerViewTapped()
    }
}
