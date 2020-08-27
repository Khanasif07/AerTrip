//
//  BookingConfimationMailVC.swift
//  AERTRIP
//
//  Created by apple on 04/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Contacts
import ContactsUI
import UIKit
import IQKeyboardManager
import WSTagsField

class BookingConfimationMailVC: BaseVC {
    // MARK: - IB Outlet
    
    @IBOutlet weak var topNavigationView: TopNavigationView!
    @IBOutlet weak var toLabel: UILabel!
//    @IBOutlet weak var toMailTextView: ATEmailSelectorTextView!
    @IBOutlet weak var addEmailButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
//    @IBOutlet weak var toEmailTextViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var toEmailViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailContainerViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    let viewModel  = BookingConfirmationMailVM()
    let tagsField = WSTagsField()

    
    
    // MARK: - Override methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func initialSetup() {
        emailTextFieldHandlers()
        self.topNavigationView.delegate = self
//        self.toMailTextView.delegate = self
//        self.toMailTextView.textContainerInset = .zero
        self.viewModel.getTravellerMail()
        setupColors()
        self.tagsField.addTag(UserInfo.loggedInUser?.email ?? "")
//        self.toMailTextView.keyboardType = .emailAddress
        self.updateSendButton()
        if #available(iOS 13.0, *) {
            navigationViewHeightConstraint.constant = 56
        }
    }
    
    override func setupFonts() {
        self.toLabel.font = AppFonts.Regular.withSize(16.0)
//        self.toMailTextView.font = AppFonts.Regular.withSize(16.0)
        self.infoLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    override func setupTexts() {
        self.toLabel.text = LocalizedString.To.localized + ":"
        self.infoLabel.text = LocalizedString.BookingConfirmationInfo.localized
//        self.toMailTextView.placeholder = LocalizedString.EnterEmail.localized
    }
    
    override func setupColors() {
        self.toLabel.textColor = AppColors.themeGray40
//        self.toMailTextView.textColor = AppColors.themeGray40
        self.infoLabel.textColor = AppColors.themeGray40
        
//        self.toMailTextView.activeTagBackgroundColor = AppColors.clear
//        self.toMailTextView.inactiveTagFontColor = AppColors.themeGreen
//        self.toMailTextView.activeTagFontColor = AppColors.themeGreen
//        self.toMailTextView.tagSeparatorColor = AppColors.themeGreen
//        if #available(iOS 13, *) {
//        }else{
//            self.toMailTextView.placeholderTextColor = AppColors.themeGray40
//        }
    }
    
    override func setupNavBar() {
        self.topNavigationView.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.topNavigationView.navTitleLabel.textColor = AppColors.themeBlack
        self.topNavigationView.configureNavBar(title: LocalizedString.ConfirmationEmail.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        self.topNavigationView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.CancelWithSpace.localized, selectedTitle: LocalizedString.CancelWithSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.topNavigationView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.SendWithSpace.localized, selectedTitle: LocalizedString.SendWithSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    // MARK: - IB Action
    
    @IBAction func addEmailButtonTapped(_ sender: Any) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactEmailAddressesKey]
        self.present(contactPicker, animated: true, completion: nil)
    }
    
//    func updateHeightOfHeader(_ textView: ATEmailSelectorTextView) {
//        let minHeight = textView.font!.lineHeight * 1.0
//        let maxHeight = textView.font!.lineHeight * 6.0
//
//        var emailHeight = toMailTextView.text.sizeCount(withFont: textView.font!, bundingSize: CGSize(width: (UIDevice.screenWidth - 62.0), height: 10000.0)).height
//
//        emailHeight = max(minHeight, emailHeight)
//        emailHeight = min(maxHeight, emailHeight)
//
//        self.bottomView.frame = CGRect(x: 0, y: 108 + emailHeight, width: UIDevice.screenWidth, height: (UIDevice.screenHeight - 108 + emailHeight))
//
//        UIView.animate(withDuration: 0.3, animations: { [weak self] in
//            self?.toEmailTextViewHeightConstraint.constant = emailHeight
//        }, completion: { _ in
//
//        })
//    }
    
    func updateHeightOfHeader(_ headerHeight: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.emailContainerViewHeightConstraint.constant = headerHeight
        }, completion: { _ in
            
        })
    }
    
    private func updateSendButton(){
            
//            let mail = self.toMailTextView.text
//            let mailsArray = mail?.components(separatedBy: ",") ?? []
            let mailsArray = self.tagsField.tags.map { (tag) -> String in
                return tag.text
            }
            let emails = mailsArray.filter({ $0 != " " &&  $0 != ""})
            var isEmailValid = false
            for email in emails{
                isEmailValid = email.trimmingCharacters(in: .whitespacesAndNewlines).checkValidity(.Email)
                if !isEmailValid{
                    self.topNavigationView.firstRightButton.isEnabled = false
                    self.topNavigationView.firstRightButton.setTitleColor(AppColors.themeGray40, for: .normal)
                    return
                }
            }
            
            if !isEmailValid {
                
    //            self.email.checkValidity(.Email)
                self.topNavigationView.firstRightButton.isEnabled = false
                self.topNavigationView.firstRightButton.setTitleColor(AppColors.themeGray40, for: .normal)
            }else{
               self.topNavigationView.firstRightButton.isEnabled = true
                self.topNavigationView.firstRightButton.setTitleColor(AppColors.themeGreen, for: .normal)
            }
            
        }
    
   private func emailTextFieldHandlers() {
        self.tagsField.frame = self.emailContainerView.bounds
        self.tagsField.font = AppFonts.Regular.withSize(16.0)
        self.tagsField.placeholder = LocalizedString.EnterEmail.localized
        self.tagsField.placeholderColor = AppColors.themeGray40
        self.tagsField.textField.keyboardType = .emailAddress
        
        tagsField.layoutMargins = UIEdgeInsets(top: 1, left: 5, bottom: 1, right: 5)
        tagsField.contentInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2) //old padding
        tagsField.spaceBetweenLines = 4
        tagsField.spaceBetweenTags = 4
        tagsField.tintColor = .clear
        tagsField.textColor = AppColors.themeGreen
        tagsField.selectedColor = AppColors.themeGreen
        tagsField.selectedTextColor = AppColors.themeWhite
        tagsField.delimiter = ","
        tagsField.isDelimiterVisible = false
        tagsField.borderWidth = 1
        tagsField.borderColor = AppColors.themeGreen
        tagsField.textField.textColor = AppColors.themeBlack
        tagsField.acceptTagOption = [.comma, .return, .space]
        
        self.emailContainerView.addSubview(self.tagsField)
        
        tagsField.onDidChangeHeightTo = { [weak self] (_, height) in
            printDebug("HeightTo: \( height)")
            self?.updateHeightOfHeader(height)
        }

        tagsField.onValidateTag = { tag, tags in
            // custom validations, called before tag is added to tags list
            return  tag.text.checkValidity(.Email)
        }
        
        tagsField.onDidAddTag = { [weak self] (field, tag) in
            printDebug("onDidAddTag \(tag.text)")
            self?.updateSendButton()
        }
        
        tagsField.onDidRemoveTag = { [weak self] (field, tag) in
            printDebug("onDidRemoveTag \(tag.text)")
            self?.updateSendButton()
        }
        
    }
}

