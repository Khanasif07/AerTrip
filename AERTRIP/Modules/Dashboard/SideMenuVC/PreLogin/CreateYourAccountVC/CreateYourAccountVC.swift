//
//  CreateYourAccountVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 05/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
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
    @IBOutlet weak var emailTextField: PKFloatLabelTextField!
    @IBOutlet weak var registerButton: ATButton!
    @IBOutlet weak var privacyPolicyLabel: ActiveLabel!
    @IBOutlet weak var notRegisterYetLabel: UILabel!
    @IBOutlet weak var loginHereButton: UIButton!
    @IBOutlet weak var topNavBar: TopNavigationView!
    
    
    
    internal var currentlyUsingFrom = LoginFlowUsingFor.loginProcess
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func initialSetup() {
        
       // self.setupInitialAnimation()
//        self.setupViewDidLoadAnimation()
        self.emailTextField.becomeFirstResponder()
        self.viewModel.isFirstTime = false
        self.topNavBar.configureNavBar(title: "", isDivider: false, backgroundType: .clear)
        topNavBar.leftButton.isHidden = false
        topNavBar.delegate = self
        self.emailTextField.titleYPadding = 12.0
        self.emailTextField.hintYPadding = 12.0
        AppGlobals.shared.updateIQToolBarDoneButton(isEnabled: false, onView: self.emailTextField)
        
        self.view.backgroundColor = AppColors.screensBackground.color
        //self.registerButton.isEnabled = false
        self.registerButton.configureCommonGreenButton()
        self.emailTextField.delegate  = self
        self.emailTextField.text = self.viewModel.email
        self.emailTextField.autocorrectionType = .no
        //self.registerButton.isEnabled = self.viewModel.isEnableRegisterButton
//        self.registerButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
//        self.registerButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)
//        self.registerButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .highlighted)

        self.linkSetupForTermsAndCondition(withLabel: self.privacyPolicyLabel)
        self.emailTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        
        self.registerButton.isEnabledShadow = true
        self.textFieldValueChanged(emailTextField)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.registerButton.layer.cornerRadius = 25.0
       //self.registerButton.layer.masksToBounds = true
    }
    
    override func setupFonts() {
        
        self.headerTitleLabel.font = AppFonts.c.withSize(38)
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
//        self.registerButton.shadowColor = AppColors.themeBlack.withAlphaComponent(0.16)
//        self.registerButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //MARK:- IBOutlets
    //MARK:-
    
    @IBAction func registerButtonAction(_ sender: ATButton) {
        self.view.endEditing(true)
        if self.viewModel.isValidEmail(vc: self) {
            self.viewModel.webserviceForCreateAccount()
        } else {
            let isValidEmail = !self.viewModel.email.checkInvalidity(.Email)
            self.emailTextField.isError = !isValidEmail
            let emailPlaceHolder = self.emailTextField.placeholder ?? ""
            self.emailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceHolder, attributes: [NSAttributedString.Key.foregroundColor: isValidEmail ? AppColors.themeGray40 :  AppColors.themeRed])
        }
    }
    
    @IBAction func loginHereButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToLoginVC(email: self.viewModel.email)
    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension CreateYourAccountVC {
    
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
//                let safariVC = SFSafariViewController(url: url)
//                self.present(safariVC, animated: true, completion: nil)
//                safariVC.delegate = self
                AppFlowManager.default.showURLOnATWebView(url, screenTitle: LocalizedString.privacy_policy.localized)
            }
            
            label.handleCustomTap(for: termsOfUse) { element in
                
                guard let url = URL(string: AppConstants.termsOfUse) else {return}
//                let safariVC = SFSafariViewController(url: url)
//                self.present(safariVC, animated: true, completion: nil)
//                safariVC.delegate = self
                AppFlowManager.default.showURLOnATWebView(url, screenTitle: LocalizedString.terms_of_use.localized)
            }
        }
    }
}

//MARK:- Extension UITextFieldDelegate
//MARK:-
extension CreateYourAccountVC {
  
    @objc func textFieldValueChanged(_ textField: UITextField) {
        
        self.viewModel.email = (textField.text ?? "").removeAllWhitespaces
        //self.registerButton.isEnabled = self.viewModel.email.count > 0
        self.registerButton.isEnabledShadow = !self.viewModel.isEnableRegisterButton
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //for verify the data
        let isValidEmail = !self.viewModel.email.checkInvalidity(.Email)
        self.emailTextField.isError = !isValidEmail
        let emailPlaceHolder = self.emailTextField.placeholder ?? ""
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceHolder, attributes: [NSAttributedString.Key.foregroundColor: isValidEmail ? AppColors.themeGray40 :  AppColors.themeRed])
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.elementsEqual(" ") {
            return false
        }
        return ((textField.text ?? "") + string).count <= AppConstants.kEmailIdTextLimit
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
    }
}

extension CreateYourAccountVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        topNavBar.leftButton.isHidden = true
        if currentlyUsingFrom == .loginProcess {
            AppFlowManager.default.popToRootViewController(animated: true)
        }
        else {
            AppFlowManager.default.popViewController(animated: true)
        }
    }
}

//MARK:- Extension InitialAnimation
//MARK:-
extension CreateYourAccountVC: SFSafariViewControllerDelegate {
    
    func setupInitialAnimation() {
        
        self.headerImage.transform         = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.headerTitleLabel.transform  = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.emailTextField.transform     = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.registerButton.transform      = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.privacyPolicyLabel.transform      = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
    }
    
    func setupViewDidLoadAnimation() {
        
        let rDuration = 1.0 / 3.0
        UIView.animateKeyframes(withDuration: AppConstants.kAnimationDuration*2.0, delay: 0.0, options: .calculationModeLinear, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: (rDuration * 1.0), animations: {
                self.headerImage.transform          = .identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: (rDuration * 0.4), relativeDuration: (rDuration * 2.0), animations: {
                self.headerTitleLabel.transform      = .identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: (rDuration * 2.0), relativeDuration: (rDuration * 3.0), animations: {
                self.emailTextField.transform    = .identity
                self.registerButton.transform    = .identity
                self.privacyPolicyLabel.transform = .identity
            })
            
        }) { (success) in
            self.topNavBar.leftButton.isHidden = false
            self.emailTextField.becomeFirstResponder()
            self.viewModel.isFirstTime = false
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
