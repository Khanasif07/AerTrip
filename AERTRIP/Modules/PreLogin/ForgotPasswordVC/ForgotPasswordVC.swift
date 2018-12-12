//
//  ForgotPasswordVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 07/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    let viewModel = ForgotPasswordVM()
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var intructionLabel: UILabel!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var continueButton: ATButton!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
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
    
    //MARK:- IBOutlets
    //MARK:-
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonAction(_ sender: ATButton) {
        
        self.view.endEditing(true)
        if self.viewModel.isValidEmail(vc: self) {
            
            sender.isLoading = true
            self.viewModel.webserviceForForgotPassword(sender)
        }
    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension ForgotPasswordVC {
    
    func initialSetups() {
        
        self.continueButton.isEnabled = false
        self.emailTextField.setupTextField(placehoder: LocalizedString.Email_ID.localized, keyboardType: .emailAddress, returnType: .done, isSecureText: false)
        self.emailTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
    }
}

//MARK:- Extension UITextFieldDelegate
//MARK:-
extension ForgotPasswordVC {
    
    @objc func textFieldValueChanged(_ textField: UITextField) {
        
        self.viewModel.email = textField.text ?? ""
        if self.viewModel.isValidateForContinueButtonSelection {
            self.continueButton.isEnabled = true
        } else {
            self.continueButton.isEnabled = false
        }
    }
}
