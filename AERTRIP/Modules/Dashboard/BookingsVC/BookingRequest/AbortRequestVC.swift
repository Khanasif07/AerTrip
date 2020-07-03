//
//  AbortRequestVC.swift
//  AERTRIP
//
//  Created by apple on 17/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import IQKeyboardManager

class AbortRequestVC: BaseVC {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var confirmAbortButton: UIButton!
    @IBOutlet weak var addCommentTextView: IQTextView!
    @IBOutlet weak var abortRequestTitleLabel: UILabel!
    //@IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomDivider: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var confirmBtnBottomConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    let viewModel = AbortRequestVM()
//    var blankSpace: CGFloat {
//        return UIDevice.screenHeight - (confirmAbortButton.height + topNavView.height + 33.0)
//        //33 for title label n top space
//    }
    
    private var keyboardHeight: CGFloat = 0.0
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientView.addGredient(isVertical: false)
        addCommentTextView.layoutSubviews()
        if addCommentTextView.text.isEmpty {
            addCommentTextView.alignTextCenterVerticaly()
        }
        printDebug("addCommentTextView.size: \(addCommentTextView.size)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    // MARK:- Overide methods
    
    override func initialSetup() {
        addCommentTextView.placeholder = LocalizedString.EnterComments.localized
        self.view.backgroundColor = AppColors.themeWhite
        self.bottomView.backgroundColor = AppColors.themeGray04
        self.bottomDivider.backgroundColor = AppColors.divider.color
        confirmBtnBottomConstraint.constant = AppFlowManager.default.safeAreaInsets.bottom
        self.manageTextFieldHeight()
        addCommentTextView.layoutSubviews()
        self.view.layoutIfNeeded()
        self.gradientView.addGredient(isVertical: false)
        self.manageTextFieldHeight()
        
        
    }
    
    override func setupFonts() {
        self.confirmAbortButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        self.abortRequestTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.addCommentTextView.tintColor = AppColors.themeGreen
        self.addCommentTextView.font = AppFonts.Regular.withSize(18.0)
        self.addCommentTextView.delegate = self
    }
    
    override func setupTexts() {
        self.confirmAbortButton.setTitle(LocalizedString.ConfirmAbort.localized, for: .normal)
        self.confirmAbortButton.setTitle(LocalizedString.ConfirmAbort.localized, for: .selected)
        self.abortRequestTitleLabel.text = LocalizedString.AbortTitle.localized
        
        
    }
    
    override func setupColors() {
        self.confirmAbortButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.confirmAbortButton.setTitleColor(AppColors.themeWhite, for: .selected)
        self.abortRequestTitleLabel.textColor = AppColors.themeBlack
        self.addCommentTextView.placeholderTextColor = AppColors.themeGray20
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientView.addGredient(isVertical: false)
    }
    
    override func setupNavBar() {
        self.topNavView.navTitleLabel.textColor = AppColors.textFieldTextColor51
        self.topNavView.configureNavBar(title: LocalizedString.AbortThisRequest.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: true)
        self.topNavView.delegate = self
        
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
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
        
        let allOthersHeight: CGFloat = 130.0 + (AppFlowManager.default.safeAreaInsets.top + AppFlowManager.default.safeAreaInsets.bottom)
        let blankSpace: CGFloat = UIDevice.screenHeight - (allOthersHeight)

        var textHeight: CGFloat = 0.0
        
        if self.addCommentTextView.text.isEmpty {
            textHeight = 23
        }
        else {
            let value = (CGFloat(self.addCommentTextView.numberOfLines) * (self.addCommentTextView.font?.lineHeight ?? 20.0)) + 10.0
            textHeight = self.addCommentTextView.numberOfLines > 1 ? value : 23
        }
        
        var calculatedBlank: CGFloat = blankSpace - (textHeight)
        calculatedBlank = min(calculatedBlank, blankSpace)
        
        if calculatedBlank < self.keyboardHeight {
            calculatedBlank = self.keyboardHeight
        }
/*
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.bottomViewHeightConstraint.constant = calculatedBlank
            self?.view.layoutIfNeeded()
        }
 */
        
        if addCommentTextView.height < calculatedBlank {
            addCommentTextView.isScrollEnabled = false
        } else {
            addCommentTextView.isScrollEnabled = true
        }
        self.view.layoutIfNeeded()
        //printDebug("textHeight: \(textHeight)")
    }
    
    @IBAction func confirmAbortButtonTapped(_ sender: Any) {
        self.viewModel.makeRequestAbort()
    }
}


extension AbortRequestVC: AbortRequestVMDelegate {
    func willMakeRequestAbort() {
        AppGlobals.shared.startLoading()
    }
    
    func makeRequestAbortSuccess() {
        AppGlobals.shared.stopLoading()
        self.sendDataChangedNotification(data: ATNotification.myBookingCasesRequestStatusChanged)
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func makeRequestAbortFail() {
        AppGlobals.shared.stopLoading()
    }
}

// MARK: - Top Navigation View Delegate methods
extension AbortRequestVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}


// MARK: - UITextViewDelegate methods

extension AbortRequestVC {
    
    func textViewDidChange(_ textView: UITextView) {

        viewModel.comment = textView.text
        self.manageTextFieldHeight()
        
//        var calculatedH: CGFloat = CGFloat(self.addCommentTextView.numberOfLines) * (self.addCommentTextView.font?.lineHeight ?? 20.0)
//
//        calculatedH = max(calculatedH, 30.0)
//        calculatedH = min(calculatedH, self.blankSpace)
//
//        UIView.animate(withDuration: 0.2) { [weak self] in
//            self?.addCommentTextViewHeightConstraint.constant = calculatedH
//            self?.view.layoutIfNeeded()
//        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentString: NSString = textView.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
        
        return newString.length <= 500
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        addCommentTextView.isScrollEnabled = false
        self.view.layoutIfNeeded()
        addCommentTextView.isScrollEnabled = true
    }
}
