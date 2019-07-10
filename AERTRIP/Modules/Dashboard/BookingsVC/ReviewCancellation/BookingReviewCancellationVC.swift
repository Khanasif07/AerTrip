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
    @IBOutlet weak var refundModeTextField: UITextField!
    @IBOutlet weak var requestCancellationButton: ATButton!
    
    // Cancellation View
    @IBOutlet weak var cancellationTitleLabel: UILabel!
    @IBOutlet weak var cancellationTextField: UITextField!
    @IBOutlet weak var commentTextView: PKTextView!
    @IBOutlet weak var totalNetRefundView: UIView!
    @IBOutlet weak var totalNetRefundViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalNetRefundLabel: UILabel!
    @IBOutlet weak var refundAmountLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    //MARK: - Variables
    var currentUsingAs = UsingFor.reviewCancellation
    let viewModel = BookingReviewCancellationVM()
    
    // MARK: - Override methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.refundAmountLabel.text = self.viewModel.totRefund.delimiterWithSymbol
    }
    
    override func initialSetup() {
//        self.requestCancellationButton.addGredient(isVertical: false)
        self.requestCancellationButton.shouldShowPressAnimation = false
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
        
        self.refundModeTextField.delegate = self
        self.cancellationTextField.delegate = self
        
        self.viewModel.getCancellationRefundModeReasons()
    }
    
    override func setupTexts() {
        
        switch currentUsingAs {
        case .reviewCancellation:
            self.requestCancellationButton.setTitle(LocalizedString.RequestCancellation.localized, for: .normal)
            self.requestCancellationButton.setTitle(LocalizedString.RequestCancellation.localized, for: .selected)
            self.refundModeTitleLabel.text = LocalizedString.RefundMode.localized
            self.refundModeTextField.text = LocalizedString.Select.localized
            self.totalNetRefundLabel.text = LocalizedString.TotalNetRefund.localized
            self.refundAmountLabel.text = self.viewModel.totRefund.delimiterWithSymbol
            self.infoLabel.text = LocalizedString.ReviewCancellationInfoLabel.localized
            self.cancellationTitleLabel.text = LocalizedString.ReasonForCancellation.localized
            self.cancellationTextField.text = LocalizedString.Select.localized
        case .specialRequest:
            self.requestCancellationButton.setTitle(LocalizedString.Request.localized, for: .normal)
            self.requestCancellationButton.setTitle(LocalizedString.Request.localized, for: .selected)
            self.refundModeTitleLabel.text = LocalizedString.RequestType.localized
            self.refundModeTextField.text = LocalizedString.Select.localized
            self.infoLabel.text = LocalizedString.ReviewCancellationInfoLabel.localized
            self.commentTextView.placeholder = LocalizedString.WriteAboutYourSpecialRequest.localized
        }
    }
    
    override func setupFonts() {
        self.refundModeTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.refundModeTextField.font = AppFonts.Regular.withSize(18.0)
        self.totalNetRefundLabel.font = AppFonts.Regular.withSize(18.0)
        self.refundAmountLabel.font = AppFonts.Regular.withSize(18.0)
        self.requestCancellationButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        self.infoLabel.font = AppFonts.Regular.withSize(14.0)
        self.cancellationTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.cancellationTextField.font = AppFonts.Regular.withSize(18.0)
        //        self.commentTextView.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.refundModeTitleLabel.textColor = AppColors.themeGray40
        self.refundModeTextField.textColor = AppColors.textFieldTextColor51
        self.requestCancellationButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.requestCancellationButton.setTitleColor(AppColors.themeWhite, for: .selected)
        self.totalNetRefundLabel.textColor = AppColors.themeBlack
        self.refundAmountLabel.textColor = AppColors.themeBlack
        self.infoLabel.textColor = AppColors.themeGray40
        self.cancellationTitleLabel.textColor = AppColors.themeGray40
        self.cancellationTextField.textColor = AppColors.themeBlack
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
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    // MARK: - IBAction
    @IBAction func requestContinueButtonTapped(_ sender: UIButton) {
        if self.viewModel.isUserDataVerified {
            self.viewModel.makeCancellationRequest()
        }
    }
}

// MARK: - Top Navigation view Delegate methods

extension BookingReviewCancellationVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BookingReviewCancellationVC {
    
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel.comment = textView.text
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === refundModeTextField {
            PKMultiPicker.noOfComponent = 1
            PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: self.viewModel.refundModes, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { (firstSelect, secondSelect) in
                textField.text = firstSelect
                self.viewModel.selectedMode = firstSelect
            }
        }
        else {
            PKMultiPicker.noOfComponent = 1
            PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: self.viewModel.cancellationReasons, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { (firstSelect, secondSelect) in
                textField.text = firstSelect
                self.viewModel.selectedReason = firstSelect
            }
        }
        return true
    }
}


extension BookingReviewCancellationVC: BookingReviewCancellationVMDelegate {
    func willMakeCancellationRequest() {
    }
    
    func makeCancellationRequestSuccess() {
        AppFlowManager.default.showCancellationRequest(buttonTitle: LocalizedString.RequestCancellation.localized, delegate: self)
    }
    
    func makeCancellationRequestFail() {
    }
    
    func willGetCancellationRefundModeReasons() {
    }
    
    func getCancellationRefundModeReasonsSuccess() {
        if !self.viewModel.userRefundMode.isEmpty {
            self.refundModeTextField.text = self.viewModel.userRefundMode.capitalizedFirst()
        }
    }
    
    func getCancellationRefundModeReasonsFail() {
    }
}

extension BookingReviewCancellationVC: BulkEnquirySuccessfulVCDelegate{
    func doneButtonAction() {
        self.navigationController?.dismiss(animated: true, completion: {
            self.sendDataChangedNotification(data: ATNotification.myBookingCasesRequestStatusChanged)
        })
    }
}
