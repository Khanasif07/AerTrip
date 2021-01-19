//
//  ChangeEmailVC.swift
//  AERTRIP
//
//  Created by Admin on 04/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

class ChangeEmailVC: BaseVC {
    
    @IBOutlet weak var transparentBackView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var newEmailTextField: PKFloatLabelTextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: PKFloatLabelTextField!
    @IBOutlet weak var nextButton: ATButton!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var verifyEmailView: UIView!
    @IBOutlet weak var verifyEmailHeadingLabel: UILabel!
    @IBOutlet weak var verifyEmailDescription: UILabel!
    @IBOutlet weak var dismisButton: UIButton!
    
    
    let viewModel = ChangeEmailVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
        self.setNextButton()
        self.setOptTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.transformViewToOriginalState()
    }
    
    override func setupFonts() {
        self.cancelButton.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        self.headingLabel.font = AppFonts.Regular.withSize(24.0)
        self.descriptionLabel.font = AppFonts.Regular.withSize(14.0)
        self.verifyEmailHeadingLabel.font = AppFonts.SemiBold.withSize(24.0)
        self.verifyEmailDescription.font = AppFonts.Regular.withSize(14.0)
        self.setOptTextField()
    }
    
    override func setupColors() {
        self.cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.headingLabel.textColor = AppColors.themeBlack
        self.descriptionLabel.textColor = AppColors.themeBlack
    }
    
    override func setupTexts() {
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        self.headingLabel.text = "Change your login Id"
        self.descriptionLabel.text = "Please enter your new email id and existing\npassword to change your login email id."
        
    }
    
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.performDismissAnimation()
    }
    
    @IBAction func dismisButtonTapped(_ sender: UIButton) {
        self.performDismissAnimation()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.nextButton.isLoading = true
        self.view.endEditing(true)
        self.viewModel.validate()
//        let email = self.newEmailTextField.text ?? ""
//        let pass = self.passwordTextField.text ?? ""
//        if checkIfValid(email: email, password: pass) {
//            self.viewModel.changeEmailApi(email: email, password: pass)
//        }
        
    }
    

    private func setUpSubView() {
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.cornerRadius = 13.0
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.transparentBackView.backgroundColor = UIColor.clear
        self.transparentBackView.transform = CGAffineTransform(translationX: 0, y: transparentBackView.height)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.verifyEmailView.isHidden = true
    }
    
    private func transformViewToOriginalState() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transparentBackView.transform = CGAffineTransform.identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        })
    }
    
    private func setNextButton(){
        self.nextButton.layer.cornerRadius = self.nextButton.height / 2.0
        self.nextButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
        self.nextButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .highlighted)
        self.nextButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)
        self.nextButton.shadowColor = AppColors.appShadowColor
        self.nextButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.nextButton.setTitleColor(AppColors.themeWhite, for: .selected)
        self.nextButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
        self.nextButton.setTitle(LocalizedString.Submit.localized, for: .normal)
        self.nextButton.setTitle(LocalizedString.Submit.localized, for: .selected)
    }
    
    private func setOptTextField(){
        [newEmailTextField, passwordTextField].forEach { txtField in
            
            txtField?.titleYPadding = 12.0
            txtField?.hintYPadding = 12.0
            txtField?.titleFont = AppFonts.Regular.withSize(14)
            txtField?.font = AppFonts.Regular.withSize(18.0)
            txtField?.textColor = AppColors.themeBlack
            txtField?.titleTextColour = AppColors.themeGray40
            txtField?.titleActiveTextColour = AppColors.themeGreen
            if txtField != self.passwordTextField{
                txtField?.textContentType = .oneTimeCode
                txtField?.keyboardType = .default
                txtField?.isSecureTextEntry = false
            }else{
                txtField?.textContentType = .password
                txtField?.keyboardType = .default
                txtField?.isSecureTextEntry = true
            }
            
            txtField?.selectedLineColor = AppColors.themeGreen
            txtField?.editingBottom = 0.0
            txtField?.lineColor = AppColors.themeGray40
            txtField?.lineErrorColor = AppColors.themeRed
            txtField?.delegate = self
        }
        
        self.newEmailTextField.placeholder = "New Email Id"
        self.passwordTextField.placeholder = "Existing Password"
        self.passwordTextField.placeholder = LocalizedString.Password.localized
    }
    
    func performDismissAnimation(){
        UIView.animate(withDuration: 0.5, animations: {
            self.transparentBackView.transform = CGAffineTransform(translationX: 0, y: self.transparentBackView.height)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { (success) in
            self.dismiss(animated: false, completion: {
//                self.delegate?.otpValidationCompleted(false)
            })
        }
    }
    
    func checkIfValid(email : String, password : String) -> Bool {
        self.nextButton.isLoading = false
        if email.isEmpty {
//            self.delegate?.validate(isValid: false, msg: "Please enter email.")
            AppToast.default.showToastMessage(message: "Please enter email.")
            self.newEmailTextField.isError = true
            return false
        } else if !email.isEmail {
//            self.delegate?.validate(isValid: false, msg: "Please enter a valid email.")
            AppToast.default.showToastMessage(message: "Please enter a valid email.")
            self.newEmailTextField.isError = true
            return false
        } else if password.isEmpty {
//            self.delegate?.validate(isValid: false, msg: "Please enter password.")
            AppToast.default.showToastMessage(message: "Please enter password.")
            self.passwordTextField.isError = true
            return false
        }
        return true
    }
    
}

extension ChangeEmailVC  {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.newEmailTextField: self.viewModel.details.email = textField.text ?? ""
        case self.passwordTextField: self.viewModel.details.password = textField.text ?? ""
        default:break
        }
    }
    
}


extension ChangeEmailVC : ChangeEmailDelegate {
    
    func showErrorState(with errorState: ChangeEmailValidationState) {
        self.nextButton.isLoading = false
        switch errorState{
        case .password(_,_): self.passwordTextField.isError = true
        case .email(_,_): self.newEmailTextField.isError = true
        }
    }
    
    func showErrorMessage(with errorState: ChangeEmailValidationState) {
        self.nextButton.isLoading = false
        switch errorState{
        case .password(_,let msg), .email(_,let msg):
            AppToast.default.showToastMessage(message: msg)
        }
    }
    
    func validate(isValid: Bool, msg: String) {
        self.nextButton.isLoading = false
        AppToast.default.showToastMessage(message: msg)
    }
    
    func willChnageEmail() {

    }
    
    func changeEmailSuccess(email : String) {
        self.nextButton.isLoading = false
//        self.performDismissAnimation()
        UIView.animate(withDuration: 0.5) {
            self.containerViewHeightConstraint.constant = 200
            self.view.layoutIfNeeded()
        }
        self.verifyEmailView.isHidden = false
        
        var desc = "An email has been sent to mail@mail.com to make sure it is a valid address."
        desc = desc.replacingOccurrences(of: "mail@mail.com", with: email)
        self.verifyEmailDescription.attributedText = desc.attributeStringWithColors(subString: [email], strClr: UIColor.black, substrClr: UIColor.black, strFont: AppFonts.Regular.withSize(14), subStrFont: AppFonts.SemiBold.withSize(16))
//        AppToast.default.showToastMessage(message: "Email changed successfully.")
//

    }
    
    func errorInChangingEmail(error : ErrorCodes) {
        self.nextButton.isLoading = false
        self.newEmailTextField.isError = true
        self.passwordTextField.isError = true
//        AppToast.default.showToastMessage(message: msg)
        AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .profile)
    }
    
}
