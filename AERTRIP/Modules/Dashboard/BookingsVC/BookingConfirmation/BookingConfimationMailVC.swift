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

class BookingConfimationMailVC: BaseVC {
    // MARK: - IB Outlet
    
    @IBOutlet var topNavigationView: TopNavigationView!
    @IBOutlet var toLabel: UILabel!
    @IBOutlet var toMailTextView: ATEmailSelectorTextView!
    @IBOutlet var addEmailButton: UIButton!
    @IBOutlet var infoLabel: UILabel!
    
    @IBOutlet var toEmailTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var toEmailViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var emailTextViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var bottomView: UIView!
    
    // MARK: - Properties
    let viewModel  = BookingConfirmationMailVM()
    
    
    
    // MARK: - Override methods
    
    override func initialSetup() {
        self.topNavigationView.delegate = self
        self.toMailTextView.delegate = self
        self.toMailTextView.textContainerInset = .zero
        self.viewModel.getTravellerMail()
        
    }
    
    override func setupFonts() {
        self.toLabel.font = AppFonts.Regular.withSize(16.0)
        self.toMailTextView.font = AppFonts.Regular.withSize(16.0)
        self.infoLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    override func setupTexts() {
        self.toLabel.text = LocalizedString.To.localized + ":"
        self.infoLabel.text = LocalizedString.BookingConfirmationInfo.localized
    }
    
    override func setupColors() {
        self.toLabel.textColor = AppColors.themeGray40
        self.toMailTextView.textColor = AppColors.themeGray40
        self.infoLabel.textColor = AppColors.themeGray40
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
    
    func updateHeightOfHeader(_ textView: ATEmailSelectorTextView) {
        let minHeight = textView.font!.lineHeight * 1.0
        let maxHeight = textView.font!.lineHeight * 6.0
        
        var emailHeight = toMailTextView.text.sizeCount(withFont: textView.font!, bundingSize: CGSize(width: (UIDevice.screenWidth - 62.0), height: 10000.0)).height
        
        emailHeight = max(minHeight, emailHeight)
        emailHeight = min(maxHeight, emailHeight)
        
        self.bottomView.frame = CGRect(x: 0, y: 108 + emailHeight, width: UIDevice.screenWidth, height: (UIDevice.screenHeight - 108 + emailHeight))
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.toEmailTextViewHeightConstraint.constant = emailHeight
        }, completion: { _ in
            
        })
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
        self.viewModel.sendConfirmationMail()
    }
}

// MARK: -

// MARK: Contact picker Delegate methods

extension BookingConfimationMailVC: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        picker.dismiss(animated: true, completion: nil)
        if let _mail = contact.emailAddresses.first?.value as String? {
            printDebug("mail is \(_mail)")
            self.toMailTextView.text.append(_mail)
            self.toMailTextView.layoutIfNeeded()
            self.updateHeightOfHeader(self.toMailTextView)
        } else {
            AppToast.default.showToastMessage(message: LocalizedString.UnableToGetMail.localized, title: "", onViewController: self, duration: 0.6, buttonTitle: "", buttonImage: nil)
        }
    }
}

// MARK: - To Email text view Deleagte methods

extension BookingConfimationMailVC {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.updateHeightOfHeader(self.toMailTextView)
        
        return true
    }
}
