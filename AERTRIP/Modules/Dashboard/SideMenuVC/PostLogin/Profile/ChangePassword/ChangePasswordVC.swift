//
//  ChangePasswordVC.swift
//  AERTRIP
//
//  Created by Admin on 20/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

protocol ChangePasswordVCDelegate: class {
    func passowordChangedSuccessFully()
}

class ChangePasswordVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    let viewModel = ChangePasswordVM()
    weak var delegate: ChangePasswordVCDelegate?
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var secureAccountLabel: UILabel!
    @IBOutlet weak var passwordConditionLabel: UILabel!
    @IBOutlet weak var oldPasswordTextField: PKFloatLabelTextField!
    @IBOutlet weak var passwordTextField: PKFloatLabelTextField!
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
    @IBOutlet weak var showOldPasswordButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var topNavBar: TopNavigationView!
    @IBOutlet weak var oldPasswordHeightConstraint: NSLayoutConstraint!
    
    //Enter password labels outlets
    @IBOutlet weak var enterPasswordLabel: UILabel!
    @IBOutlet weak var enterPasswordTop: NSLayoutConstraint!
    @IBOutlet weak var enterPasswordHeight: NSLayoutConstraint!
    @IBOutlet weak var enterPasswordBottom: NSLayoutConstraint!
    
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarStyle = .darkContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusBarStyle = .lightContent
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.nextButton.layer.cornerRadius = self.nextButton.height/2
        self.nextButton.layer.masksToBounds = true
    }
    
    override func setupFonts() {
        
        self.secureAccountLabel.font = AppFonts.c.withSize(38)
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
        self.enterPasswordLabel.font = AppFonts.Regular.withSize(16)
    }
    
    override func setupTexts() {
        
        if self.viewModel.isPasswordType == .setPassword {
            self.secureAccountLabel.text = LocalizedString.Set_password.localized.replacingOccurrences(of: " ", with: "\n")
            self.enterPasswordLabel.text = LocalizedString.pleaseEnterAPassword.localized
        } else {
            self.secureAccountLabel.text = LocalizedString.ChangePassword.localized.split(separator: " ").joined(separator: "\n")
            self.enterPasswordLabel.text = ""
        }
        self.nextButton.setTitle(LocalizedString.Change.localized, for: .normal)
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
        self.enterPasswordLabel.textColor = AppColors.themeBlack
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //MARK:- IBOutlets
    //MARK:-
    
    @IBAction func showOldPasswordButtonAction(_ sender: UIButton) {
        self.oldPasswordTextField.isSecureTextEntry = !self.oldPasswordTextField.isSecureTextEntry
        if !self.oldPasswordTextField.isSecureTextEntry {
            self.showOldPasswordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 1.5)
            sender.setImage(#imageLiteral(resourceName: "showPassword"), for: .normal)
        } else {
            self.showOldPasswordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: -1, right: 1.5)
            sender.setImage(#imageLiteral(resourceName: "hidePassword"), for: .normal)
        }
    }
    
    @IBAction func showPasswordButtonAction(_ sender: UIButton) {
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
        if !self.passwordTextField.isSecureTextEntry {
            self.showPasswordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 1.5)
            sender.setImage(#imageLiteral(resourceName: "showPassword"), for: .normal)
        } else {
            self.showPasswordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: -1, right: 1.5)
            sender.setImage(#imageLiteral(resourceName: "hidePassword"), for: .normal)
        }
    }
    
    @IBAction func nextButtonAction(_ sender: ATButton) {
        
        self.view.endEditing(true)
        if self.viewModel.isValidateData {
            
            if self.viewModel.isPasswordType == .setPassword {
                self.viewModel.webserviceForSetPassword()
            } else {
                self.viewModel.webserviceForChangePassword()
            }
        } else {
            let isValidOldPassword = !self.viewModel.oldPassword.checkInvalidity(.Password)
            self.oldPasswordTextField.isError = !isValidOldPassword //self.viewModel.password.checkInvalidity(.Password)  removed the validation because to match with website
            let oldPasswordPlaceHolder = self.oldPasswordTextField.placeholder ?? ""
            self.oldPasswordTextField.attributedPlaceholder = NSAttributedString(string: oldPasswordPlaceHolder, attributes: [NSAttributedString.Key.foregroundColor: isValidOldPassword ? AppColors.themeGray40 :  AppColors.themeRed])
            
            let isValidPassword = !self.viewModel.password.checkInvalidity(.Password)
            self.passwordTextField.isError = !isValidPassword //self.viewModel.password.checkInvalidity(.Password)  removed the validation because to match with website
            let passwordPlaceHolder = self.passwordTextField.placeholder ?? ""
            self.passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordPlaceHolder, attributes: [NSAttributedString.Key.foregroundColor: isValidPassword ? AppColors.themeGray40 :  AppColors.themeRed])
        }
    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension ChangePasswordVC {
    
    func initialSetups() {
        AppGlobals.shared.updateIQToolBarDoneButton(isEnabled: false)
        self.view.backgroundColor = AppColors.screensBackground.color
        
        self.topNavBar.configureNavBar(title: "", isDivider: false, backgroundType: .clear)
        self.topNavBar.delegate = self
        self.oldPasswordTextField.delegate = self
        self.passwordTextField.delegate = self
        //self.nextButton.isEnabled = false
        //        self.passwordTextField.titleYPadding = -5.0
        //        self.passwordTextField.lineViewBottomSpace = 10.0
        self.oldPasswordTextField.titleYPadding = 12.0
        self.oldPasswordTextField.hintYPadding = 12.0
        self.passwordTextField.titleYPadding = 12.0
        self.passwordTextField.hintYPadding = 12.0
        //    self.passwordTextField.isSingleTextField = false
        
        
        self.nextButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
        self.nextButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)
        self.nextButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .highlighted)
        
        var placeholder = LocalizedString.Current_Password.localized
        self.oldPasswordTextField.setupTextField(placehoder: placeholder,textColor: AppColors.textFieldTextColor51, keyboardType: .default, returnType: .done, isSecureText: true)
        
        //        if  self.viewModel.isPasswordType == .resetPasswod {
        placeholder = LocalizedString.New_Password.localized
        //        }
        self.passwordTextField.setupTextField(placehoder: placeholder,textColor: AppColors.textFieldTextColor51, keyboardType: .default, returnType: .done, isSecureText: true)
        
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        self.oldPasswordTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        
        self.oldPasswordTextField.rightView = UIView(frame: self.showOldPasswordButton.bounds)
        self.oldPasswordTextField.rightViewMode = .always
        self.passwordTextField.rightView = UIView(frame: self.showPasswordButton.bounds)
        self.passwordTextField.rightViewMode = .always
        
        if self.viewModel.isPasswordType == .setPassword {
            self.enterPasswordLabel.isHidden = false
            self.oldPasswordHeightConstraint.constant = 0
            self.oldPasswordTextField.isHidden = true
            self.showOldPasswordButton.isHidden = true
        }else{
            self.enterPasswordLabel.isHidden = true
            self.enterPasswordTop.constant = 0.0
            self.enterPasswordHeight.constant = 0.0
            self.enterPasswordBottom.constant = 33.0
        }
        
        passwordTextField.isSecureTextEntry = false
        showPasswordButtonAction(self.showPasswordButton)
        
        oldPasswordTextField.isSecureTextEntry = false
        showOldPasswordButtonAction(self.showOldPasswordButton)
        
        self.nextButton.isEnabledShadow = true
    }
}

