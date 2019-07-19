//
//  HCBookingIncompleteVC.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCBookingIncompleteVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bookingAmountTextLabel: UILabel!
    @IBOutlet weak var bookingAmountLabel: UILabel!
    @IBOutlet weak var paidAmountTextLabel: UILabel!
    @IBOutlet weak var paidAmountLabel: UILabel!
    @IBOutlet weak var balanceAmountTextLabel: UILabel!
    @IBOutlet weak var balanceAmountLabel: UILabel!
    @IBOutlet weak var payButton: ATButton!
    @IBOutlet weak var requestRefundButton: UIButton!
    @IBOutlet weak var bottomMessageLabel: UILabel!
    
    
    //MARK:- Properties
    //MARK:- Public
    
    //MARK:- Private
    private var paymentMethod = "{payment method}"
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.statusBarStyle = .default
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        payButton.layer.cornerRadius = payButton.height / 2
    }
    
    override func initialSetup() {
        topNavView.configureNavBar(title: nil, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false)
        topNavView.delegate = self
    }
    
    override func setupFonts() {
        titleLabel.font = AppFonts.Bold.withSize(38.0)
        messageLabel.font = AppFonts.Regular.withSize(18.0)
        
        bookingAmountTextLabel.font = AppFonts.Regular.withSize(16.0)
        bookingAmountLabel.font = AppFonts.SemiBold.withSize(18.0)
        
        paidAmountTextLabel.font = AppFonts.Regular.withSize(16.0)
        paidAmountLabel.font = AppFonts.SemiBold.withSize(18.0)
        
        balanceAmountTextLabel.font = AppFonts.Regular.withSize(16.0)
        balanceAmountLabel.font = AppFonts.SemiBold.withSize(36.0)
        
        payButton.titleLabel?.font = AppFonts.SemiBold.withSize(17.0)
        
        requestRefundButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        
        bottomMessageLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    override func setupTexts() {
        titleLabel.text = LocalizedString.BookingIncomplete.localized
        messageLabel.text = "\(LocalizedString.YourWalletMoneyOf.localized) \(2000.0.amountInDelimeterWithSymbol) \(LocalizedString.WasUsedForAnotherTransaction.localized)"
        
        bookingAmountTextLabel.text = LocalizedString.BookingAmount.localized
        bookingAmountLabel.text = "\(10000.0.amountInDelimeterWithSymbol)"
        
        paidAmountTextLabel.text = LocalizedString.PaidAmount.localized
        paidAmountLabel.text = "\(8000.0.amountInDelimeterWithSymbol)"
        
        balanceAmountTextLabel.text = LocalizedString.BalanceAmount.localized
        balanceAmountLabel.text = "\(2000.0.amountInDelimeterWithSymbol)"
        
        payButton.setTitle(LocalizedString.Pay.localized, for: .normal)
        
        requestRefundButton.setTitle(LocalizedString.RequestRefund.localized, for: .normal)
        
        bottomMessageLabel.text = "\(LocalizedString.BookingIncompleteBottomMessage.localized) \(paymentMethod)"
    }
    
    override func setupColors() {
        titleLabel.textColor = AppColors.themeBlack
        messageLabel.textColor = AppColors.themeBlack
        
        bookingAmountTextLabel.textColor = AppColors.themeGray40
        bookingAmountLabel.textColor = AppColors.themeBlack
        
        paidAmountTextLabel.textColor = AppColors.themeGray40
        paidAmountLabel.textColor = AppColors.themeBlack
        
        balanceAmountTextLabel.textColor = AppColors.themeRed
        balanceAmountLabel.textColor = AppColors.themeBlack
        
        payButton.setTitleColor(AppColors.themeWhite, for: .normal)
        
        requestRefundButton.setTitleColor(AppColors.themeGreen, for: .normal)
        
        bottomMessageLabel.textColor = AppColors.themeGray60
    }
    
    //MARK:- Methods
    //MARK:- Private
    
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func payButtonAction(_ sender: ATButton) {
        FareUpdatedPopUpVC.showRefundAmountPopUp(refundAmount: 8000.0, paymentMode: self.paymentMethod, confirmButtonAction: {
            printDebug("confirmButtonAction")
            }, cancelButtonAction: {
            printDebug("cancelButtonAction")
        })
    }
    
    @IBAction func requestRefundButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToRefundRequestedVC()
    }
}


//MARK:- TopNavigationView Delegate methods
//MARK:-
extension HCBookingIncompleteVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}
