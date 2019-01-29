//
//  LoginVC.swift
//  AERTRIP
//
//  Created by Pramod Kumar on 03/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class LoginVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    let viewModel = LoginVM()
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak private var topImage: UIImageView!
    @IBOutlet weak private var welcomeLabel: UILabel!
    @IBOutlet weak private var emailTextField: PKFloatLabelTextField!
    @IBOutlet weak private var passwordTextField: PKFloatLabelTextField!
    @IBOutlet weak private var loginButton: ATButton!
    @IBOutlet weak private var forgotPasswordButton: UIButton!
    @IBOutlet weak private var registerHereLabel: UILabel!
    @IBOutlet weak private var registerHereButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!
    
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
        
        self.loginButton.layer.cornerRadius = self.loginButton.height/2
    }
    
    override func setupFonts() {
        
        self.welcomeLabel.font = AppFonts.Bold.withSize(38)
        self.forgotPasswordButton.titleLabel?.font = AppFonts.SemiBold.withSize(16)
        self.registerHereButton.titleLabel?.font = AppFonts.SemiBold.withSize(16)
    }
    
    override func setupTexts() {
        
        self.welcomeLabel.text = LocalizedString.Welcome_Back.localized
        self.registerHereButton.setTitle(LocalizedString.Register_here.localized, for: .normal)
        self.forgotPasswordButton.setTitle(LocalizedString.Forgot_Password.localized, for: .normal)
        self.emailTextField.setupTextField(placehoder: LocalizedString.Email_ID.localized, keyboardType: .emailAddress, returnType: .next, isSecureText: false)
        self.passwordTextField.setupTextField(placehoder: LocalizedString.Password.localized, keyboardType: .default, returnType: .done, isSecureText: true)
    }
    
    override func setupColors() {
        
        self.welcomeLabel.textColor = AppColors.themeBlack
        self.forgotPasswordButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.registerHereButton.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBAction func showPasswordButtonAction(_ sender: UIButton) {
        
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
        
        if self.passwordTextField.isSecureTextEntry {
            
            let image = UIImage(named: "showPassword")
            sender.setImage(image, for: .normal)
        } else {
            
            let image = UIImage(named: "hidePassword")
            sender.setImage(image, for: .normal)
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.backButton.isHidden = true
        AppFlowManager.default.popToRootViewController(animated: true)
    }
    @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToForgotPasswordVC(email: self.viewModel.email)
    }
    
    @IBAction func loginButtonAction(_ sender: ATButton) {
        
        self.view.endEditing(true)
        
        if self.viewModel.isValidateData(vc: self) {
            
            self.viewModel.webserviceForLogin()
        }
    }
    
    @IBAction func registerHereButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToCreateYourAccountVC(email: self.viewModel.email)
    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension LoginVC {
    
    func initialSetups() {
        
        self.emailTextField.text = self.viewModel.email
        self.loginButton.isEnabled = false
        self.setupFontsAndText()
        self.backButton.isHidden = true
    }
    
    func setupFontsAndText() {
        
        self.emailTextField.delegate    = self
        self.passwordTextField.delegate = self
        self.emailTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
       
    }
}

//MARK:- Extension LoginVMDelegate
//MARK:-
extension LoginVC: LoginVMDelegate {
    
    func willLogin() {
        self.loginButton.isLoading = true
    }
    
    func didLoginSuccess() {
        self.loginButton.isLoading = false
        AppFlowManager.default.goToDashboard()
    }
    
    func didLoginFail(errors: ErrorCodes) {
        
        self.loginButton.isLoading = false
    }
}

//MARK:- Extension Initialsetups
//MARK:-
extension LoginVC {
    
   @objc func textFieldValueChanged(_ textField: UITextField) {
        
        if textField === self.emailTextField {
            
            self.viewModel.email = textField.text ?? ""
        } else {
            
            self.viewModel.password = textField.text ?? ""
        }
         self.loginButton.isEnabled = self.viewModel.email.count > 0 && self.viewModel.password.count > 0 
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField === self.emailTextField {
            
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
            
        } else {
            self.passwordTextField.resignFirstResponder()
            self.loginButtonAction(self.loginButton)
        }
        
        return true
    }
    
}

//MARK:- Extension InitialAnimation
//MARK:-
extension LoginVC {
    
    func setupInitialAnimation() {
        
        self.topImage.transform          = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.welcomeLabel.transform      = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.emailTextField.transform    = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.passwordTextField.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.showPasswordButton.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.loginButton.transform       = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.forgotPasswordButton.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
    }
    
    func setupViewDidLoadAnimation() {
        
        let rDuration = 1.0 / 3.0
        UIView.animateKeyframes(withDuration: AppConstants.kAnimationDuration, delay: 0.0, options: .calculationModeLinear, animations: {

            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: (rDuration * 1.0), animations: {
                self.topImage.transform          = .identity
                self.backButton.isHidden = false
            })

            UIView.addKeyframe(withRelativeStartTime: (rDuration * 1.0), relativeDuration: (rDuration * 2.0), animations: {
                self.welcomeLabel.transform          = .identity
            })

            UIView.addKeyframe(withRelativeStartTime: (rDuration * 2.0), relativeDuration: (rDuration * 3.0), animations: {
                self.emailTextField.transform     = .identity
                self.passwordTextField.transform   = .identity
                self.showPasswordButton.transform  = .identity
                self.loginButton.transform       = .identity
                self.forgotPasswordButton.transform = .identity
            })

        }) { (success) in
            self.emailTextField.becomeFirstResponder()
            self.viewModel.isFirstTime = false
        }
    }
}

