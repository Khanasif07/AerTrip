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
    @IBOutlet weak var gradientView: UIView!
    
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
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentPlaceholderLbl: UILabel!
    
    @IBOutlet weak var totalNetRefundView: UIView!
    @IBOutlet weak var totalNetRefundViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalNetRefundLabel: UILabel!
    @IBOutlet weak var refundAmountLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancellationReasonDivider: ATDividerView!
    @IBOutlet weak var refundModeDivider: ATDividerView!
    @IBOutlet weak var commectSeparator: ATDividerView!
    
    
    
    //MARK: - Variables
    let viewModel = BookingReviewCancellationVM()
    private var keyboardHeight: CGFloat = 0.0
    var presentingStatusBarStyle: UIStatusBarStyle = .darkContent, dismissalStatusBarStyle: UIStatusBarStyle = .darkContent

    // MARK: - Override methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.commentTextView.delegate = self
        statusBarStyle = presentingStatusBarStyle
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusBarStyle = dismissalStatusBarStyle
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
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
        self.requestCancellationButton.isShadowColorNeeded = true
        self.requestCancellationButton.shouldShowPressAnimation = false
        self.requestCancellationButton.shadowColor = AppColors.clear
        self.commentPlaceholderLbl.textColor = AppColors.themeGray20
        self.commentPlaceholderLbl.font = AppFonts.Regular.withSize(18)
        self.commentTextView.font = AppFonts.Regular.withSize(18)
        switch self.viewModel.currentUsingAs {
        case .flightCancellationReview, .hotelCancellationReview:
            self.commentPlaceholderLbl.text = LocalizedString.EnterYourCommentOptional.localized

        case .specialRequest:
            self.cancellationReasonView.isHidden = true
            self.cancellationViewHeightConstraint.constant = 0.0
            self.totalNetRefundView.isHidden = true
            self.totalNetRefundViewHeightConstraint.constant = 0.0
            self.requestCancellationButton.alpha = 0.6

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
        self.gradientView.addGredient(isVertical: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
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
            self.commentPlaceholderLbl.text = LocalizedString.WriteAboutYourSpecialRequest.localized
        }
    }
    
    override func setupFonts() {
        self.refundModeTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.refundModeTextField.font = AppFonts.Regular.withSize(18.0)
        self.totalNetRefundLabel.font = AppFonts.Regular.withSize(18.0)
        self.refundAmountLabel.font = AppFonts.Regular.withSize(18.0)
        self.infoLabel.font = AppFonts.Regular.withSize(14.0)
        self.cancellationTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.cancellationTextField.font = AppFonts.Regular.withSize(18.0)
        self.requestCancellationButton.setTitleFont(font: AppFonts.SemiBold.withSize(20.0), for: .normal)
        self.requestCancellationButton.setTitleFont(font: AppFonts.SemiBold.withSize(20.0), for: .selected)
        self.requestCancellationButton.setTitleFont(font: AppFonts.SemiBold.withSize(20.0), for: .highlighted)
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
            allOthersHeight = 296.0 + (AppFlowManager.default.safeAreaInsets.top + AppFlowManager.default.safeAreaInsets.bottom)
        } else {
            allOthersHeight = 195.0 + (AppFlowManager.default.safeAreaInsets.top + AppFlowManager.default.safeAreaInsets.bottom)
        }
        let blankSpace: CGFloat = UIDevice.screenHeight - (allOthersHeight)
        
        var textHeight: CGFloat = 0.0
        
        if self.commentTextView.text.isEmpty {
            if UIDevice.isIPhoneX{
                textHeight = 36.0
            }else{
                textHeight = 45.0
            }
            commentTextView.frame.size.height = textHeight
            
        }
        else {
            let txtViewHt = (CGFloat(self.commentTextView.numberOfLines) * (self.commentTextView.font?.lineHeight ?? 20.0)) + 14.0
            textHeight = max(txtViewHt, textHeight)
        }
        
        var calculatedBlank: CGFloat = blankSpace - (textHeight)
        calculatedBlank = min(calculatedBlank, blankSpace)
        
        if calculatedBlank < self.keyboardHeight {
            calculatedBlank = self.keyboardHeight
        }
        
        self.bottomViewHeightConstraint.constant = calculatedBlank
