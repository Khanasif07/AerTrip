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
    
    @IBOutlet weak var refundViewTextFieldTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var refundViewDownArrowTrailingConstraint: NSLayoutConstraint!
    
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
    

    
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    //MARK: - Variables
    let viewModel = BookingReviewCancellationVM()
    private var keyboardHeight: CGFloat = 0.0

    // MARK: - Override methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.commentTextView.delegate = self

        
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
        switch self.viewModel.currentUsingAs {
        case .flightCancellationReview, .hotelCancellationReview:
            self.commentTextView.placeholder = LocalizedString.EnterYourCommentOptional.localized
            self.commentTextView.placeholderInsets = UIEdgeInsets(top: 4.0, left: 0.0, bottom: 0.0, right: 0.0)
        case .specialRequest:
            self.cancellationReasonView.isHidden = true
            self.cancellationViewHeightConstraint.constant = 0.0
            self.totalNetRefundView.isHidden = true
            self.totalNetRefundViewHeightConstraint.constant = 0.0
            self.commentTextView.placeholderInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 0.0, right: 0.0)
        }
        
        self.refundModeTextField.delegate = self
        self.cancellationTextField.delegate = self
        self.refundModeTextField.tintColor = AppColors.themeWhite.withAlphaComponent(0.01)
        self.cancellationTextField.tintColor = AppColors.themeWhite.withAlphaComponent(0.01)

        if self.viewModel.currentUsingAs == .specialRequest {
            //get the data for special request
            self.viewModel.getAllHotelSpecialRequest()
        }
        else {
            //get the data for cancellation request
            self.viewModel.getCancellationRefundModeReasons()
        }
        self.manageTextFieldHeight()
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
        self.manageContinueButton()

        self.totalNetRefundLabel.textColor = AppColors.themeBlack
        self.refundAmountLabel.textColor = AppColors.themeBlack
        self.infoLabel.textColor = AppColors.themeGray40
        self.cancellationTitleLabel.textColor = AppColors.themeGray40
        self.cancellationTextField.textColor = AppColors.themeBlack
    }
    
    // MARK: - Override methods
    override func keyboardWillHide(notification: Notification) {
        self.keyboardHeight = 0.0
        self.manageTextFieldHeight()
    }
    
    
    override func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.size.height
            self.manageTextFieldHeight()
            printDebug("keyboard height is \(self.keyboardHeight)")
        }
    }
    // MARK: - IBAction
    private func manageTextFieldHeight() {
        var allOthersHeight: CGFloat = 0.0
        if self.viewModel.currentUsingAs == .flightCancellationReview || self.viewModel.currentUsingAs == .hotelCancellationReview {
            allOthersHeight =  UIDevice.isIPhoneX ?  320 + 50 : 320
        } else {
            allOthersHeight = UIDevice.isIPhoneX ?  206 + 50 : 206
        }
        let blankSpace: CGFloat = UIDevice.screenHeight - (allOthersHeight)
        
        var textHeight: CGFloat = 0.0
        
        if self.commentTextView.text.isEmpty {
            textHeight = 34.0
        }
        else {
            textHeight = (CGFloat(self.commentTextView.numberOfLines) * (self.commentTextView.font?.lineHeight ?? 20.0)) + 14.0
        }
        
        var calculatedBlank: CGFloat = blankSpace - (textHeight)
        calculatedBlank = min(calculatedBlank, blankSpace)
        
        if calculatedBlank < self.keyboardHeight {
            calculatedBlank = self.keyboardHeight
        }
        
        self.bottomViewHeightConstraint.constant = calculatedBlank
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    override func setupNavBar() {
        switch self.viewModel.currentUsingAs {
        case .flightCancellationReview, .hotelCancellationReview:
            self.topNavBar.configureNavBar(title: LocalizedString.ReviewCancellation.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: true)
        case .specialRequest:
            self.topNavBar.configureNavBar(title: LocalizedString.SpecialRequest.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
            self.topNavBar.firstRightButton.setTitle(LocalizedString.CancelWithRightSpace.localized, for: .normal)
            self.topNavBar.firstRightButton.setTitleColor(AppColors.themeGreen, for: .normal)
        }
        self.topNavBar.delegate = self
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    // MARK: - IBAction
    @IBAction func requestContinueButtonTapped(_ sender: UIButton) {
        if self.viewModel.isUserDataVerified(showMessage: true) {
            if self.viewModel.currentUsingAs == .specialRequest {
                self.viewModel.makeHotelSpecialRequest()
            }
            else {
                self.viewModel.makeCancellationRequest()
            }
        }
    }
    
    
    // MARK: - Helpe methods
    private func manageContinueButton() {
        
        // if want to manage the button enable/disable state then uncomment the Code 2 and comment Code 1

        //CODE 1
        self.requestCancellationButton.setTitleColor(AppColors.themeWhite.withAlphaComponent(1.0), for: .normal)
        self.requestCancellationButton.isUserInteractionEnabled = true
        
        
        //CODE 2
//        if self.viewModel.isUserDataVerified(showMessage: false) {
//            self.requestCancellationButton.setTitleColor(AppColors.themeWhite.withAlphaComponent(1.0), for: .normal)
//            self.requestCancellationButton.isUserInteractionEnabled = true
//        } else {
//            self.requestCancellationButton.setTitleColor(AppColors.themeWhite.withAlphaComponent(0.5), for: .normal)
//            self.requestCancellationButton.isUserInteractionEnabled = false
//        }
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
        self.manageTextFieldHeight()
    }
    
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            
            
            if self.viewModel.currentUsingAs == .specialRequest {
                PKMultiPicker.noOfComponent = 1
                if self.viewModel.specialRequests.isEmpty {
                    
                    AppToast.default.showToastMessage(message: LocalizedString.NoInternet.localized)
                    return false
                } else {
                    PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: self.viewModel.specialRequests, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { (firstSelect, secondSelect) in
                        textField.text = firstSelect
                        self.viewModel.selectedSpecialRequest = firstSelect
                self.manageContinueButton()

                    }

                }
               
            }
            else {
                if textField === refundModeTextField {
                    PKMultiPicker.noOfComponent = 1
                    if self.viewModel.refundModes.isEmpty {
                         AppToast.default.showToastMessage(message: LocalizedString.NoInternet.localized)
                         return false
                    } else {
                        PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: self.viewModel.refundModes, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { (firstSelect, secondSelect) in
                            textField.text = firstSelect
                            self.viewModel.selectedMode = firstSelect
                            self.manageContinueButton()

                        }
                  
                    }
                    
                }
                else {
                    PKMultiPicker.noOfComponent = 1
                    if self.viewModel.cancellationReasons.isEmpty {
                     AppToast.default.showToastMessage(message: LocalizedString.NoInternet.localized)
                     return false
                    } else {
                        PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: self.viewModel.cancellationReasons, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { (firstSelect, secondSelect) in
                            textField.text = firstSelect
                            self.viewModel.selectedReason = firstSelect
                    self.manageContinueButton()

                        }
                    }
                   
                }
            }
            return true
        }
}


extension BookingReviewCancellationVC: BookingReviewCancellationVMDelegate {
    func willMakeCancellationRequest() {
        self.requestCancellationButton.isLoading = true
    }
    
    func makeCancellationRequestSuccess(caseData: Case?) {
        self.requestCancellationButton.isLoading = true
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
        self.requestCancellationButton.isLoading = true
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


extension BookingReviewCancellationVC {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard range.location == 0 else {
            return true
        }
        self.manageContinueButton()
        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: .whitespacesAndNewlines).location != 0
    }
}
