//
//  SecureYourAccountVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 06/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SecureYourAccountVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    let viewModel = SecureYourAccountVM()
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var secureAccountLabel: UILabel!
    @IBOutlet weak var setPasswordLabel: UILabel!
    @IBOutlet weak var passwordConditionLabel: UILabel!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var smallALabel: UILabel!
    @IBOutlet weak var lowerCaseLabel: UILabel!
    @IBOutlet weak var capsALabel: UILabel!
    @IBOutlet weak var upperCaseLabel: UILabel!
    @IBOutlet weak var atLabel: UILabel!
    @IBOutlet weak var specialLabel: UILabel!
    @IBOutlet weak var eightPlusLabel: UILabel!
    @IBOutlet weak var charactersLabel: UILabel!
    @IBOutlet weak var nextButton: ATButton!
    @IBOutlet weak var validationStackView: UIStackView!
    @IBOutlet weak var nextButtonTopConstraint: NSLayoutConstraint!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.nextButton.layer.cornerRadius = self.nextButton.height/2
    }
    
    override func setupFonts() {
        
        self.secureAccountLabel.font = AppFonts.Bold.withSize(38)
        self.setPasswordLabel.font = AppFonts.Regular.withSize(16)
        self.passwordConditionLabel.font = AppFonts.Regular.withSize(14)
        self.oneLabel.font = AppFonts.Regular.withSize(28)
        self.smallALabel.font = AppFonts.Regular.withSize(28)
        self.capsALabel.font = AppFonts.Regular.withSize(28)
        self.atLabel.font = AppFonts.Regular.withSize(28)
        self.eightPlusLabel.font = AppFonts.Regular.withSize(28)
        self.numberLabel.font = AppFonts.Regular.withSize(12)
        self.lowerCaseLabel.font = AppFonts.Regular.withSize(12)
        self.upperCaseLabel.font = AppFonts.Regular.withSize(12)
        self.specialLabel.font = AppFonts.Regular.withSize(12)
        self.charactersLabel.font = AppFonts.Regular.withSize(12)
    }
    
    override func setupTexts() {
        
        if self.viewModel.isPasswordType == .setPassword {
            
            self.secureAccountLabel.text = LocalizedString.Secure_your_account.localized
            self.setPasswordLabel.text = LocalizedString.Set_password.localized
        } else {
            self.secureAccountLabel.text = LocalizedString.Reset_Password.localized
            self.setPasswordLabel.text = LocalizedString.Please_enter_new_Password.localized
        }
        
        self.passwordConditionLabel.text = LocalizedString.Password_Conditions.localized
        self.oneLabel.text = LocalizedString.one.localized
        self.numberLabel.text = LocalizedString.Number.localized
        self.smallALabel.text = LocalizedString.a.localized
        self.lowerCaseLabel.text = LocalizedString.Lowercase.localized
        self.upperCaseLabel.text = LocalizedString.Uppercase.localized
        self.capsALabel.text = LocalizedString.A.localized
        self.atLabel.text = LocalizedString.at.localized
        self.specialLabel.text = LocalizedString.Special.localized
        self.eightPlusLabel.text = LocalizedString.eight_Plus.localized
        self.charactersLabel.text = LocalizedString.Characters.localized
    }
    
    override func setupColors() {
        
        self.secureAccountLabel.tintColor = AppColors.themeBlack
        self.setPasswordLabel.tintColor = AppColors.themeBlack
        self.passwordConditionLabel.tintColor = AppColors.themeGray60
        self.oneLabel.tintColor = AppColors.themeGray60
        self.numberLabel.tintColor = AppColors.themeGray60
        self.smallALabel.tintColor = AppColors.themeGray60
        self.lowerCaseLabel.tintColor = AppColors.themeGray60
        self.capsALabel.tintColor = AppColors.themeGray60
        self.upperCaseLabel.tintColor = AppColors.themeGray60
        self.atLabel.tintColor = AppColors.themeGray60
        self.specialLabel.tintColor = AppColors.themeGray60
        self.eightPlusLabel.tintColor = AppColors.themeGray60
        self.charactersLabel.tintColor = AppColors.themeGray60
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: ATButton) {
        
        if self.viewModel.password.checkValidity(.Password) {
            
            sender.isLoading = true
            self.viewModel.webserviceForUpdatePassword(sender)
            AppFlowManager.default.moveToCreateProfileVC()
        }
    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension SecureYourAccountVC {
    
    func initialSetups() {
        
        self.passwordTextField.delegate = self
        self.nextButton.isEnabled = false
        var placeholder = LocalizedString.Password.localized
        if  self.viewModel.isPasswordType == .resetPasswod {
            placeholder = LocalizedString.New_Password.localized
        }
        self.passwordTextField.setupTextField(placehoder: placeholder, keyboardType: .default, returnType: .done, isSecureText: true)
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        let showButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: self.passwordTextField.height))
        
        showButton.addTarget(self, action: #selector(self.showPasswordAction(_:)), for: .touchUpInside)
        let image = UIImage(named: "off")
        showButton.setImage(image, for: .normal)
        self.passwordTextField.rightView = showButton
        self.passwordTextField.rightViewMode = .never
    }
}

