//
//  EnableDisableWalletOTPVC.swift
//  AERTRIP
//
//  Created by Appinventiv  on 31/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import ActiveLabel

protocol  WalletEnableDisableDelegate:NSObject {
    func otpEnableDisableCompleted(_ isSuccess: Bool)
}

class EnableDisableWalletOTPVC: BaseVC {
    @IBOutlet weak var transparentBackView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var verifyYourCredential: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: PKFloatLabelTextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var otpEmailTextField: PKFloatLabelTextField!
    @IBOutlet weak var resendEmailLabel: ActiveLabel!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var otpPhoneTextField: PKFloatLabelTextField!
    @IBOutlet weak var resendPhoneLabel: ActiveLabel!
    @IBOutlet weak var nextButton: ATButton!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    
    
    var viewModel = EnableDisableWalletOTPVM()
    weak var delegate:WalletEnableDisableDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
        self.setNextButton()
        self.setOptTextField()
        self.viewModel.delegate = self
        if !(UserInfo.loggedInUser?.isWalletEnable ?? true){
            self.emailView.isHidden = true
            self.phoneView.isHidden = true
            self.containerViewHeightConstraint.constant = 340
        }else{
            self.viewModel.sendOTPValidation(params: [:], type: .both)
            self.linkSetupForResend(withLabel: self.resendEmailLabel, isResend: false, useringFor: "email")
            self.linkSetupForResend(withLabel: self.resendPhoneLabel, isResend: false, useringFor: "phone")
            self.containerViewHeightConstraint.constant = 520
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.transformViewToOriginalState()
    }
    
    override func setupFonts() {
        self.cancelButton.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        self.verifyYourCredential.font = AppFonts.Regular.withSize(24.0)
        self.descriptionLabel.font = AppFonts.Regular.withSize(14.0)
        self.setOptTextField()
    }
    
    override func setupColors() {
        self.cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.verifyYourCredential.textColor = AppColors.themeBlack
        self.descriptionLabel.textColor = AppColors.themeBlack
    }
    
    override func setupTexts() {
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        self.verifyYourCredential.text = LocalizedString.verifyYourCredential.localized
        if (UserInfo.loggedInUser?.isWalletEnable ?? true){
            self.descriptionLabel.text = LocalizedString.disableOtpVerificationMsg.localized
        }else{
            self.descriptionLabel.text = LocalizedString.enableOtpVerificationMsg.localized
        }
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
    
    
    private func linkSetupForResend(withLabel: ActiveLabel, isResend: Bool, useringFor: String) {
        let seeExample = ActiveType.custom(pattern: "\\sResend OTP\\b")
        let allTypes: [ActiveType] = [seeExample]
        let textToDisplay = !isResend ? LocalizedString.waitAminToOtp.localized : LocalizedString.didntGetOtp.localized
        withLabel.textColor = AppColors.themeGray40
        withLabel.enabledTypes = allTypes
        withLabel.customize { label in
            label.font = AppFonts.Regular.withSize(14.0)
            label.text = textToDisplay
            for item in allTypes {
                label.customColor[item] = AppColors.themeGreen
                label.customSelectedColor[item] = AppColors.themeGreen
            }
            label.highlightFontName = AppFonts.SemiBold.rawValue
            label.highlightFontSize = 14.0
            label.handleCustomTap(for: seeExample) {[weak self] _ in
                guard let self = self else {return}
                self.resendOtp(useringFor: useringFor)
            }
        }
    }
    
    
    private func resendOtp(useringFor: String){
        if useringFor == "email"{
            let dict : JSONDictionary = ["resend" : "email"]
            self.viewModel.logEvent(with: .generateOtpForEmail)
            self.viewModel.sendOTPValidation(params: dict, type: .email)
        }else{
            let dict : JSONDictionary = [ "resend" : "mobile"]
            self.viewModel.logEvent(with: .generateOtpForMob)
            self.viewModel.sendOTPValidation(params: dict, type: .phone)
        }
    }
    
    private func setOptTextField(){
        [passwordTextField, otpEmailTextField, otpPhoneTextField].forEach { txtField in
            
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
        
        self.otpEmailTextField.placeholder = "Enter Email OTP"
        self.otpPhoneTextField.placeholder = "Enter Mobile OTP"
        self.passwordTextField.placeholder = LocalizedString.Password.localized
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
    
    @IBAction func transparentViewTapped(_ sender: Any) {
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.transparentBackView.transform = CGAffineTransform(translationX: 0, y: self.transparentBackView.height)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { (success) in
            self.dismiss(animated: false, completion: {
                CustomToast.shared.fadeAllToasts()
                self.viewModel.cancelValidation()
            })
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.viewModel.validate()
    }
}


extension EnableDisableWalletOTPVC : EnableDisableWalletOTPVMDelegate{
    func getSendOTPResponse(_ isSucess: Bool, type: SentOPTAPIType) {
        self.nextButton.isLoading = false
        guard isSucess else {return}
        switch type{
        case .both:
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(self.updatePhoneResendText), with: nil, afterDelay: 60)
            self.perform(#selector(self.updatEmailResendText), with: nil, afterDelay: 60)
        case .email:
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.updatEmailResendText), object: nil)
            self.perform(#selector(self.updatEmailResendText), with: nil, afterDelay: 60)
        case .phone:
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.updatePhoneResendText), object: nil)
            self.perform(#selector(self.updatePhoneResendText), with: nil, afterDelay: 60)
        case .passwordValidation:
            UserInfo.loggedInUser?.isWalletEnable = true
            self.dismiss(animated: true){
                self.delegate?.otpEnableDisableCompleted(false)
            }
        }
    }
    
    func comoletedValidation(_ isSucess: Bool) {
        self.nextButton.isLoading = false
        guard isSucess else {return}
        UserInfo.loggedInUser?.isWalletEnable = false
        self.dismiss(animated: true){
            self.delegate?.otpEnableDisableCompleted(false)
        }
    }

    func showErrorState(with errorState: ValidationState) {
        self.nextButton.isLoading = false
        switch errorState{
        case .password(_,_): self.passwordTextField.isError = true
        case .phoneOtp(_,_): self.otpPhoneTextField.isError = true
        case .emailOtp(_,_): self.otpEmailTextField.isError = true
        }
    }
    
    func showErrorMessage(with errorState: ValidationState) {
        self.nextButton.isLoading = false
        switch errorState{
        case .password(_,let msg), .phoneOtp(_,let msg), .emailOtp(_,let msg):
            AppToast.default.showToastMessage(message: msg)
        }
    }

    @objc func updatePhoneResendText(){
        self.linkSetupForResend(withLabel: self.resendPhoneLabel, isResend: true, useringFor: "phone")
    }
    @objc func updatEmailResendText(){
        self.linkSetupForResend(withLabel: self.resendEmailLabel, isResend: true, useringFor: "email")
    }

}

extension EnableDisableWalletOTPVC  {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.textContentType == .oneTimeCode{
            return ((textField.text?.count ?? 0) < 6) || string == ""
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.passwordTextField:
            self.viewModel.details.password = textField.text ?? ""
        case self.otpPhoneTextField:
            self.viewModel.details.phoneOtp = textField.text ?? ""
        case self.otpEmailTextField:
            self.viewModel.details.emailOtp = textField.text ?? ""
        default:break
        }
    
        
    }
}
