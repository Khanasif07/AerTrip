//
//  LoginVC.swift
//  AERTRIP
//
//  Created by Pramod Kumar on 03/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//
//self.emailTextField.titleYPadding = 12.0
//       self.emailTextField.hintYPadding = 12.0
//       self.emailTextField.lineViewBottomSpace = 10.0

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
    @IBOutlet weak var creditTypeButtonContainer: UIView!
    
    
    internal var currentlyUsingFrom = LoginFlowUsingFor.loginProcess
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
        self.emailTextField.becomeFirstResponder()
        self.viewModel.isFirstTime = false

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.loginButton.layer.cornerRadius = self.loginButton.height/2
       // self.loginButton.layer.masksToBounds = true
        
    }
    
    override func setupFonts() {
        
        self.welcomeLabel.font = AppFonts.c.withSize(38)
        self.forgotPasswordButton.titleLabel?.font = AppFonts.SemiBold.withSize(16)
        self.registerHereButton.titleLabel?.font = AppFonts.SemiBold.withSize(16)
        self.registerHereLabel.font = AppFonts.Regular.withSize(16)
        self.loginButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .highlighted)
        self.loginButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .highlighted)
        self.loginButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .highlighted)
    }
    
    override func setupTexts() {
        
        self.welcomeLabel.text = LocalizedString.Welcome_Back.localized
        
        self.registerHereButton.setTitle(currentlyUsingFrom == .loginVerificationForCheckout ? LocalizedString.ContinueAsGuest.localized : LocalizedString.Register_here.localized, for: .normal)
        
        self.registerHereLabel.text = currentlyUsingFrom == .loginVerificationForCheckout ? "\(LocalizedString.SkipSignIn.localized)?" : LocalizedString.Not_ye_registered.localized
        
        self.forgotPasswordButton.setTitle(LocalizedString.Forgot_Password.localized, for: .normal)
        self.emailTextField.setupTextField(placehoder: LocalizedString.Email_ID.localized,with: "", keyboardType: .emailAddress, returnType: .next, isSecureText: false)
        self.passwordTextField.setupTextField(placehoder: LocalizedString.Password.localized,with: "", keyboardType: .default, returnType: .done, isSecureText: true)
        self.emailTextField.font = AppFonts.Regular.withSize(18)
        self.passwordTextField.font = AppFonts.Regular.withSize(18)
        
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
    @IBAction func regularButtonAction(_ sender: UIButton) {
        self.emailTextField.text = "rajan.singh@appinventiv.com"
        self.passwordTextField.text = "Rajan@12345"
        self.viewModel.email = self.emailTextField.text ?? ""
        self.viewModel.password = self.passwordTextField.text ?? ""
        self.loginButtonAction(self.loginButton)
    }
    
    @IBAction func statementButtonAction(_ sender: UIButton) {
        self.emailTextField.text = "pawan.kumar@appinventiv.com"
        self.passwordTextField.text = "Pk71@yahoo"
        self.viewModel.email = self.emailTextField.text ?? ""
        self.viewModel.password = self.passwordTextField.text ?? ""
        self.loginButtonAction(self.loginButton)
    }
    
    @IBAction func topupButtonAction(_ sender: UIButton) {
        self.emailTextField.text = "pramod.kumar@appinventiv.com"
        self.passwordTextField.text = "Pramod@123"
        self.viewModel.email = self.emailTextField.text ?? ""
        self.viewModel.password = self.passwordTextField.text ?? ""
        self.loginButtonAction(self.loginButton)
    }
    
    @IBAction func bilwiseButtonAction(_ sender: UIButton) {
        self.emailTextField.text = "rahulTest@yopmail.com"
        self.passwordTextField.text = "Taruna@04"
        self.viewModel.email = self.emailTextField.text ?? ""
        self.viewModel.password = self.passwordTextField.text ?? ""
        self.loginButtonAction(self.loginButton)
    }
    
    
    @IBAction func showPasswordButtonAction(_ sender: UIButton) {
        
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
        
        if self.passwordTextField.isSecureTextEntry {
            self.showPasswordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
            sender.setImage(#imageLiteral(resourceName: "showPassword"), for: .normal)
        } else {
            self.showPasswordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: -1, right: 0)
            sender.setImage(#imageLiteral(resourceName: "hidePassword"), for: .normal)
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
        if let obj = AppFlowManager.default.currentNavigation?.viewControllers.first(where: { (vc) -> Bool in
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
        
//        self.creditTypeButtonContainer.backgroundColor = AppColors.clear
        self.creditTypeButtonContainer.isHidden = AppConstants.isReleasingToClient
        
        self.view.backgroundColor = AppColors.screensBackground.color
        
        AppGlobals.shared.updateIQToolBarDoneButton(isEnabled: false, onView: self.emailTextField)
        
        self.emailTextField.text = self.viewModel.email
        self.emailTextField.titleYPadding = 12.0
        self.emailTextField.hintYPadding = 12.0
       // self.emailTextField.lineViewBottomSpace = 10.0
        self.passwordTextField.titleYPadding = 12.0
        self.passwordTextField.hintYPadding = 12.0
       // self.passwordTextField.lineViewBottomSpace = 10.0
//        self.emailTextField.lineViewBottomSpace = 10.0
//        self.passwordTextField.lineViewBottomSpace = 10.0
//        self.emailTextField.isSingleTextField = false
//        self.passwordTextField.isSingleTextField = false
        self.loginButton.isEnabled = false
        self.loginButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
        self.loginButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)

        self.setupFontsAndText()
        
        self.topNavBar.configureNavBar(title: "", isDivider: false, backgroundType: .clear)
        self.topNavBar.delegate = self
        self.topNavBar.leftButton.isHidden = false
        //self.loginButton.layer.masksToBounds = true
        self.loginButton.shadowColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.loginButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
        var padingFrame =  emailTextField.bounds
        padingFrame.size = CGSize(width: 30, height: padingFrame.height)
        let paddingView = UIView(frame: padingFrame)
        paddingView.backgroundColor = .clear
        passwordTextField.rightView = paddingView
        passwordTextField.rightViewMode = .always
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
        }
        else {
            self.sendDataChangedNotification(data: ATNotification.userLoggedInSuccess)
        }
//        else if self.currentlyUsingFrom == .loginVerificationForCheckout {
//            popIfUsingFromCheckOut()
//        } else {
//            self.sendDataChangedNotification(data: ATNotification.userLoggedInSuccess)
//            AppFlowManager.default.popToRootViewController(animated: true)
//        }
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
            
            self.viewModel.email = (textField.text ?? "").removeAllWhitespaces
        } else {
            
            self.viewModel.password = (textField.text ?? "").removeAllWhitespaces
        }
         self.loginButton.isEnabled = self.viewModel.email.count > 0 && self.viewModel.password.count > 0 
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //for verify the data
        if textField === self.emailTextField {
            self.emailTextField.isError = self.viewModel.email.checkInvalidity(.Email)
        } else {
            
            self.passwordTextField.isError = self.viewModel.password.checkInvalidity(.Password)
        }
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
        
        let intialPos = UIDevice.screenWidth
        self.topImage.transform          = CGAffineTransform(translationX: intialPos, y: 0)
        self.welcomeLabel.transform      = CGAffineTransform(translationX: intialPos, y: 0)
        self.emailTextField.transform    = CGAffineTransform(translationX: intialPos, y: 0)
        self.passwordTextField.transform = CGAffineTransform(translationX: intialPos, y: 0)
        self.showPasswordButton.transform = CGAffineTransform(translationX: intialPos, y: 0)
        self.loginButton.transform       = CGAffineTransform(translationX: intialPos, y: 0)
        self.forgotPasswordButton.transform = CGAffineTransform(translationX: intialPos, y: 0)
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

