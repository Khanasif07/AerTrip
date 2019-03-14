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
    @IBOutlet weak var topNavBar: TopNavigationView!
    @IBOutlet weak private var topImage: UIImageView!
    @IBOutlet weak private var welcomeLabel: UILabel!
    @IBOutlet weak private var emailTextField: PKFloatLabelTextField!
    @IBOutlet weak private var passwordTextField: PKFloatLabelTextField!
    @IBOutlet weak private var loginButton: ATButton!
    @IBOutlet weak private var forgotPasswordButton: UIButton!
    @IBOutlet weak private var registerHereLabel: UILabel!
    @IBOutlet weak private var registerHereButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    
    internal var currentlyUsingFrom = LoginFlowUsingFor.loginProcess
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        self.registerHereLabel.font = AppFonts.SemiBold.withSize(16)
    }
    
    override func setupTexts() {
        
        self.welcomeLabel.text = LocalizedString.Welcome_Back.localized
        
        self.registerHereButton.setTitle(currentlyUsingFrom == .loginVerificationForCheckout ? LocalizedString.ContinueAsGuest.localized : LocalizedString.Register_here.localized, for: .normal)
        
        self.registerHereLabel.text = currentlyUsingFrom == .loginVerificationForCheckout ? "\(LocalizedString.SkipSignIn.localized)?" : LocalizedString.Not_ye_registered.localized
        
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
        if currentlyUsingFrom == .loginVerificationForCheckout {
            popIfUsingFromCheckOut()
        }
        else {
            AppFlowManager.default.moveToCreateYourAccountVC(email: self.viewModel.email)
        }
    }
    
    private func popIfUsingFromCheckOut() {
        self.sendDataChangedNotification(data: ATNotification.userAsGuest)
        if let obj = AppFlowManager.default.mainNavigationController.viewControllers.first(where: { (vc) -> Bool in
            return vc.isKind(of: HotelResultVC.self)
        }) {
            AppFlowManager.default.popToViewController(obj, animated: true)
        }
    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension LoginVC {
    
    func initialSetups() {
        
        self.view.backgroundColor = AppColors.screensBackground.color
        
        AppGlobals.shared.updateIQToolBarDoneButton(isEnabled: false, onView: self.emailTextField)
        
        self.emailTextField.text = self.viewModel.email
        self.loginButton.isEnabled = false
        self.setupFontsAndText()
        
        self.topNavBar.configureNavBar(title: "", isDivider: false)
        self.topNavBar.delegate = self
        self.topNavBar.leftButton.isHidden = true
    }
    
    func setupFontsAndText() {
        
        self.emailTextField.delegate    = self
        self.passwordTextField.delegate = self
        self.emailTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
       
    }
}

extension LoginVC: TopNavigationViewDelegate {
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

//MARK:- Extension LoginVMDelegate
//MARK:-
extension LoginVC: LoginVMDelegate {
    
    func willLogin() {
        self.loginButton.isLoading = true
    }
    
    func didLoginSuccess() {
        self.loginButton.isLoading = false        
        if self.currentlyUsingFrom == .loginProcess {
            delay(seconds: 0.3) {
                AppFlowManager.default.goToDashboard()
            }
        } else if self.currentlyUsingFrom == .loginVerificationForCheckout {
            popIfUsingFromCheckOut()
        } else {
            self.sendDataChangedNotification(data: ATNotification.userLoggedInSuccess)
            AppFlowManager.default.popToRootViewController(animated: true)
        }
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
        
        self.topImage.transform          = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.welcomeLabel.transform      = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.emailTextField.transform    = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.passwordTextField.transform = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.showPasswordButton.transform = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.loginButton.transform       = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.forgotPasswordButton.transform = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
    }
    
    func setupViewDidLoadAnimation() {
        
        let rDuration = 1.0 / 3.0
        UIView.animateKeyframes(withDuration: AppConstants.kAnimationDuration*2.0, delay: 0.0, options: .calculationModeLinear, animations: {

            UIView.addKeyframe(withRelativeStartTime: (rDuration * 0.2), relativeDuration: (rDuration * 1.2), animations: {
                self.topImage.transform          = .identity
                self.topNavBar.leftButton.isHidden = false
            })

            UIView.addKeyframe(withRelativeStartTime: (rDuration * 0.2), relativeDuration: (rDuration * 2.0), animations: {
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

