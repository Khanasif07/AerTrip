//
//  CreateYourAccountVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 05/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import ActiveLabel

class CreateYourAccountVC: BaseVC {

    //MARK:- Properties
    //MARK:-
    let viewModel = CreateYourAccountVM()
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var registerButton: ATButton!
    @IBOutlet weak var privacyPolicyLabel: ActiveLabel!
    @IBOutlet weak var notRegisterYetLabel: UILabel!
    @IBOutlet weak var loginHereButton: UIButton!
    
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.registerButton.layer.cornerRadius = self.registerButton.height/2
    }
    
    override func setupFonts() {
        
        self.headerTitleLabel.font = AppFonts.Bold.withSize(38)
        self.loginHereButton.titleLabel?.font = AppFonts.SemiBold.withSize(16)
        self.notRegisterYetLabel.font = AppFonts.Regular.withSize(16)
        
        let attributedString = NSMutableAttributedString(string: LocalizedString.By_registering_you_agree_to_Aertrip_privacy_policy_terms_of_use.localized, attributes: [
            .font: AppFonts.Regular.withSize(14),
            .foregroundColor: AppColors.themeGray60
            ])
        attributedString.addAttribute(.foregroundColor, value: AppColors.themeGreen, range: NSRange(location: 39, length: 14))
        attributedString.addAttribute(.foregroundColor, value: AppColors.themeGreen, range: NSRange(location: 56, length: 13))
        self.privacyPolicyLabel.attributedText = attributedString
    }
    
    override func setupTexts() {
        
        self.headerTitleLabel.text = LocalizedString.Create_your_account.localized
        self.loginHereButton.setTitle(LocalizedString.Login_here.localized, for: .normal)
        self.notRegisterYetLabel.text = LocalizedString.Already_Registered.localized
        self.emailTextField.setupTextField(placehoder: LocalizedString.Email_ID.localized, keyboardType: .emailAddress, returnType: .done, isSecureText: false)
    }
    
    override func setupColors() {
        
        self.notRegisterYetLabel.textColor = AppColors.themeBlack
        self.headerTitleLabel.textColor = AppColors.themeBlack
        self.loginHereButton.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    //MARK:- IBOutlets
    //MARK:-
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        
        if self.viewModel.isValidEmail {
            AppFlowManager.default.moveToRegistrationSuccefullyVC(email: self.viewModel.email)
        }
    }
    
    @IBAction func loginHereButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToLoginVC()
    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension CreateYourAccountVC {
    
    func initialSetups() {
        
        self.emailTextField.delegate = self
        self.linkSetupForTermsAndCondition(withLabel: self.privacyPolicyLabel)
        self.emailTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
    }
    
    func linkSetupForTermsAndCondition(withLabel : ActiveLabel) {
        
        let privacyPolicy  = ActiveType.custom(pattern: "\\s\(LocalizedString.privacy_policy.localized)\\b")
        let termsOfUse     = ActiveType.custom(pattern: "\\s\(LocalizedString.terms_of_use.localized)\\b")
        
        withLabel.enabledTypes = [privacyPolicy,termsOfUse]
        withLabel.customize { (label) in
            
            label.text = LocalizedString.By_registering_you_agree_to_Aertrip_privacy_policy_terms_of_use.localized
            label.customColor[privacyPolicy] = AppColors.themeGreen
            label.customSelectedColor[privacyPolicy] = AppColors.themeGreen
            label.customColor[termsOfUse] = AppColors.themeGreen
            label.customSelectedColor[termsOfUse] = AppColors.themeGreen
            
            label.handleCustomTap(for: privacyPolicy) { element in
                
                printDebug("Privacy policy")
            }
            
            label.handleCustomTap(for: termsOfUse) { element in
                
                printDebug("terms of uses")
            }
        }
    }
}

//MARK:- Extension UITextFieldDelegate
//MARK:-
extension CreateYourAccountVC {
  
    @objc func textFieldValueChanged(_ textField: UITextField) {
        
        self.viewModel.email = textField.text ?? ""
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.emailTextField.resignFirstResponder()
        return true
    }
}
