//
//  FlightPaymentPendingVC.swift
//  AERTRIP
//
//  Created by Apple  on 08.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightPaymentPendingVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var walletMoneyUseLabel: UILabel!
    @IBOutlet weak var bookingAmoutTitleLabel: UILabel!
    @IBOutlet weak var bookingAmountValueLabel: UILabel!
    @IBOutlet weak var paidAmountTitleLabel: UILabel!
    @IBOutlet weak var paidAmountValueLabel: UILabel!
    @IBOutlet weak var balanceAmountTitleLabel: UILabel!
    @IBOutlet weak var balanceAmountValueLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var requestRefaundButton: UIButton!
    @IBOutlet weak var autoRefunddescriptionLabel: UILabel!
    
    
    var viewModel = FlightPaymentPendingVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
        self.setFontColor()
        self.setTitle()
        self.viewModel.getItineraryDetails()
    }
    
    @IBAction func tappedPaybutton(_ sender: UIButton) {
    }
    
    @IBAction func tappedRefundButton(_ sender: UIButton) {
        FareUpdatedPopUpVC.showRefundAmountPopUp(refundAmount: 4354, paymentMode: "netbanking", confirmButtonAction: {
            printDebug("confirm button tapped")
        }) {
            printDebug("cancel button tapped")
        }
    }
    
    
    
    private func setupFont(){
        self.titleLabel.font = AppFonts.c.withSize(38.0)
        self.walletMoneyUseLabel.font = AppFonts.Regular.withSize(18.0)
        self.bookingAmoutTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.bookingAmountValueLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.paidAmountTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.paidAmountValueLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.balanceAmountTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.balanceAmountValueLabel.font = AppFonts.SemiBold.withSize(36.0)
        self.payButton.titleLabel?.font = AppFonts.SemiBold.withSize(17.0)
        self.requestRefaundButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)
        self.autoRefunddescriptionLabel.font = AppFonts.Regular.withSize(14.0)
        self.payButton.addGredient(isVertical: false, cornerRadius: 25)
        self.payButton.clipsToBounds = true
        self.payButton.layer.cornerRadius = 25.0
    }
    
    private func setFontColor(){
        self.titleLabel.textColor = AppColors.themeBlack
        self.walletMoneyUseLabel.textColor = AppColors.themeBlack
        self.bookingAmoutTitleLabel.textColor = AppColors.themeGray40
        self.bookingAmountValueLabel.textColor = AppColors.themeBlack
        self.paidAmountTitleLabel.textColor = AppColors.themeGray40
        self.paidAmountValueLabel.textColor = AppColors.themeBlack
        self.balanceAmountTitleLabel.textColor = AppColors.themeRed
        self.balanceAmountValueLabel.textColor = AppColors.themeBlack
        self.payButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.requestRefaundButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.autoRefunddescriptionLabel.textColor = AppColors.themeGray60

    }
    
    private func setTitle(){
        self.titleLabel.text = "Booking\nIncomplete"
        self.walletMoneyUseLabel.text = "Your wallet money of ₹ 2,000 was used for another transaction."
        self.bookingAmoutTitleLabel.text = "Booking Amount"
        self.bookingAmountValueLabel.text = "₹ 10,000"
        self.paidAmountTitleLabel.text = "Paid Amount"
        self.paidAmountValueLabel.text = "₹ 8,000"
        self.balanceAmountTitleLabel.text = "Balance Amount"
        self.balanceAmountValueLabel.text = "₹ 2,000"
        self.payButton.setTitle("Pay", for: .normal)
        self.requestRefaundButton.setTitle("Request refund", for: .normal)
        self.autoRefunddescriptionLabel.text = "If you don’t take any action now, your amount will be auto-refunded to your {Mode of Payment}."//Need to add value for payment mode
    }
    
}
