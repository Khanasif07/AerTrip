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
        
        self.continueButton.layer.cornerRadius = self.continueButton.height/2
    }
    
    override func setupFonts() {
        
        self.forgotPasswordLabel.font      = AppFonts.Bold.withSize(38)
        self.intructionLabel.font    = AppFonts.Regular.withSize(16)
        
    }
    
    override func setupTexts() {
        
        self.forgotPasswordLabel.text = LocalizedString.ForgotYourPassword.localized
        self.intructionLabel.text = LocalizedString.EmailIntruction.localized
        self.continueButton.setTitle(LocalizedString.Continue.localized, for: .normal)
    }
    
    override func setupColors() {
        
        self.forgotPasswordLabel.textColor  = AppColors.themeBlack
        self.intructionLabel.textColor  = AppColors.themeBlack
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBAction func backButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    @IBAction func continueButtonAction(_ sender: ATButton) {
        
        self.view.endEditing(true)
        if self.viewModel.isValidEmail(vc: self) {
            self.viewModel.webserviceForForgotPassword(sender)
        }
    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension ForgotPasswordVC {
    
    func initialSetups() {
        
        self.continueButton.isEnabled = false
        self.emailTextField.delegate = self
        self.emailTextField.text = self.viewModel.email
        self.continueButton.isEnabled = self.viewModel.isValidateForContinueButtonSelection 
        self.emailTextField.setupTextField(placehoder: LocalizedString.Email_ID.localized, keyboardType: .emailAddress, returnType: .done, isSecureText: false)
        self.emailTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
    }
}

//MARK:- Extension UITextFieldDelegate
//MARK:-
extension ForgotPasswordVC {
    
    @objc func textFieldValueChanged(_ textField: UITextField) {
        
        self.viewModel.email = textField.text ?? ""
        self.continueButton.isEnabled = self.viewModel.isValidateForContinueButtonSelection
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
extension ForgotPasswordVC {
    
    func setupInitialAnimation() {
        
        self.logoImage.transform         = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.forgotPasswordLabel.transform  = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.intructionLabel.transform     = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.emailTextField.transform      = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.continueButton.transform      = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
    }
    
    func setupViewDidLoadAnimation() {
        
        UIView.animateKeyframes(withDuration: AppConstants.kAnimationDuration, delay: 0.0, options: .calculationModeLinear, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: AppConstants.kAnimationDuration / 3.0, animations: {
                self.logoImage.transform          = .identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: ((AppConstants.kAnimationDuration / 4.0) * 1.0), relativeDuration: AppConstants.kAnimationDuration / 3.0, animations: {
                self.forgotPasswordLabel.transform      = .identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: ((AppConstants.kAnimationDuration / 2.0) * 1.0), relativeDuration: AppConstants.kAnimationDuration / 3.0, animations: {
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
