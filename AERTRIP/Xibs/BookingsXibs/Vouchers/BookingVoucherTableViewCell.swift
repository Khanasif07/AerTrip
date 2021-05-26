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
    @IBOutlet weak var paymentTypeImageView: UIImageView!
    @IBOutlet weak var topDividerView: ATDividerView!
    
    
    var voucherData: Voucher = Voucher() {
        didSet {
            self.configureCellForVoucher()
        }
    }
    
//    var amount: Double = 0.0 {
//        didSet {
//            self.configureCellForAmount()
//        }
//    }
    
    var receipt:Receipt? = Receipt(){
        didSet{
            self.configureCellForAmount()
        }
    }
    
    
    var payButtonAction: ((ATButton)->Void)? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.paymentTypeImageView.isHidden = true
        self.topDividerView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.topDividerView.isHidden = true
    }
    
    // MARK: - Override methods
    override func doInitialSetup() {
        self.payNowButton.addGredient(isVertical: false)
        self.payNowButton.layer.cornerRadius = 25.0
        self.payNowButton.layer.masksToBounds = true
        
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        self.dateLabel.font = AppFonts.Regular.withSize(16.0)
        self.priceLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.payNowButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
        self.payNowButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)
        self.payNowButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .highlighted)

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
        let amount = self.receipt?.totalAmountDue ?? 0.0
        let grossStr:NSMutableAttributedString
        if let rate = self.receipt?.currencyRate{
            grossStr = abs(amount).convertAmount(with: rate, using: AppFonts.SemiBold.withSize(24.0))
        }else{
            grossStr = abs(amount).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(24.0))
        }
        
       
//        self.dateLabel.text = self.amount.amountInDelimeterWithSymbol
         self.dateLabel.attributedText = grossStr
        if (amount < 0) {
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
        
        let paymentMethod = self.voucherData.paymentInfo?.method.rawValue ?? LocalizedString.dash.localized
        if paymentMethod == "wallet"{

//            if  self.voucherData.paymentInfo?.walletName.lowercased() == "mobikwik"{
//                paymentTypeImageView.image = AppImage.mobikwik
//
//            }
            
            
            
            switch self.voucherData.paymentInfo?.wallet
            {
            
            case .airtelmoney:
                paymentTypeImageView.image = AppImage.airtelmoney
            case .amazonpay:
                paymentTypeImageView.image = AppImage.amazonpay
            case .freecharge:
                paymentTypeImageView.image = AppImage.freecharge
            case .jiomoney:
                paymentTypeImageView.image = AppImage.jiomoney
            case .mobikwik:
                paymentTypeImageView.image = AppImage.mobikwik
            case .olamoney:
                paymentTypeImageView.image = AppImage.olamoney
            case .paypal:
                paymentTypeImageView.image = AppImage.paypal
            case .payzapp:
                paymentTypeImageView.image = AppImage.payzapp
            case .phonepe:
                paymentTypeImageView.image = AppImage.phonepe
            case .phonepeswitch:
                paymentTypeImageView.image = AppImage.phonepeswitch
                
            default:
                self.paymentTypeImageView.image = AppImage.none
            }
            
            
            
            
        }else{if titleStr.lowercased().contains("netbanking"){
            self.paymentTypeImageView.image = #imageLiteral(resourceName: "netBanking")
        }else{
            self.paymentTypeImageView.image = #imageLiteral(resourceName: "visa")
        }
            
        }
        
        
        if titleStr == LocalizedString.dash.localized{
            self.titleLabel.text = ""
        }else{
            self.titleLabel.text = titleStr
        }
        self.dateLabel.text = self.voucherData.basic?.transactionDateTime?.toString(dateFormat: "EEE, dd MMM yyyy") ?? ""
        
        let drAttr = NSMutableAttributedString(string: " \(LocalizedString.DebitShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])
        let crAttr = NSMutableAttributedString(string: " \(LocalizedString.CreditShort.localized)", attributes: [.font: AppFonts.Regular.withSize(16.0)])
        
        let grossStr:NSMutableAttributedString
        if let rate = self.voucherData.basic?.currencyRate{
            grossStr = abs(amount).convertAmount(with: rate, using: AppFonts.Regular.withSize(22.0))
        }else{
            grossStr = abs(amount).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(22.0))
        }
        
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
