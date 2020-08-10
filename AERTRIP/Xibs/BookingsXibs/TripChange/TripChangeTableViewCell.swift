//
//  TripChangeTableViewCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 09/07/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TripChangeTableViewCell: ATTableViewCell {
    // MARK: - IB Outlet
    
    @IBOutlet weak var tripChangeImageView: UIImageView!
    @IBOutlet weak var tripTitleLabel: UILabel!
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var viewBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var cellHeightConstraints: NSLayoutConstraint!
    
    var hideBottomSpace = false {
        didSet {
            self.updateBottomConstraint()
        }
    }
    
    override func doInitialSetup() {
        self.tripChangeImageView.tintColor = AppColors.brightViolet
    }
    
    override func setupFonts() {
        self.changeButton.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        self.tripNameLabel.font = AppFonts.Regular.withSize(18.0)
        self.tripTitleLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    override func setupColors() {
        self.tripChangeImageView.tintColor = AppColors.brightViolet
        self.tripTitleLabel.textColor = AppColors.themeGray40
        self.tripNameLabel.textColor = AppColors.textFieldTextColor51
        self.changeButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.changeButton.setTitleColor(AppColors.themeGreen, for: .selected)
    }
    
    override func setupTexts() {
        self.tripTitleLabel.text = LocalizedString.TripName.localized
        self.changeButton.setTitle(LocalizedString.Change.localized, for: .normal)
        self.changeButton.setTitle(LocalizedString.Change.localized, for: .selected)
    }
    
    func configureCell(tripName: String) {
        self.tripNameLabel.text = tripName
    }
    
    private func updateBottomConstraint() {
        let bottomConstant: CGFloat = hideBottomSpace ? 0 : 21
        if viewBottomContraint.constant != bottomConstant {
            viewBottomContraint.constant = bottomConstant
            self.contentView.layoutIfNeeded()
        }
    }
}
