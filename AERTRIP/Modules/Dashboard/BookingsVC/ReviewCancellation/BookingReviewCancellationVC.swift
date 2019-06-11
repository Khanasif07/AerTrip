//
//  BookingReviewCancellationVC.swift
//  AERTRIP
//
//  Created by apple on 03/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingReviewCancellationVC: BaseVC {
    
    //MARK:- Enum
    enum UsingFor {
        case reviewCancellation
        case specialRequest
    }
    
    // MARK: - IB Outlet
    
    @IBOutlet weak var topNavBar: TopNavigationView!
    
    // refund View
    @IBOutlet weak var refundView: UIView!
    @IBOutlet weak var cancellationReasonView: UIView!
    @IBOutlet weak var refundViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancellationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var refundModeTitleLabel: UILabel!
    @IBOutlet weak var refundModeValueLabel: UILabel!
    @IBOutlet weak var requestCancellationButton: UIButton!
    
    // Cancellation View
    @IBOutlet weak var cancellationTitleLabel: UILabel!
    @IBOutlet weak var cancellationValueLabel: UILabel!
    @IBOutlet weak var commentTextView: PKTextView!
    @IBOutlet weak var totalNetRefundView: UIView!
    @IBOutlet weak var totalNetRefundViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalNetRefundLabel: UILabel!
    @IBOutlet weak var refundAmountLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    //MARK: - Variables
    var currentUsingAs = UsingFor.reviewCancellation
    
    // MARK: - Override methods
    
    override func initialSetup() {
        self.requestCancellationButton.addGredient(isVertical: false)
        self.commentTextView.delegate = self
//        self.currentUsingAs = .specialRequest
        switch currentUsingAs {
        case .reviewCancellation:
            self.commentTextView.placeholder = LocalizedString.EnterYourCommentOptional.localized
        case .specialRequest:
            self.cancellationReasonView.isHidden = true
            self.cancellationViewHeightConstraint.constant = 0.0
            self.totalNetRefundView.isHidden = true
            self.totalNetRefundViewHeightConstraint.constant = 0.0
        }
    }
    
    override func setupTexts() {
        
        switch currentUsingAs {
        case .reviewCancellation:
            self.requestCancellationButton.setTitle(LocalizedString.RequestCancellation.localized, for: .normal)
            self.requestCancellationButton.setTitle(LocalizedString.RequestCancellation.localized, for: .selected)
            self.refundModeTitleLabel.text = LocalizedString.RefundMode.localized
            self.refundModeValueLabel.text = LocalizedString.Select.localized
            self.totalNetRefundLabel.text = LocalizedString.TotalNetRefund.localized
            self.refundAmountLabel.text = "₹ 1,47,000"
            self.infoLabel.text = LocalizedString.ReviewCancellationInfoLabel.localized
            self.cancellationTitleLabel.text = LocalizedString.ReasonForCancellation.localized
            self.cancellationValueLabel.text = LocalizedString.Select.localized
        case .specialRequest:
            self.requestCancellationButton.setTitle(LocalizedString.Request.localized, for: .normal)
            self.requestCancellationButton.setTitle(LocalizedString.Request.localized, for: .selected)
            self.refundModeTitleLabel.text = LocalizedString.RequestType.localized
            self.refundModeValueLabel.text = LocalizedString.Select.localized
            self.infoLabel.text = LocalizedString.ReviewCancellationInfoLabel.localized
            self.commentTextView.placeholder = LocalizedString.WriteAboutYourSpecialRequest.localized
//            self.totalNetRefundLabel.text = LocalizedString.TotalNetRefund.localized
//            self.refundAmountLabel.text = "₹ 1,47,000"
//            self.cancellationTitleLabel.text = LocalizedString.ReasonForCancellation.localized
//            self.cancellationValueLabel.text = LocalizedString.Select.localized

        }
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
//        self.commentTextView.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.refundModeTitleLabel.textColor = AppColors.themeGray40
        self.refundModeValueLabel.textColor = AppColors.textFieldTextColor51
        self.requestCancellationButton.setTitleColor(AppColors.themeWhite.withAlphaComponent(0.5), for: .normal)
        self.requestCancellationButton.setTitleColor(AppColors.themeWhite.withAlphaComponent(0.5), for: .selected)
        self.totalNetRefundLabel.textColor = AppColors.themeBlack
        self.refundAmountLabel.textColor = AppColors.themeBlack
        self.infoLabel.textColor = AppColors.themeGray40
        self.cancellationTitleLabel.textColor = AppColors.themeGray40
        self.cancellationValueLabel.textColor = AppColors.themeBlack
    }
    
    override func setupNavBar() {
        switch self.currentUsingAs {
        case .reviewCancellation:
            self.topNavBar.configureNavBar(title: LocalizedString.ReviewCancellation.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: true)
        case .specialRequest:
            self.topNavBar.configureNavBar(title: LocalizedString.SpecialRequest.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
            self.topNavBar.firstRightButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
            self.topNavBar.firstRightButton.setTitleColor(AppColors.themeGreen, for: .normal)
        }
        self.topNavBar.delegate = self
    }
    
    // MARK: - IBAction
    
    @IBAction func refundModeButtonTapped(_ sender: Any) {
        printDebug("refund mode button tapped")
    }
    
    @IBAction func refundCancellationButtonTapped(_ sender: Any) {
        printDebug("refund cancellation Button tapped")
    }
    
    @IBAction func requestContinueButtonTapped(_ sender: UIButton) {
        printDebug("Request Continue Button Tapped")
    }
    
    
}

// MARK: - Top Navigation view Delegate methods

extension BookingReviewCancellationVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}