//        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self.view.layoutIfNeeded()
//        })
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
        }else{
            if self.viewModel.currentUsingAs == .specialRequest{
                if self.viewModel.selectedSpecialRequest.isEmpty || self.viewModel.selectedSpecialRequest.lowercased() == LocalizedString.Select.localized.lowercased() {
                    self.setErrorForSelectMode(isError: true)
                }
                if self.viewModel.comment.isEmpty || self.viewModel.comment.lowercased() == LocalizedString.Select.localized.lowercased() {
                    self.commectSeparator.isSettingForErrorState = true
                }
            }else{
                if self.viewModel.selectedMode.isEmpty || self.viewModel.selectedMode.lowercased() == LocalizedString.Select.localized.lowercased(){
                    self.setErrorForSelectMode(isError: true)
                }
                if self.viewModel.selectedReason.isEmpty || self.viewModel.selectedReason.lowercased() == LocalizedString.Select.localized.localized{
                    self.setErrorForCancellationReason(isError: true)
                }
            }
            
        }
    }
    
    
    func setErrorForSelectMode(isError:Bool){
        self.refundModeDivider.isSettingForErrorState = isError
//        self.refundModeTextField.textColor = isError ? AppColors.themeRed : AppColors.themeBlack
    }
    
    func setErrorForCancellationReason(isError:Bool){
        self.cancellationReasonDivider.isSettingForErrorState = isError
//        self.cancellationTextField.textColor = isError ? AppColors.themeRed : AppColors.themeBlack
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
        commentPlaceholderLbl.isHidden = !textView.text.isEmpty
        if !textView.text.isEmpty && viewModel.selectedSpecialRequest != LocalizedString.Select.localized {
            requestCancellationButton.alpha = 1
        } else {
            requestCancellationButton.alpha = 0.6
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.commectSeparator.isSettingForErrorState = false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        if self.viewModel.currentUsingAs == .specialRequest {
            PKMultiPicker.noOfComponent = 1
            if self.viewModel.specialRequests.count == 1 {
                AppToast.default.showToastMessage(message: LocalizedString.NoInternet.localized)
                return false
            } else {
                self.setErrorForSelectMode(isError: false)
                PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: self.viewModel.specialRequests, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { [unowned self]  (firstSelect, secondSelect) in
                    textField.text = firstSelect
                    self.viewModel.selectedSpecialRequest = firstSelect
                    if firstSelect != LocalizedString.Select.localized && !viewModel.comment.isEmpty {
                        requestCancellationButton.alpha = 1
                    } else {
                        requestCancellationButton.alpha = 0.6
                    }
                    self.manageContinueButton()
                    
                }
                
            }
            
        }
        else {
            if textField === refundModeTextField {
                self.setErrorForSelectMode(isError: false)
                PKMultiPicker.noOfComponent = 1
                if self.viewModel.refundModes.count == 1 {
                    AppToast.default.showToastMessage(message: LocalizedString.NoInternet.localized)
                    return false
                } else {
                    PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: self.viewModel.refundModes, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { [unowned self]  (firstSelect, secondSelect) in
                        textField.text = firstSelect
                        self.viewModel.selectedMode = firstSelect
                        self.manageContinueButton()
                        
                    }
                    
                }
                
            }
            else {
                self.setErrorForCancellationReason(isError: false)
                PKMultiPicker.noOfComponent = 1
                if self.viewModel.cancellationReasons.count == 1  {
                    AppToast.default.showToastMessage(message: LocalizedString.NoInternet.localized)
                    return false
                } else {
                    PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: self.viewModel.cancellationReasons, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { [unowned self]  (firstSelect, secondSelect) in
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
        self.requestCancellationButton.isLoading = false
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