// MARK: - Top Navigation View Delegate methods

extension BookingConfimationMailVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        printDebug("Cancel Button tapped")
        dismiss(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        printDebug("send button Tapped")
        printDebug("Send mail")
        self.view.endEditing(true)
//        let mail = self.toMailTextView.text
//        let mailsArray = mail?.components(separatedBy: ",") ?? []
        let mailsArray = self.tagsField.tags.map { (tag) -> String in
            return tag.text
        }
        self.viewModel.addedEmail = mailsArray.filter({ $0 != " " })
        if self.viewModel.addedEmail.contains("") {
           AppToast.default.showToastMessage(message: LocalizedString.PleaseEnterEmail.localized)
        } else {
            if self.viewModel.token.isEmpty {
                self.viewModel.getTravellerMail()
            } else {
              self.viewModel.sendConfirmationMail()
            }
        }
    }
}

// MARK: -

// MARK: Contact picker Delegate methods

extension BookingConfimationMailVC: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        picker.dismiss(animated: true, completion: nil)
        if let _mail = contact.emailAddresses.first?.value as String? {
            printDebug("mail is \(_mail)")
            self.tagsField.addTag(_mail)
//            self.toMailTextView.text.append(_mail)
//            self.toMailTextView.layoutIfNeeded()
//            self.updateHeightOfHeader(self.toMailTextView)
        } else {
            AppToast.default.showToastMessage(message: LocalizedString.UnableToGetMail.localized, title: "", onViewController: self, duration: 0.6)
        }
    }
}

// MARK: - To Email text view Deleagte methods

extension BookingConfimationMailVC {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       // self.updateHeightOfHeader(self.toMailTextView)
        
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        delay(seconds: 0.2) {[weak self] in
            self?.updateSendButton()
        }
    }
}
