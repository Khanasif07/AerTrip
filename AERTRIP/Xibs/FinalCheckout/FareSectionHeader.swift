//
//  FareSectionHeader.swift
//  AERTRIP
//
//  Created by apple on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol FareSectionHeaderDelegate: class {
    func headerViewTapped(_ view:UITableViewHeaderFooterView)
}

class FareSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var grossFareTitleLabel: UILabel!
    @IBOutlet weak var discountsTitleLabel: UILabel!
    @IBOutlet weak var grossPriceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var topBackgroundView: UIView!
    @IBOutlet weak var arrowTapAreaView: UIView!
    @IBOutlet weak var discountContainer: UIView!
    
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var stackViewTopConstriant: NSLayoutConstraint!
    
    // MARK: - Properties
    
   public weak var delegate: FareSectionHeaderDelegate?

    var isDownArrow: Bool = true {
        didSet {
            arrowButton.setImage(isDownArrow ? AppImages.downArrowCheckOut : AppImages.upArrowIconCheckout, for: .normal)
        }
    }
    
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
        self.arrowTapAreaView.addGestureRecognizer(tap)
    }
    
    // GestureRecognizer
    @objc func handleGesture(gesture: UITapGestureRecognizer) {
        self.delegate?.headerViewTapped(self)
    }
    
    @IBAction func arrowButtonTapped(_ sender: Any) {
        self.delegate?.headerViewTapped(self)
    }
}