//MARK:- Extension UITexFieldDElegate methods
//MARK:-
private extension SecureYourAccountVC {
    
    @objc func textFieldValueChanged(_ textField: UITextField) {
        
        self.viewModel.password = textField.text ?? ""
        self.setupValidation()
    }
    
    @objc func showPasswordAction(_ sender: UIButton) {
        
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
    }
    
    func setupValidation() {
        
        if self.viewModel.password.containsNumbers() {
            
            self.numberLabel.isEnabled  = false
            self.oneLabel.isEnabled    = false
        } else {
            
            self.numberLabel.isEnabled = true
            self.oneLabel.isEnabled   = true
        }
        
        if self.viewModel.password.containsLowerCase() {
            self.smallALabel.isEnabled  = false
            self.lowerCaseLabel.isEnabled    = false
        } else {
            
            self.smallALabel.isEnabled = true
            self.lowerCaseLabel.isEnabled   = true
        }
        
        if self.viewModel.password.containsUpperCase() {
            self.capsALabel.isEnabled  = false
            self.upperCaseLabel.isEnabled    = false
        } else {
            
            self.capsALabel.isEnabled = true
            self.upperCaseLabel.isEnabled   = true
        }
        
        if self.viewModel.password.containsSpecialCharacters() {
            
            UIView.transition(with: self.view, duration: 1, options: .curveEaseIn, animations: {
                self.atLabel.isEnabled  = false
                self.specialLabel.isEnabled  = false
            }, completion: nil)
            
        } else {
            
            self.atLabel.isEnabled = true
            self.specialLabel.isEnabled = true
        }
        
        if self.viewModel.password.count >= 8 {
            self.eightPlusLabel.isEnabled  = false
            self.charactersLabel.isEnabled = false
            if self.viewModel.password.checkValidity(.Password) {
                
                let animation = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: { [weak self] in
                    
                    guard let strongSelf = self else {return}
                    
                    strongSelf.nextButtonTopConstraint.constant = 16
                    strongSelf.passwordConditionLabel.isHidden = true
                    strongSelf.validationStackView.isHidden = true
                    
                    strongSelf.view.layoutIfNeeded()
                })
                
                animation.startAnimation()
                
                
            } else {
                
                let animation = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: { [weak self] in
                    
                    guard let strongSelf = self else {return}
                    
                    
                    strongSelf.nextButtonTopConstraint.constant = 146.5
                    
                    strongSelf.view.layoutIfNeeded()
                })
                
                animation.addCompletion { (xyz) in
                    
                    let animation = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: { [weak self] in
                        
                        guard let strongSelf = self else {return}
                        
                        strongSelf.passwordConditionLabel.isHidden = false
                        strongSelf.validationStackView.isHidden = false
                    })
                    animation.startAnimation()
                    
                }
                animation.startAnimation()
            }
        } else {
            
            let animation = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: { [weak self] in
                
                guard let strongSelf = self else {return}
                
                strongSelf.nextButtonTopConstraint.constant = 146.5
                strongSelf.view.layoutIfNeeded()
            })
            
            animation.addCompletion { (xyz) in
                
                let animation = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: { [weak self] in
                    
                    guard let strongSelf = self else {return}
                    
                    strongSelf.passwordConditionLabel.isHidden = false
                    strongSelf.validationStackView.isHidden = false
                    strongSelf.eightPlusLabel.isEnabled = true
                    strongSelf.charactersLabel.isEnabled   = true
                })
                animation.startAnimation()
            }
            animation.startAnimation()
            
        }
        
        if self.viewModel.password.isEmpty {
            self.passwordTextField.rightViewMode = .never
        } else {
            self.passwordTextField.rightViewMode = .always
        }
        
        if self.viewModel.password.checkValidity(.Password) {
            self.nextButton.isEnabled = true
        } else {
            self.nextButton.isEnabled = false
        }
    }
}
