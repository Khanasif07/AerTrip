//
//  FareUpdatedPopUpVC.swift
//  AERTRIP
//
//  Created by Admin on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FareUpdatedPopUpVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var fareIncreasedContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    
    @IBOutlet weak var decreaseContainerView: UIView!
    @IBOutlet weak var decreaseLabel: UILabel!
    @IBOutlet weak var decreaseBottomConstraint: NSLayoutConstraint!
    
    //MARK:- Properties
    //MARK:- Public
    
    //MARK:- Private
    private var continueHandler: (()->Void)?
    private var goBackHandler: (()->Void)?
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
    }
    
    override func setupColors() {
        self.fareIncreasedContainerView.backgroundColor = AppColors.themeWhiteDashboard
        self.decreaseContainerView.backgroundColor = AppColors.themeWhiteDashboard
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setupDecreasePopUp()
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func setupIncreasePopUp() {
        fareIncreasedContainerView.cornerradius = 10.0
        descriptionLabel.font = AppFonts.Regular.withSize(14.0)
        descriptionLabel.textColor = AppColors.themeBlack
        
        continueButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        continueButton.setTitle(LocalizedString.ContinueBooking.localized, for: .normal)
        continueButton.setTitleColor(AppColors.themeGreen, for: .normal)
        
        goBackButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        goBackButton.setTitle(LocalizedString.GoBackToResults.localized, for: .normal)
        goBackButton.setTitleColor(AppColors.themeRed, for: .normal)
    }
    
    private func setupRefundPopUp() {
        fareIncreasedContainerView.cornerradius = 10.0
        descriptionLabel.font = AppFonts.Regular.withSize(14.0)
        descriptionLabel.textColor = AppColors.themeBlack
        
        continueButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        continueButton.setTitle(LocalizedString.Confirm.localized, for: .normal)
        continueButton.setTitleColor(AppColors.themeGreen, for: .normal)
        
        goBackButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        goBackButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        goBackButton.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    private func setupDecreasePopUp() {
        decreaseContainerView.cornerradius = 10.0
        decreaseContainerView.layer.borderWidth = self.isLightTheme() ? 1.0 : 0.0
        decreaseContainerView.layer.borderColor = AppColors.themeGreen.withAlphaComponent(0.2).cgColor
        decreaseContainerView.backgroundColor = AppColors.iceGreen
    }
    
    private func getIncreaseTitleAttrText(forAmount amount: Double, fontColor: UIColor) -> NSMutableAttributedString {
        
        //let currency = "$"
        let finalText = "\(LocalizedString.FareIncreasedBy.localized)\n\(amount.getConvertedAmount(using: AppFonts.Regular.withSize(18)).string)"
        
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: finalText, attributes: [NSAttributedString.Key.foregroundColor: fontColor, NSAttributedString.Key.font: AppFonts.SemiBold.withSize(18.0)])
        
        attString.addAttributes([NSAttributedString.Key.font: AppFonts.Regular.withSize(28.0)], range: (finalText as NSString).range(of: "\(amount.getConvertedAmount(using: AppFonts.Regular.withSize(18)).string)"))

        return attString
    }
    
    private func updateIncreasePopUp(increasedAmount: Double, totalUpdatedAmount: Double) {
        setupIncreasePopUp()
        titleLabel.attributedText = getIncreaseTitleAttrText(forAmount: increasedAmount, fontColor: AppColors.themeRed)
        
        descriptionLabel.text = "\(LocalizedString.TotalUpdatedPrice.localized) \(totalUpdatedAmount.getConvertedAmount(using: AppFonts.Regular.withSize(14)).string)"
    }
    
    private func updateRefundPopUp(refundAmount: Double, paymentMode: String) {
        setupRefundPopUp()
        titleLabel.attributedText = getIncreaseTitleAttrText(forAmount: refundAmount, fontColor: AppColors.themeBlack)

        descriptionLabel.text = "\(LocalizedString.ThisWillCancelThisBookingAndAmountRefundToPayment.localized) \(paymentMode)"
    }
    
    private func updateDecreasePopUp(decreasedAmount: Double) {
        setupDecreasePopUp()
        //let currency = "$"
        let attrText = AppGlobals.shared.getTextWithImage(startText: "", image: AppImages.ic_fare_dipped, endText: "   \(LocalizedString.FareDippedBy.localized)  \(decreasedAmount.getPriceStringWithCurrency)", font: AppFonts.Regular.withSize(16.0))
        attrText.addAttributes([NSAttributedString.Key.foregroundColor: AppColors.themeGreen], range: (attrText.string as NSString).range(of: attrText.string))
        
        decreaseLabel.attributedText = attrText
    }
    
    private func setVisiblityForIncreasedPopUp(isHidden: Bool, animated: Bool) {
        fareIncreasedContainerView.isHidden = isHidden
        if isHidden {
            removeMe()
        }
    }
    
    private func setVisiblityForDecreasedPopUp(isHidden: Bool, animated: Bool) {
        decreaseContainerView.isHidden = isHidden
        if isHidden {
            removeMe()
        }
    }
    
    private func hideIncreasedPopUp() {
        fareIncreasedContainerView.isHidden = true
    }
    
    private func hideDecreasedPopUp() {
        decreaseContainerView.isHidden = true
    }
    
    private func removeMe() {
        self.removeFromParentVC
    }
    
    //MARK:- Public
    func showIncreasedPopUp(increasedAmount: Double, totalUpdatedAmount: Double, continueButtonAction: (()->Void)?, goBackButtonAction: (()->Void)?) {
        
        view.backgroundColor = AppColors.unicolorBlack.withAlphaComponent(0.3)
        view.isUserInteractionEnabled = true
        hideDecreasedPopUp()
        continueHandler = continueButtonAction
        goBackHandler = goBackButtonAction
        updateIncreasePopUp(increasedAmount: increasedAmount, totalUpdatedAmount: totalUpdatedAmount)
        setVisiblityForIncreasedPopUp(isHidden: false, animated: true)
    }
    
    func showRefundPopUp(refundAmount: Double, paymentMode: String, confirmButtonAction: (()->Void)?, cancelButtonAction: (()->Void)?) {
        
        view.backgroundColor = AppColors.unicolorBlack.withAlphaComponent(0.3)
        view.isUserInteractionEnabled = true
        hideDecreasedPopUp()
        continueHandler = confirmButtonAction
        goBackHandler = cancelButtonAction
        updateRefundPopUp(refundAmount: refundAmount, paymentMode: paymentMode)
        setVisiblityForIncreasedPopUp(isHidden: false, animated: true)
    }
    
    func showDecreasedPopUp(decreasedAmount: Double) {
        view.backgroundColor = AppColors.clear
        view.isUserInteractionEnabled = false
        hideIncreasedPopUp()
        updateDecreasePopUp(decreasedAmount: decreasedAmount)
        setVisiblityForDecreasedPopUp(isHidden: false, animated: true)
        
        delay(seconds: 2.0) {[weak self] in
            self?.setVisiblityForDecreasedPopUp(isHidden: true, animated: true)
        }
    }
    
    class func showPopUp(isForIncreased: Bool, decreasedAmount: Double, increasedAmount: Double, totalUpdatedAmount: Double, continueButtonAction: (()->Void)?, goBackButtonAction: (()->Void)?){
        
        if let topVC = UIApplication.topViewController() {
            let obj = FareUpdatedPopUpVC.instantiate(fromAppStoryboard: .HotelCheckout)
            
            topVC.add(childViewController: obj)
            
            if isForIncreased {
                obj.showIncreasedPopUp(increasedAmount: increasedAmount, totalUpdatedAmount: totalUpdatedAmount, continueButtonAction: continueButtonAction, goBackButtonAction: goBackButtonAction)
            }
            else {
                obj.showDecreasedPopUp(decreasedAmount: decreasedAmount)
            }
        }
    }
    
    class func showRefundAmountPopUp(refundAmount: Double, paymentMode: String, confirmButtonAction: (()->Void)?, cancelButtonAction: (()->Void)?) {
        
        if let topVC = UIApplication.topViewController() {
            let obj = FareUpdatedPopUpVC.instantiate(fromAppStoryboard: .HotelCheckout)
            
            topVC.add(childViewController: obj)
            
            obj.showRefundPopUp(refundAmount: refundAmount, paymentMode: paymentMode, confirmButtonAction: confirmButtonAction, cancelButtonAction: cancelButtonAction)
        }
    }
    
    //MARK:- Action
    @IBAction func continueButtonAction(_ sender: UIButton) {
        setVisiblityForIncreasedPopUp(isHidden: true, animated: true)
        if let handler = continueHandler {
            handler()
        }
    }
    
    @IBAction func goBackButtonAction(_ sender: UIButton) {
        setVisiblityForIncreasedPopUp(isHidden: true, animated: true)
        if let handler = goBackHandler {
            handler()
        }
    }
}
