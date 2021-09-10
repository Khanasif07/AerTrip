//
//  HotelFareTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 20/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelFareTableViewCellDelegate: class{
    func headerViewTapped(_ view:HotelFareTableViewCell)
}

class HotelFareTableViewCell: UITableViewCell {
    
    @IBOutlet weak var grossFareTitleLabel: UILabel!
    @IBOutlet weak var discountsTitleLabel: UILabel!
    @IBOutlet weak var grossPriceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var topBackgroundView: UIView!
    
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var discountViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var grossFareTitleTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var discountHeaderContainer: UIView!
    @IBOutlet weak var dicountLabelBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var discountTitleLabelTopConstraint: NSLayoutConstraint!
    
    
    // MARK: - Properties
    weak var delegate: HotelFareTableViewCellDelegate?
    var isTappedFirstTime: Bool = false
    
    
    override func awakeFromNib() {
        self.setUpText()
        self.setUpFont()
        self.setUpTextColor()
        self.addGesture()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        grossPriceLabel.attributedText = nil
        discountPriceLabel.attributedText = nil
        
    }
    
    private func setUpText() {
        self.grossFareTitleLabel.text = LocalizedString.GrossFare.localized
        self.discountsTitleLabel.text = LocalizedString.Discounts.localized
    }
    
    private func setUpFont() {
        self.grossFareTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.discountsTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.grossPriceLabel.font = AppFonts.Regular.withSize(16.0)
        self.discountPriceLabel.font = AppFonts.Regular.withSize(16.0)
        
    }
    
    private func setUpTextColor() {
        self.grossFareTitleLabel.textColor = AppColors.themeBlack
        self.discountPriceLabel.textColor = AppColors.themeBlack
        self.grossPriceLabel.textColor = AppColors.themeBlack
        self.discountPriceLabel.textColor = AppColors.themeBlack
        self.topBackgroundView.backgroundColor = AppColors.themeBlack26
        self.discountHeaderContainer.backgroundColor = AppColors.themeBlack26
    }
    
    private func addGesture() {
        //Add tap gesture to your view
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        topBackgroundView.addGestureRecognizer(tap)
    }
    
    // GestureRecognizer
    @objc func handleGesture(gesture: UITapGestureRecognizer) -> Void {
        
        delegate?.headerViewTapped(self)
    }
    
    @IBAction func arrowButtonTapped(_ sender: Any) {
        delegate?.headerViewTapped(self)
    }
    
}
