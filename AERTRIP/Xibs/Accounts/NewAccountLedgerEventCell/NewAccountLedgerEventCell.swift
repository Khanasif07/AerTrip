//
//  NewAccountLedgerEventCell.swift
//  AERTRIP
//
//  Created by Apple  on 09.07.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class NewAccountLedgerEventCell: UITableViewCell {
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var selectButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectButtonLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var voucherTitleLabel: UILabel!
    @IBOutlet weak var voucherValueLabel: UILabel!
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    @IBOutlet weak var containerTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var currencyChangeStack: UIStackView!
    @IBOutlet weak var changeCurrencyTitleLabel: UILabel!
    @IBOutlet weak var changeCurrencyValueLabel: UILabel!
    
    
    var event: AccountDetailEvent? {
        didSet {
            self.setData()
        }
    }
    
    var isSelectable: Bool = false {
        didSet {
            self.manageSelectable()
        }
    }
    
    var isHotelSelected: Bool = false {
        didSet {
            self.manageSelectedState()
        }
    }
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.setFontAndColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setFontAndColor()
    }
    
    private func setFontAndColor() {
        
        self.mainContainerView.backgroundColor = AppColors.themeWhiteDashboard
        let shadowProp = AppShadowProperties()
        self.mainContainerView.addShadow(cornerRadius: shadowProp.cornerRadius, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: shadowProp.shadowColor, offset: shadowProp.offset, opacity: shadowProp.opecity, shadowRadius: shadowProp.shadowRadius)
//        self.mainContainerView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize(width: 0, height: -1), opacity: 0.5, shadowRadius: 4.0)

        self.backgroundColor = AppColors.themeWhite

        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        
        self.titleLabel.textColor = AppColors.themeBlack
        
        self.isSelectable = false
        self.voucherValueLabel.text = ""
        self.voucherTitleLabel.font = AppFonts.Regular.withSize(18.0)
        self.balanceTitleLabel.font = AppFonts.Regular.withSize(18.0)
        self.changeCurrencyValueLabel.font = AppFonts.Regular.withSize(18.0)
        self.changeCurrencyTitleLabel.font = AppFonts.Regular.withSize(18.0)
        
        self.voucherValueLabel.font = AppFonts.Regular.withSize(14.0)
        self.balanceValueLabel.font = AppFonts.Regular.withSize(14.0)
        
        self.voucherTitleLabel.textColor = AppColors.themeBlack
        self.balanceTitleLabel.textColor = AppColors.themeBlack
        self.voucherValueLabel.textColor = AppColors.themeGray153
        self.balanceValueLabel.textColor = AppColors.themeGray153
        self.changeCurrencyValueLabel.textColor = AppColors.themeGray153
        self.changeCurrencyTitleLabel.textColor = AppColors.themeBlack

        self.voucherTitleLabel.text = LocalizedString.Voucher.localized
        self.balanceTitleLabel.text = LocalizedString.Balance.localized
        self.changeCurrencyValueLabel.text = ""
        self.changeCurrencyTitleLabel.text = ""
        self.currencyChangeStack.isHidden = true
    }
    
    private func manageSelectable() {
        self.selectButtonHeightConstraint.constant = self.isSelectable ? 22.0 : 0.0
        self.selectButtonLeadingConstraint.constant = self.isSelectable ? 16.0 : 0.0
    }
    
    private func manageSelectedState() {
        self.selectionButton.isSelected = self.isHotelSelected
    }
    
    private func setData() {
        self.iconImageView.image = self.event?.iconImage
        if let atbTxt = self.event?.attributedString{
            self.titleLabel.text = nil
            self.titleLabel.attributedText = atbTxt
        }else{
            self.titleLabel.attributedText = nil
            if !(self.event?.title.isEmpty ?? false){
                self.titleLabel.text = self.event?.title
            }else{
                self.titleLabel.text = self.event?.voucherName
            }
        }
        
        self.voucherTitleLabel.text = self.event?.voucherName ?? ""
        
        let suff = (self.event?.amount ?? 0.0) > 0 ? LocalizedString.CreditShort.localized : LocalizedString.DebitShort.localized
//         "\(abs(self.ladgerEvent!.amount).amountInDelimeterWithSymbol) \(suff)", age: "", isEmptyCell: false))
        
        if let matableTxt = abs(self.event?.amount ?? 0.0).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(18.0)).mutableCopy() as? NSMutableAttributedString{
            
            let attStr = NSAttributedString(string: " \(suff)", attributes: [.font: AppFonts.SemiBold.withSize(18.0)])
            matableTxt.append(attStr)
            self.balanceTitleLabel.attributedText = matableTxt
        }else{
            self.balanceTitleLabel.attributedText = (self.event?.amount ?? 0.0).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(18.0))
        }
        
        
        let closingBalanceSuff = (self.event?.balance ?? 0.0) > 0 ? LocalizedString.CreditShort.localized : LocalizedString.DebitShort.localized

    
        let mutableText = NSMutableAttributedString(string: "Closing Balance: ", attributes: [.font: AppFonts.Regular.withSize(12), .foregroundColor: AppColors.themeGray153])
        mutableText.append((self.event?.balance ?? 0.0).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(12.0)))
        
        let closingBalanceSuffAttributedString = NSAttributedString(string: " \(closingBalanceSuff)", attributes: [.font: AppFonts.Regular.withSize(12), .foregroundColor: AppColors.themeGray153])
        mutableText.append(closingBalanceSuffAttributedString)
        
        self.balanceValueLabel.attributedText = mutableText//(self.event?.balance ?? 0.0).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(12.0))
        
        if let currency = self.event?.currencyRate{
            self.currencyChangeStack.isHidden = false
            let attText = abs(self.event?.amount ?? 0.0).convertAmount(with: currency, using: AppFonts.SemiBold.withSize(18.0))
            attText.append(NSAttributedString(string: suff))
            self.changeCurrencyValueLabel.attributedText =  attText
        }else{
            self.currencyChangeStack.isHidden = true
        }
    }
    
    
    ///Price convertor for booking and Account Section
    func getConvertedPrice(for amount: Double, with rate:CurrencyConversionRate?, using font: UIFont) -> NSMutableAttributedString{
        
        if let rate = rate{
            return amount.convertCancellationAmount(with: rate, using: font)
            
        }else{
            return amount.amountInDelimeterWithSymbol.asStylizedPrice(using: font)
        }
    }
    
    
}
