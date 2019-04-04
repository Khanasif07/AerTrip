//
//  FareSectionHeader.swift
//  AERTRIP
//
//  Created by apple on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol FareSectionHeaderDelegate: class{
    func headerViewTapped()
}

class FareSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet var grossFareTitleLabel: UILabel!
    @IBOutlet var discountsTitleLabel: UILabel!
    @IBOutlet var grossPriceLabel: UILabel!
    @IBOutlet var discountPriceLabel: UILabel!
    @IBOutlet weak var topBackgroundView: UIView!
    
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var discountViewHeightConstraint: NSLayoutConstraint!
    
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
        //Add tap gesture to your view
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        topBackgroundView.addGestureRecognizer(tap)
    }
    
    // GestureRecognizer
    @objc func handleGesture(gesture: UITapGestureRecognizer) -> Void {
         let rotateTrans = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        if isTappedFirstTime {
            arrowButton.transform = .identity
            isTappedFirstTime = false
        } else {
            arrowButton.transform = rotateTrans
            isTappedFirstTime = true
        }
        delegate?.headerViewTapped()
    }
    
    @IBAction func arrowButtonTapped(_ sender: Any) {
        delegate?.headerViewTapped()
    }
    
}
