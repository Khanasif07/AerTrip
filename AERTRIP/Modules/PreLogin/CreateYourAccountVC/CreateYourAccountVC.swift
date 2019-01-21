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
import SafariServices

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.viewModel.isFirstTime {
            self.setupInitialAnimation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.viewModel.isFirstTime {
            self.setupViewDidLoadAnimation()
        }
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
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //MARK:- IBOutlets
    //MARK:-
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        AppFlowManager.default.popViewController(animated: true)
    }
    
    @IBAction func registerButtonAction(_ sender: ATButton) {
        
        self.view.endEditing(true)
        if self.viewModel.isValidEmail(vc: self) {
            self.viewModel.webserviceForCreateAccount()
        }
    }
    
    @IBAction func loginHereButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToLoginVC(email: self.viewModel.email)
    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension CreateYourAccountVC {
    
    func initialSetups() {
        
        self.registerButton.isEnabled = false
        self.emailTextField.delegate  = self
        self.emailTextField.text = self.viewModel.email
        self.registerButton.isEnabled = self.viewModel.isEnableRegisterButton
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
                
                guard let url = URL(string: AppConstants.privacyPolicy) else {return}
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true, completion: nil)
                safariVC.delegate = self
            }
            
            label.handleCustomTap(for: termsOfUse) { element in
                
                guard let url = URL(string: AppConstants.termsOfUse) else {return}
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true, completion: nil)
                safariVC.delegate = self
            }
        }
    }
}

//MARK:- Extension UITextFieldDelegate
//MARK:-
extension CreateYourAccountVC {
  
    @objc func textFieldValueChanged(_ textField: UITextField) {
        
        self.viewModel.email = textField.text ?? ""
        self.registerButton.isEnabled = self.viewModel.isEnableRegisterButton
        
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.emailTextField.resignFirstResponder()
        self.registerButtonAction(self.registerButton)
        return true
    }
}

//MARK:- Extension UITextFieldDelegate
//MARK:-
extension CreateYourAccountVC: CreateYourAccountVMDelegate {

    func willRegister() {
        self.registerButton.isLoading = true
    }
    
    func didRegisterSuccess(email: String) {
        
        self.registerButton.isLoading = false
        AppFlowManager.default.moveToRegistrationSuccefullyVC(type: .setPassword, email: email)
    }
    
    func didRegisterFail(errors: ErrorCodes) {
        
        self.registerButton.isLoading = false
        var message = ""
        for index in 0..<errors.count {
            if index == 0 {
                
                message = AppErrorCodeFor(rawValue: errors[index])?.message ?? ""
            } else {
                message += ", " + (AppErrorCodeFor(rawValue: errors[index])?.message ?? "")
            }
        }
        AppToast.default.showToastMessage(message: message, vc: self)
    }
}

//MARK:- Extension InitialAnimation
//MARK:-
extension CreateYourAccountVC: SFSafariViewControllerDelegate {
    
    func setupInitialAnimation() {
        
        self.headerImage.transform         = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.headerTitleLabel.transform  = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.emailTextField.transform     = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.registerButton.transform      = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.privacyPolicyLabel.transform      = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
    }
    
    func setupViewDidLoadAnimation() {
        
        
        UIView.animateKeyframes(withDuration: AppConstants.kAnimationDuration, delay: 0.0, options: .calculationModeLinear, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: AppConstants.kAnimationDuration / 3.0, animations: {
                self.headerImage.transform          = .identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: ((AppConstants.kAnimationDuration / 4.0) * 1.0), relativeDuration: AppConstants.kAnimationDuration / 3.0, animations: {
                self.headerTitleLabel.transform      = .identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: ((AppConstants.kAnimationDuration / 2.0) * 1.0), relativeDuration: AppConstants.kAnimationDuration / 3.0, animations: {
                self.emailTextField.transform    = .identity
                self.registerButton.transform    = .identity
                self.privacyPolicyLabel.transform = .identity
            })
            
        }) { (success) in
            self.emailTextField.becomeFirstResponder()
            self.viewModel.isFirstTime = false
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
