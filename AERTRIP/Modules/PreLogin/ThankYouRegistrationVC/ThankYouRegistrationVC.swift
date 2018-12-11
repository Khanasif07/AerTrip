//
//  ThankYouRegistrationVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 05/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import ActiveLabel

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
    @IBOutlet weak var noReplyLabel: ActiveLabel!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.viewModel.webserviceForGetRegistrationData()
        self.initialSetups()
    }
    
    override func setupFonts() {
        
        self.headerTitleLabel.font = AppFonts.Bold.withSize(38)
        self.emailLabel.font = AppFonts.Regular.withSize(20)
        self.sentAccountLinkLabel.font = AppFonts.Regular.withSize(16)
        
        let attributedString = NSMutableAttributedString(string: LocalizedString.No_Reply_Email_Text.localized, attributes: [
            .font: AppFonts.Regular.withSize(14),
            .foregroundColor: AppColors.themeGray60
            ])
        attributedString.addAttribute(.font, value: AppFonts.SemiBold.withSize(14), range: NSRange(location: 128, length: 19))
        self.noReplyLabel.attributedText = attributedString
    }
    
    override func setupTexts() {
        
        self.headerTitleLabel.text = LocalizedString.Thank_you_for_registering.localized
        self.sentAccountLinkLabel.text = LocalizedString.We_have_sent_you_an_account_activation_link_on.localized
        self.checkEmailLabel.text = LocalizedString.Check_your_email_to_activate_your_account.localized
        self.noReplyLabel.text = LocalizedString.No_Reply_Email_Text.localized
    }
    
    override func setupColors() {
        
        self.headerTitleLabel.textColor     = AppColors.themeBlack
        self.sentAccountLinkLabel.textColor  = AppColors.themeBlack
        self.checkEmailLabel.textColor      = AppColors.themeBlack
        self.noReplyLabel.textColor        = AppColors.themeBlack
        self.emailLabel.textColor         = AppColors.themeOrange
        self.openEmailAppButton.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func openEmailAppButtonAction(_ sender: UIButton) {
        
      let action =   AKAlertController.actionSheet( nil, message: nil, sourceView: self.view, buttons: [LocalizedString.Mail_Default.localized,LocalizedString.Gmail.localized], tapBlock: {(alert,index) in
        
        if index == 0 {
            
            let mailURL = URL(string: "message://")!
            if UIApplication.shared.canOpenURL(mailURL) {
                UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
            }
        } else {
            
        }
            
        })
    
    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension ThankYouRegistrationVC {
    
    func initialSetups() {
        
        self.emailLabel.text = self.viewModel.email
        self.linkSetupForTermsAndCondition(withLabel: self.noReplyLabel)
    }
    
    func linkSetupForTermsAndCondition(withLabel : ActiveLabel) {
        
        let noReplyEmail  = ActiveType.custom(pattern: "\\s\(LocalizedString.noreply_aertrip_com.localized)\\b")
        
        withLabel.enabledTypes = [noReplyEmail]
        withLabel.customize { (label) in
            
            label.text = LocalizedString.No_Reply_Email_Text.localized
            label.customColor[noReplyEmail] = AppColors.themeGray60
            label.customSelectedColor[noReplyEmail] = AppColors.themeGray60
            label.handleCustomTap(for: noReplyEmail) { element in
                
                AppFlowManager.default.moveToSecureAccountVC(isPasswordType: .resetPasswod)
            }
        }
    }
}
