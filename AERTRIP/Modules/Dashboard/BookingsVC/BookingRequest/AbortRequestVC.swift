//
//  AbortRequestVC.swift
//  AERTRIP
//
//  Created by apple on 17/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AbortRequestVC: BaseVC {

    //MARK: - IBOutlet
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var confirmAbortButton: UIButton!
    @IBOutlet weak var addCommentTextView: PKTextView!
    @IBOutlet weak var addCommentTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addCommentTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var abortRequestTitleLabel: UILabel!
    
    
    //MARK: - Variables
    let viewModel = AbortRequestVM()
    
    // MARK:- Overide methods
    
    override func initialSetup() {
    confirmAbortButton.addGredient(isVertical: false)
        addCommentTextView.placeholder = LocalizedString.EnterComments.localized
    
        
    }
    
    override func setupFonts() {
        self.confirmAbortButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
        self.abortRequestTitleLabel.font = AppFonts.Regular.withSize(14.0)
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
    }
    
    
    override func setupNavBar() {
        self.topNavView.navTitleLabel.textColor = AppColors.textFieldTextColor51
        self.topNavView.configureNavBar(title: LocalizedString.AbortThisRequest.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: true)
        self.topNavView.delegate = self
        
    }
    
    // MARK: - Override methods
    override func keyboardWillHide(notification: Notification) {
        //
    }
    
    override func keyboardWillShow(notification: Notification) {
        //
    }
    // MARK: - IBAction
    
    @IBAction func confirmAbortButtonTapped(_ sender: Any) {
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
        var numberOflines: Int = 1
        viewModel.comment = textView.text
        if let fontUnwrapped = self.addCommentTextView.font {
          numberOflines = Int(self.addCommentTextView.contentSize.height / fontUnwrapped.lineHeight)
        }
        if textView.text.isEmpty {
             self.addCommentTextViewHeightConstraint.constant = 30
        } else {
             self.addCommentTextViewHeightConstraint.constant = CGFloat(30 *  numberOflines / 2)
        }
       
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == " "{
            return false
        }
        return true
    }
 
}
