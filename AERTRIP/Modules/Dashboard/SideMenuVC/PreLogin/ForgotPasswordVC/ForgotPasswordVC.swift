//
//  ForgotPasswordVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 07/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    let viewModel = ForgotPasswordVM()
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var intructionLabel: UILabel!
    @IBOutlet weak var emailTextField: PKFloatLabelTextField!
    @IBOutlet weak var continueButton: ATButton!
    @IBOutlet weak var topNavBar: TopNavigationView!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
        //        if self.viewModel.isFirstTime {
        //            self.setupInitialAnimation()
        //            self.setupViewDidLoadAnimation()
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.continueButton.layer.cornerRadius = self.continueButton.height/2
        // self.continueButton.layer.masksToBounds = true
    }
    
    override func setupFonts() {
        
        self.forgotPasswordLabel.font      = AppFonts.c.withSize(38)
        self.intructionLabel.font    = AppFonts.Regular.withSize(16)
        self.continueButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
        self.continueButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)
        self.continueButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .highlighted)
        
        
    }
    
    override func setupTexts() {
        
        self.forgotPasswordLabel.text = LocalizedString.ForgotYourPassword.localized
        self.intructionLabel.text = LocalizedString.EmailIntruction.localized
        self.continueButton.setTitle(LocalizedString.Continue.localized, for: .normal)
    }
    
    override func setupColors() {
        
        self.forgotPasswordLabel.textColor  = AppColors.themeBlack
        self.intructionLabel.textColor  = AppColors.themeBlack
        self.continueButton.shadowColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.continueButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
        self.emailTextField.lineErrorColor = AppColors.themeRed
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //MARK:- IBOutlets
    //MARK:-
    
    @IBAction func continueButtonAction(_ sender: ATButton) {
        
        self.view.endEditing(true)
        
        if self.viewModel.isValidEmail(vc: self) {
            self.viewModel.webserviceForForgotPassword(sender)
        }else {
            let isValidEmail = !self.viewModel.email.checkInvalidity(.Email)
            self.emailTextField.isError = !isValidEmail
            let emailPlaceHolder = self.emailTextField.placeholder ?? ""
            self.emailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceHolder, attributes: [NSAttributedString.Key.foregroundColor: isValidEmail ? AppColors.themeGray40 :  AppColors.themeRed])
        }
    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension ForgotPasswordVC {
    
    func initialSetups() {
        
        AppGlobals.shared.updateIQToolBarDoneButton(isEnabled: false, onView: self.emailTextField)
        self.emailTextField.titleYPadding = 12.0
        self.emailTextField.hintYPadding = 12.0
        //self.emailTextField.lineViewBottomSpace = 10.0
        self.view.backgroundColor = AppColors.screensBackground.color
        
        self.topNavBar.configureNavBar(title: "", isDivider: false, backgroundType: .clear)
        self.topNavBar.delegate = self
        
        //self.continueButton.isEnabled = false
        self.emailTextField.delegate = self
        self.emailTextField.text = self.viewModel.email
        self.emailTextField.autocorrectionType = .no
        //self.continueButton.isEnabled = self.viewModel.isValidateForContinueButtonSelection 
        self.emailTextField.setupTextField(placehoder: LocalizedString.Email_ID.localized, keyboardType: .emailAddress, returnType: .done, isSecureText: false)
        self.emailTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        //topNavBar.leftButton.isHidden = true
        
        self.continueButton.isEnabledShadow = true
        textFieldValueChanged(emailTextField)
        
    }
}

extension ForgotPasswordVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

//MARK:- Extension UITextFieldDelegate
//MARK:-
extension ForgotPasswordVC {
    
    @objc func textFieldValueChanged(_ textField: UITextField) {
        
        self.viewModel.email = textField.text ?? ""
        //self.continueButton.isEnabled = self.viewModel.isValidateForContinueButtonSelection
        self.continueButton.isEnabledShadow = !self.viewModel.isValidateForContinueButtonSelection
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //for verify the data
        if textField === self.emailTextField {
            let isValidEmail = !self.viewModel.email.checkInvalidity(.Email)
            self.emailTextField.isError = !isValidEmail
            let emailPlaceHolder = self.emailTextField.placeholder ?? ""
            self.emailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceHolder, attributes: [NSAttributedString.Key.foregroundColor: isValidEmail ? AppColors.themeGray40 :  AppColors.themeRed])
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.emailTextField.resignFirstResponder()
        self.continueButtonAction(self.continueButton)
        return true
    }
}


//MARK:- Extension UITextFieldDelegate
//MARK:-
extension ForgotPasswordVC: ForgotPasswordVMDelegate {
    
    func willLogin() {
        self.continueButton.isLoading = true
    }
    
    func didLoginSuccess(email: String) {
        self.continueButton.isLoading = false
        AppFlowManager.default.moveToRegistrationSuccefullyVC(type: .resetPassword, email: self.viewModel.email)
    }
    
    func didLoginFail(errors: ErrorCodes) {
        
        self.continueButton.isLoading = false
    }
}


//MARK:- Extension InitialAnimation
//MARK:-
extension ForgotPasswordVC {
    
    func setupInitialAnimation() {
        
        self.logoImage.transform         = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.forgotPasswordLabel.transform  = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.intructionLabel.transform     = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.emailTextField.transform      = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.continueButton.transform      = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
    }
    
    func setupViewDidLoadAnimation() {
        
        let rDuration = 1.0 / 3.0
        UIView.animateKeyframes(withDuration: AppConstants.kAnimationDuration*2.0, delay: 0.0, options: .calculationModeLinear, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: (rDuration * 0.2), relativeDuration: (rDuration * 1.2), animations: {
                self.logoImage.transform          = .identity
                self.topNavBar.leftButton.isHidden = false
            })
            
            UIView.addKeyframe(withRelativeStartTime: (rDuration * 0.2), relativeDuration: (rDuration * 2.0), animations: {
                self.forgotPasswordLabel.transform      = .identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: (rDuration * 2.0), relativeDuration: (rDuration * 3.0), animations: {
                self.intructionLabel.transform    = .identity
                self.emailTextField.transform = .identity
                self.continueButton.transform    = .identity
            })
            
        }) { (success) in
            self.emailTextField.becomeFirstResponder()
            self.viewModel.isFirstTime = false
        }
    }
}
