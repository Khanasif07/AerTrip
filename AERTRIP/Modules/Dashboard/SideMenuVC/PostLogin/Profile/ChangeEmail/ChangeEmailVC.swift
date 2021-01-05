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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.nextButton.isLoading = true
        self.viewModel.changeEmail(email: self.newEmailTextField.text ?? "", password: self.passwordTextField.text ?? "")
    }
    

    private func setUpSubView(){
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.cornerRadius = 13.0
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.transparentBackView.backgroundColor = UIColor.clear
        self.transparentBackView.transform = CGAffineTransform(translationX: 0, y: transparentBackView.height)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
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
                txtField?.keyboardType = .numberPad
                txtField?.isSecureTextEntry = false
            }else{
                txtField?.textContentType = .password
                txtField?.keyboardType = .asciiCapable
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
    
}


extension ChangeEmailVC  {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     return true
    }
    
}


extension ChangeEmailVC : ChangeEmailDelegate {
    
    func validate(isValid: Bool, msg: String) {
        self.nextButton.isLoading = false
        AppToast.default.showToastMessage(message: msg)
    }
    
    func willChnageEmail() {

    }
    
    func changeEmailSuccess() {
        self.nextButton.isLoading = false

    }
    
    func errorInChangingEmail(msg : String) {
        self.nextButton.isLoading = false
        AppToast.default.showToastMessage(message: msg)
    }
    
}
