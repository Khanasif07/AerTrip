//
//  BookingVoucherTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 17/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingVoucherTableViewCell: ATTableViewCell {
    
    
    // MARK:- IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var payNowButton: ATButton!
    @IBOutlet weak var dateLabelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dividerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerView: ATDividerView!
    
    var voucherData: Voucher = Voucher() {
        didSet {
            self.configureCellForVoucher()
        }
    }
    
    var amount: Double = 0.0 {
        didSet {
            self.configureCellForAmount()
        }
    }
    
    var payButtonAction: ((ATButton)->Void)? = nil
    
    
    // MARK: - Override methods
    override func doInitialSetup() {
        self.payNowButton.addGredient(isVertical: false)
        self.payNowButton.layer.cornerRadius = 14.0
        self.payNowButton.layer.masksToBounds = true
        
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        self.dateLabel.font = AppFonts.Regular.withSize(16.0)
        self.priceLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.payNowButton.titleLabel?.font = AppFonts.SemiBold.withSize(16.0)
    }
    
    override func setupTexts() {
        self.payNowButton.setTitle(LocalizedString.PayNow.localized, for: .normal)
        self.payNowButton.setTitle(LocalizedString.PayNow.localized, for: .selected)
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.textFieldTextColor51
        self.dateLabel.textColor = AppColors.themeGray40
        self.priceLabel.textColor = AppColors.textFieldTextColor51
        self.payNowButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.payNowButton.setTitleColor(AppColors.themeWhite, for: .normal)
    }
    
    private func configureCellForAmount() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.dateLabel.textColor = AppColors.themeBlack
        self.dateLabel.font = AppFonts.SemiBold.withSize(24.0)
        self.payNowButton.isHidden = false
        self.priceLabel.isHidden = true
        self.arrowImageView.isHidden = true
        
        self.dateLabel.text = self.amount.amountInDelimeterWithSymbol
        
        if (self.amount < 0) {
            self.payNowButton.setTitle("Get Refund", for: .normal)
            self.payNowButton.isHidden = true
            self.titleLabel.text = "Amount to be refund"
        }
        else {
            self.payNowButton.isHidden = false
            self.payNowButton.setTitle("Pay Now", for: .normal)
            self.titleLabel.text = "Amount to be paid"
        }
        self.dateLabelTopConstraint.constant = 8
        self.dividerViewLeadingConstraint.constant = 0
        self.dividerViewTrailingConstraint.constant = 0
    }
    
    private func configureCellForVoucher() {
        self.titleLabel.textColor = AppColors.textFieldTextColor51
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        self.dateLabel.font = AppFonts.Regular.withSize(16.0)
        self.dateLabel.textColor = AppColors.themeGray40
        self.payNowButton.isHidden = true
        self.priceLabel.isHidden = false
        self.arrowImageView.isHidden = false
        
        var titleStr = ""
        var amount: Double = 0.0
        if let type = self.voucherData.basic?.typeSlug, type == .receipt, let paymentInfo = self.voucherData.paymentInfo {
            titleStr = paymentInfo.paymentTitle
            if let totalTran = self.voucherData.transactions.first {
                amount = totalTran.amount
            }
        }
        else {
            if let totalTran = self.voucherData.transactions.filter({ $0.ledgerName.lowercased() == "total" }).first {
                amount = totalTran.amount
            }
            titleStr = self.voucherData.basic?.type ?? LocalizedString.dash.localized
        }
        
        
        self.titleLabel.text = titleStr
        self.dateLabel.text = self.voucherData.basic?.transactionDateTime?.toString(dateFormat: "EEE, dd MMM yyyy") ?? ""
        
        let drAttr = NSMutableAttributedString(string: " \(LocalizedString.DebitShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])
        let crAttr = NSMutableAttributedString(string: " \(LocalizedString.CreditShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])
        
        let grossStr = abs(amount).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(20.0))
        grossStr.append((amount > 0) ? drAttr : crAttr)
        self.priceLabel.attributedText = grossStr
        
        //        self.priceLabel.text = amount.amountInDelimeterWithSymbol
    }
    
    @IBAction func payNowButtonAction(_ sender: ATButton) {
        if let com = self.payButtonAction {
            com(sender)
        }
    }
}
