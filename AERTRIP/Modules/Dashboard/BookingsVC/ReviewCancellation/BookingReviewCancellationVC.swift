//
//  BookingReviewCancellationVC.swift
//  AERTRIP
//
//  Created by apple on 03/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingReviewCancellationVC: BaseVC {
    // MARK: - IB Outlet
    
    @IBOutlet var topNavBar: TopNavigationView!
    
    // refund View
    @IBOutlet var refundModeTitleLabel: UILabel!
    @IBOutlet var refundModeValueLabel: UILabel!
    @IBOutlet var requestCancellationButton: UIButton!
    
    // Cancellation View
    @IBOutlet var cancellationTitleLabel: UILabel!
    @IBOutlet var cancellationValueLabel: UILabel!
    @IBOutlet var commentTextView: PKTextView!
    
    @IBOutlet var totalNetRefundLabel: UILabel!
    @IBOutlet var refundAmountLabel: UILabel!
    
    @IBOutlet var infoLabel: UILabel!
    
    // MARK: - Override methods
    
    override func initialSetup() {
        self.requestCancellationButton.addGredient(isVertical: false)
        self.commentTextView.delegate = self
        self.commentTextView.placeholder = LocalizedString.EnterYourCommentOptional.localized
    }
    
    override func setupTexts() {
        self.requestCancellationButton.setTitle(LocalizedString.RequestCancellation.localized, for: .normal)
        self.requestCancellationButton.setTitle(LocalizedString.RequestCancellation.localized, for: .selected)
        self.refundModeTitleLabel.text = LocalizedString.RefundMode.localized
        self.refundModeValueLabel.text = LocalizedString.Select.localized
        self.totalNetRefundLabel.text = LocalizedString.TotalNetRefund.localized
        self.refundAmountLabel.text = "₹ 1,47,000"
        self.infoLabel.text = LocalizedString.ReviewCancellationInfoLabel.localized
        self.cancellationTitleLabel.text = LocalizedString.ReasonForCancellation.localized
        self.cancellationValueLabel.text = LocalizedString.Select.localized
    }
    
    override func setupFonts() {
        self.refundModeTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.refundModeValueLabel.font = AppFonts.Regular.withSize(18.0)
        self.totalNetRefundLabel.font = AppFonts.Regular.withSize(18.0)
        self.refundAmountLabel.font = AppFonts.Regular.withSize(18.0)
        self.requestCancellationButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        self.infoLabel.font = AppFonts.Regular.withSize(14.0)
        self.cancellationTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.cancellationValueLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.refundModeTitleLabel.textColor = AppColors.themeGray40
        self.refundModeValueLabel.textColor = AppColors.textFieldTextColor51
        self.requestCancellationButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.requestCancellationButton.setTitleColor(AppColors.themeWhite, for: .selected)
        self.totalNetRefundLabel.textColor = AppColors.themeBlack
        self.refundAmountLabel.textColor = AppColors.themeBlack
        self.infoLabel.textColor = AppColors.themeGray40
        self.cancellationTitleLabel.textColor = AppColors.themeGray40
        self.cancellationValueLabel.textColor = AppColors.themeBlack
    }
    
    override func setupNavBar() {
        self.topNavBar.configureNavBar(title: LocalizedString.ReviewCancellation.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: true)
        
        self.topNavBar.delegate = self
    }
    
    // MARK: - IBAction
    
    @IBAction func refundModeButtonTapped(_ sender: Any) {
        printDebug("refund mode button tapped")
    }
    
    @IBAction func refundCancellationButtonTapped(_ sender: Any) {
        printDebug("refund cancellation Button tapped")
    }
}

// MARK: - Top Navigation view Delegate methods

extension BookingReviewCancellationVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}
