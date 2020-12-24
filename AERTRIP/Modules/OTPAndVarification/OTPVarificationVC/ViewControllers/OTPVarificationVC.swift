//
//  OTPVarificationVC.swift
//  AERTRIP
//
//  Created by Appinventiv  on 24/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import ActiveLabel

class OTPVarificationVC: BaseVC {

    @IBOutlet weak var transparentBackView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var oneTimePassLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var otpTextField: PKFloatLabelTextField!
    @IBOutlet weak var resendLabel: ActiveLabel!
    @IBOutlet weak var nextButton: ATButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
        self.setNextButton()
        self.setOptTextField()
        self.linkSetupForResend(withLabel: self.resendLabel, isResend: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.transformViewToOriginalState()
    }
    
    override func setupFonts() {
        self.cancelButton.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        self.cancelButton.addTarget(self, action: #selector(self.tapCancelButton), for: .touchUpInside)
        self.oneTimePassLabel.font = AppFonts.Regular.withSize(24.0)
        self.descriptionLabel.font = AppFonts.Regular.withSize(14.0)
        self.setOptTextField()
    }
    
    override func setupColors() {
        self.cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.oneTimePassLabel.textColor = AppColors.themeBlack
        self.descriptionLabel.textColor = AppColors.themeBlack
    }
    
    override func setupTexts() {
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        self.oneTimePassLabel.text = LocalizedString.oneTimePassword.localized
        self.descriptionLabel.text = LocalizedString.toProceedWalletBalance.localized
        self.resendLabel.text = LocalizedString.oneTimePassword.localized

    }
    func setUpSubView(){
        self.transparentBackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.transparentBackView.layer.masksToBounds = true
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
    private func performDoneBtnAction(_ animationDuration: TimeInterval = 0.3) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.transparentBackView.transform = CGAffineTransform(translationX: 0, y: self.transparentBackView.height)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { (success) in
            self.dismiss(animated: false, completion: {
//                self.onDismissCompletion?()
            })
        }
        
    }
    
    func linkSetupForResend(withLabel: ActiveLabel, isResend: Bool) {
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
            label.handleCustomTap(for: seeExample) { _ in
                
            }
        }
    }
    
    private func setOptTextField(){
        otpTextField.titleYPadding = 12.0
        otpTextField.hintYPadding = 12.0
        otpTextField.titleFont = AppFonts.Regular.withSize(14)
        otpTextField.font = AppFonts.Regular.withSize(18.0)
        otpTextField.textColor = AppColors.themeBlack
        otpTextField.titleTextColour = AppColors.themeGray40
        otpTextField.titleActiveTextColour = AppColors.themeGreen
        otpTextField.textContentType = .oneTimeCode
        otpTextField.selectedLineColor = AppColors.themeGreen
        otpTextField.editingBottom = 0.0
        otpTextField.lineColor = AppColors.themeGray40
        otpTextField.lineErrorColor = AppColors.themeRed
        otpTextField.autocorrectionType = .no
        otpTextField.keyboardType = .numberPad
        otpTextField.placeholder = LocalizedString.enterOtp.localized
    }

    private func setNextButton(){
        self.nextButton.layer.cornerRadius = self.nextButton.height / 2.0
        self.nextButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
        self.nextButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .highlighted)
        self.nextButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)
        self.nextButton.setTitle(LocalizedString.Next.localized, for: .normal)
        self.nextButton.setTitle(LocalizedString.Next.localized, for: .selected)
        self.nextButton.shadowColor = AppColors.appShadowColor
        self.nextButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.nextButton.setTitleColor(AppColors.themeWhite, for: .selected)
        self.nextButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)

    }
    
    
    @objc func tapCancelButton(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
}