extension ChangePasswordVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}

//MARK:- Extension UITexFieldDElegate methods
//MARK:-
extension ChangePasswordVC {
    
    @objc func textFieldValueChanged(_ textField: UITextField) {
        if textField == oldPasswordTextField {
            self.viewModel.oldPassword = textField.text ?? ""
        } else {
            self.viewModel.password = textField.text ?? ""
        }
        
        self.setupValidation()
        if self.viewModel.isPasswordType == .setPassword {
            self.nextButton.isEnabledShadow = self.viewModel.password.checkInvalidity(.Password)
        } else {
            self.nextButton.isEnabledShadow = (self.viewModel.password.checkInvalidity(.Password) || self.viewModel.oldPassword.checkInvalidity(.Password))
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPasswordTextField {
            oldPasswordTextField.resignFirstResponder()
        } else {
            self.passwordTextField.resignFirstResponder()
        }
        self.nextButtonAction(self.nextButton)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == oldPasswordTextField {
            let isValidPassword = !self.viewModel.oldPassword.checkInvalidity(.Password)
            self.oldPasswordTextField.isError = !isValidPassword //self.viewModel.password.checkInvalidity(.Password)  removed the validation because to match with website
            let oldPasswordPlaceHolder = self.oldPasswordTextField.placeholder ?? ""
            self.oldPasswordTextField.attributedPlaceholder = NSAttributedString(string: oldPasswordPlaceHolder, attributes: [NSAttributedString.Key.foregroundColor: isValidPassword ? AppColors.themeGray40 :  AppColors.themeRed])
        } else {
            let isValidPassword = !self.viewModel.password.checkInvalidity(.Password)
            self.passwordTextField.isError = !isValidPassword //self.viewModel.password.checkInvalidity(.Password)  removed the validation because to match with website
            let passwordPlaceHolder = self.passwordTextField.placeholder ?? ""
            self.passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordPlaceHolder, attributes: [NSAttributedString.Key.foregroundColor: isValidPassword ? AppColors.themeGray40 :  AppColors.themeRed])
        }
    }
    
    
    func setupValidation() {
        
        if self.viewModel.password.containsNumbers() {
            self.numberLabel.textColor = AppColors.themeGray20
            self.oneLabel.textColor = AppColors.themeGray20
        } else {
            self.numberLabel.textColor = AppColors.themeGray60
            self.oneLabel.textColor = AppColors.themeGray60
        }
        
        if self.viewModel.password.containsLowerCase() {
            self.smallALabel.textColor = AppColors.themeGray20
            self.lowerCaseLabel.textColor = AppColors.themeGray20
            
        } else {
            self.smallALabel.textColor = AppColors.themeGray60
            self.lowerCaseLabel.textColor = AppColors.themeGray60
        }
        
        if self.viewModel.password.containsUpperCase() {
            self.capsALabel.textColor = AppColors.themeGray20
            self.upperCaseLabel.textColor = AppColors.themeGray20
        } else {
            self.capsALabel.textColor = AppColors.themeGray60
            self.upperCaseLabel.textColor = AppColors.themeGray60
        }
        
        if self.viewModel.password.containsSpecialCharacters() {
            
            UIView.transition(with: self.view, duration: 1, options: .curveEaseIn, animations: {
                self.atLabel.textColor = AppColors.themeGray20
                self.specialLabel.textColor = AppColors.themeGray20
            }, completion: nil)
            
        } else {
            self.atLabel.textColor = AppColors.themeGray60
            self.specialLabel.textColor = AppColors.themeGray60
        }
        
        if self.viewModel.password.count >= 8 {
            self.eightPlusLabel.textColor = AppColors.themeGray20
            self.charactersLabel.textColor = AppColors.themeGray20
            if self.viewModel.password.checkValidity(.Password) {
                
                let animation = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: { [weak self] in
                    
                    guard let strongSelf = self else {return}
                    
                    strongSelf.nextButtonTopConstraint.constant = 26.0
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
                self?.eightPlusLabel.textColor = AppColors.themeGray60
                self?.charactersLabel.textColor = AppColors.themeGray60
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
        
        /*
        if self.viewModel.isPasswordType == .setPassword {
            if self.viewModel.password.checkValidity(.Password) {
                self.nextButton.isEnabled = true
            } else {
                self.nextButton.isEnabled = false
            }
        } else {
            
            if self.viewModel.oldPassword.checkValidity(.Password) && self.viewModel.password.checkValidity(.Password) {
                self.nextButton.isEnabled = true
            } else {
                self.nextButton.isEnabled = false
            }
        }
 */
    }
}

//MARK:- Extension ChangePasswordVMDelegate
//MARK:-
extension ChangePasswordVC: ChangePasswordVMDelegate {
    
    func willCallApi() {
        self.nextButton.isLoading = true
    }
    
    func getSuccess() {
        self.nextButton.isLoading = false
        UserInfo.loggedInUser?.hasPassword = true
        self.delegate?.passowordChangedSuccessFully()
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func getFail(errors: ErrorCodes) {
        AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
        self.nextButton.isLoading = false
    }
}

