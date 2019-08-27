//
//  ThankYouRegistrationVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 05/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import ActiveLabel
import SafariServices

class ThankYouRegistrationVC: BaseVC {

    //MARK:- Properties
    //MARK:-
    let viewModel = ThankYouRegistrationVM()
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var sentAccountLinkLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var checkEmailLabel: UILabel!
    @IBOutlet weak var openEmailAppButton: UIButton!
    @IBOutlet weak var noReplyLabel: UILabel!
    @IBOutlet weak var topNavBar: TopNavigationView!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func setupFonts() {
        
        self.headerTitleLabel.font = AppFonts.Bold.withSize(38)
        self.emailLabel.font = AppFonts.Regular.withSize(20)
        self.sentAccountLinkLabel.font = AppFonts.Regular.withSize(16)
        self.checkEmailLabel.font = AppFonts.Regular.withSize(16)
        self.openEmailAppButton.titleLabel?.font = AppFonts.SemiBold.withSize(18)
        
    }
    
    override func setupTexts() {
        
        if self.viewModel.type == .deeplinkResetPassword  || self.viewModel.type == .resetPassword {
            
            self.headerTitleLabel.text = LocalizedString.CheckYourEmail.localized
            self.sentAccountLinkLabel.text = LocalizedString.PasswordResetInstruction.localized
            self.checkEmailLabel.text = LocalizedString.CheckEmailToResetPassword.localized
            
            let attributedString = NSMutableAttributedString(string: LocalizedString.password_redset_link_message.localized, attributes: [
                .font: AppFonts.Regular.withSize(14),
                .foregroundColor: AppColors.themeGray60
                ])
            
            let range = (LocalizedString.password_redset_link_message.localized as NSString).range(of: LocalizedString.noreply_aertrip_com.localized)
            attributedString.addAttribute(.font, value: AppFonts.SemiBold.withSize(14), range: range)
            
            self.noReplyLabel.attributedText = attributedString
        } else {
            
            self.headerTitleLabel.text = LocalizedString.Thank_you_for_registering.localized
            self.sentAccountLinkLabel.text = LocalizedString.We_have_sent_you_an_account_activation_link_on.localized
            self.checkEmailLabel.text = LocalizedString.Check_your_email_to_activate_your_account.localized
            
            let attributedString = NSMutableAttributedString(string: LocalizedString.No_Reply_Email_Text.localized, attributes: [
                .font: AppFonts.Regular.withSize(14),
                .foregroundColor: AppColors.themeGray60
                ])
            
            let range = (LocalizedString.No_Reply_Email_Text.localized as NSString).range(of: LocalizedString.noreply_aertrip_com.localized)
            attributedString.addAttribute(.font, value: AppFonts.SemiBold.withSize(14), range: range)
            
            self.noReplyLabel.attributedText = attributedString
        }
    }
    
    override func setupColors() {
        
        self.headerTitleLabel.textColor     = AppColors.themeBlack
        self.sentAccountLinkLabel.textColor  = AppColors.themeBlack
        self.checkEmailLabel.textColor      = AppColors.themeBlack
        self.emailLabel.textColor         = AppColors.themeOrange
        self.openEmailAppButton.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    //MARK:- IBOutlets
    //MARK:-
    
    
    @IBAction func openEmailAppButtonAction(_ sender: UIButton) {
        let buttons = AppGlobals.shared.getPKAlertButtons(forTitles: [LocalizedString.Mail_Default.localized, LocalizedString.Gmail.localized], colors: [AppColors.themeGreen, AppColors.themeGreen])
        _ = PKAlertController.default.presentActionSheet(nil, message: nil, sourceView: self.view, alertButtons: buttons, cancelButton: AppGlobals.shared.pKAlertCancelButton, tapBlock: {(alert,index) in
            
//            AppFlowManager.default.moveToSecureAccountVC(isPasswordType: .setPassword)
//            return
            if index == 0 {
                
                guard let mailURL = URL(string: "message://") else {return}
                if UIApplication.shared.canOpenURL(mailURL) {
                    UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
                }
            } else if index == 1 {
                
                guard let mailURL = URL(string: "googlegmail://") else {return}
                if UIApplication.shared.canOpenURL(mailURL) {
                    UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
                    
                } else {
                    
                    guard let url = URL(string: "https://gmail.com") else {return}
                    let safariVC = SFSafariViewController(url: url)
                    self.present(safariVC, animated: true, completion: nil)
                    safariVC.delegate = self
                }
            }
            
        })
        
    }
}

//MARK:- Extension Initialsetups
//MARK:-
extension ThankYouRegistrationVC: SFSafariViewControllerDelegate {
    
    private func initialSetups() {
        AppGlobals.shared.updateIQToolBarDoneButton(isEnabled: false)
        self.view.backgroundColor = AppColors.screensBackground.color
        
        if self.viewModel.type ==  .deeplinkSetPassword || self.viewModel.type == .deeplinkResetPassword {
            
            self.viewModel.webserviceForGetRegistrationData()
        }
        
        self.topNavBar.configureNavBar(title: "", isDivider: false, backgroundType: .clear)
        topNavBar.delegate = self
    }
    
    private func linkSetupForTermsAndCondition(withLabel : ActiveLabel) {
        
        let noReplyEmail  = ActiveType.custom(pattern: "\\s\(LocalizedString.noreply_aertrip_com.localized)\\b")
        
        withLabel.enabledTypes = [noReplyEmail]
        withLabel.customize { (label) in
            
            label.text = LocalizedString.No_Reply_Email_Text.localized
            label.customColor[noReplyEmail] = AppColors.themeGray60
            label.customSelectedColor[noReplyEmail] = AppColors.themeGray60
            label.handleCustomTap(for: noReplyEmail) { element in
                
                AppFlowManager.default.moveToSecureAccountVC(isPasswordType: .setPassword, email: self.viewModel.email)
//                AppToast.default.showToastMessage(message: LocalizedString.We_have_sent_you_an_account_activation_link_on.localized, vc: self)
            }
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ThankYouRegistrationVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

//MARK:- Extension Initialsetups
//MARK:-
extension ThankYouRegistrationVC : ThankYouRegistrationVMDelegate {
    
    func willApiCall() {
        
    }
    
    func didGetSuccess() {
        printDebug("before comit")
        self.emailLabel.text = self.viewModel.email
        if self.viewModel.type == .deeplinkSetPassword {
            
            AppFlowManager.default.moveToSecureAccountVC(isPasswordType: .setPassword, email: self.viewModel.email, key: self.viewModel.refId)
            
        } else if self.viewModel.type == .deeplinkResetPassword {
            
            AppFlowManager.default.moveToSecureAccountVC(isPasswordType: .resetPasswod, email: self.viewModel.email, key: self.viewModel.refId, token: self.viewModel.token)
        }
    }
    
    func didGetFail(errors: ErrorCodes) {
        
    }
}
