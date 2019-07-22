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
    let viewModel = BookingReviewCancellationVM()
    
    // MARK: - Override methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.statusBarStyle = .default
        self.statusBarColor = AppColors.themeBlack.withAlphaComponent(0.4)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.statusBarColor = AppColors.clear
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.viewModel.currentUsingAs == .flightCancellationReview {
             self.refundAmountLabel.text = self.viewModel.totRefundForFlight.delimiterWithSymbol
        } else if self.viewModel.currentUsingAs == .hotelCancellationReview {
           self.refundAmountLabel.text = self.viewModel.totalRefundForHotel.delimiterWithSymbol
        }
       
    }
    
    override func initialSetup() {
        self.requestCancellationButton.shouldShowPressAnimation = false
        self.commentTextView.delegate = self
        switch self.viewModel.currentUsingAs {
        case .flightCancellationReview, .hotelCancellationReview:
            self.commentTextView.placeholder = LocalizedString.EnterYourCommentOptional.localized
        case .specialRequest:
            self.cancellationReasonView.isHidden = true
            self.cancellationViewHeightConstraint.constant = 0.0
            self.totalNetRefundView.isHidden = true
            self.totalNetRefundViewHeightConstraint.constant = 0.0
        }
        
        self.refundModeTextField.delegate = self
        self.cancellationTextField.delegate = self
        self.commentTextView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)

        if self.viewModel.currentUsingAs == .specialRequest {
            //get the data for special request
            self.viewModel.getAllHotelSpecialRequest()
        }
        else {
            //get the data for cancellation request
            self.viewModel.getCancellationRefundModeReasons()
        }
    }
    
    override func setupTexts() {
        
        switch self.viewModel.currentUsingAs {
        case .flightCancellationReview, .hotelCancellationReview:
            if self.viewModel.currentUsingAs == .flightCancellationReview {
                self.requestCancellationButton.setTitle(LocalizedString.RequestCancellation.localized, for: .normal)
                self.requestCancellationButton.setTitle(LocalizedString.RequestCancellation.localized, for: .selected)
            }
            else {
                self.requestCancellationButton.setTitle(LocalizedString.ProcessCancellation.localized, for: .normal)
                self.requestCancellationButton.setTitle(LocalizedString.ProcessCancellation.localized, for: .selected)
            }
            self.refundModeTitleLabel.text = LocalizedString.RefundMode.localized
            self.refundModeTextField.text = LocalizedString.Select.localized
            self.totalNetRefundLabel.text = LocalizedString.TotalNetRefund.localized
            self.refundAmountLabel.text = self.viewModel.totRefundForFlight.delimiterWithSymbol
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
        switch self.viewModel.currentUsingAs {
        case .flightCancellationReview, .hotelCancellationReview:
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
            if self.viewModel.currentUsingAs == .specialRequest {
                self.viewModel.makeHotelSpecialRequest()
            }
            else {
                self.viewModel.makeCancellationRequest()
            }
        }
    }
}

// MARK: - Top Navigation view Delegate methods

extension BookingReviewCancellationVC: TopNavigationViewDelegate {
    
    func removeMe() {
        if self.viewModel.currentUsingAs == .specialRequest {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        self.removeMe()
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.removeMe()
    }
}

extension BookingReviewCancellationVC {
    
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel.comment = textView.text
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if self.viewModel.currentUsingAs == .specialRequest {
            PKMultiPicker.noOfComponent = 1
            PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: self.viewModel.specialRequests, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { (firstSelect, secondSelect) in
                textField.text = firstSelect
                self.viewModel.selectedSpecialRequest = firstSelect
            }
        }
        else {
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
        }
        return true
    }
}


extension BookingReviewCancellationVC: BookingReviewCancellationVMDelegate {
    func willMakeCancellationRequest() {
    }
    
    func makeCancellationRequestSuccess(caseData: Case?) {
        
        func sendAccordingToResolutionStatus(title: String, caseData: Case?) {
            if let caseD = caseData, ((caseD.resolutionStatus == .successfull) || (caseD.resolutionStatus == .resolved)) {
                AppFlowManager.default.showCancellationProcessed(buttonTitle: LocalizedString.RequestCancellation.localized, delegate: self)
            }
            else {
                AppFlowManager.default.showCancellationRequest(buttonTitle: LocalizedString.RequestCancellation.localized, delegate: self)
            }
        }
        
        if self.viewModel.currentUsingAs == .flightCancellationReview {
            sendAccordingToResolutionStatus(title: LocalizedString.RequestCancellation.localized, caseData: caseData)
        }
        else if self.viewModel.currentUsingAs == .hotelCancellationReview {
            sendAccordingToResolutionStatus(title: LocalizedString.RequestCancellation.localized, caseData: caseData)
        }
        else if self.viewModel.currentUsingAs == .specialRequest {
            AppFlowManager.default.showSpecialRequest(buttonTitle: LocalizedString.Request.localized, delegate: self)
        }
    }
    
    func makeCancellationRequestFail() {
        AppToast.default.showToastMessage(message: LocalizedString.SomethingWentWrong.localized)
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
        if self.viewModel.currentUsingAs == .specialRequest {
            self.dismiss(animated: true, completion: {
                self.sendDataChangedNotification(data: ATNotification.myBookingCasesRequestStatusChanged)
            })
        }
        else {
            self.navigationController?.dismiss(animated: true, completion: {
                self.sendDataChangedNotification(data: ATNotification.myBookingCasesRequestStatusChanged)
            })
        }
    }
}
