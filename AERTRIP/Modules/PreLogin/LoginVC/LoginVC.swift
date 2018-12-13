//
//  LoginVC.swift
//  AERTRIP
//
//  Created by Pramod Kumar on 03/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    let viewModel = LoginVM()

    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak private var topImage: UIImageView!
    @IBOutlet weak private var welcomeLabel: UILabel!
    @IBOutlet weak private var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak private var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak private var loginButton: ATButton!
    @IBOutlet weak private var forgotPasswordButton: UIButton!
    @IBOutlet weak private var registerHereLabel: UILabel!
    @IBOutlet weak private var registerHereButton: UIButton!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
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
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToForgotPasswordVC()
    }
    
    @IBAction func loginButtonAction(_ sender: ATButton) {
        
//        AppToast.default.showToastMessageWithRightButtonImage(vc: self, message: LocalizedString.Enter_email_address.localized, delegate: self)
        
        self.view.endEditing(true)

        if self.viewModel.isValidateData(vc: self) {

            sender.isLoading = true
            self.viewModel.webserviceForLogin()
        }
    }
    
    @IBAction func registerHereButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToCreateYourAccountVC()
    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension LoginVC {
    
    func initialSetups() {
        
        self.setupFontsAndText()
//        self.loginButton.isEnabled = false
    }
    
    func setupFontsAndText() {
        
        self.emailTextField.delegate    = self
        self.passwordTextField.delegate = self
        
        self.emailTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        
        let showButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: self.passwordTextField.height))
        
        showButton.addTarget(self, action: #selector(self.showPasswordAction(_:)), for: .touchUpInside)
        let image = UIImage(named: "off")
        showButton.setImage(image, for: .normal)
        self.passwordTextField.rightView = showButton
        self.passwordTextField.rightViewMode = .never
    }
    
    @objc func showPasswordAction(_ sender: UIButton) {
        
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
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

//MARK:- Extension Initialsetups
//MARK:-
extension LoginVC: ToastDelegate {
    
    func toastRightButtoAction() {
        printDebug("Apply")
    }
    
    
    @objc func textFieldValueChanged(_ textField: UITextField) {
        
        if textField === self.emailTextField {
            
            self.viewModel.email = textField.text ?? ""
        } else {
            
            self.viewModel.password = textField.text ?? ""
            if self.viewModel.password.isEmpty {
                self.passwordTextField.rightViewMode = .never
            } else {
                self.passwordTextField.rightViewMode = .always
            }
        }
        
//        if self.viewModel.isLoginButtonEnable {
//            self.loginButton.isEnabled = true
//        } else {
//            self.loginButton.isEnabled = false
//        }
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField === self.emailTextField {
            
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
            
        } else {
            self.passwordTextField.resignFirstResponder()
        }
        
        return true
    }
    
}
