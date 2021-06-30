//
//  PaymentPendingTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class PaymentPendingTableViewCell: UITableViewCell {
    
    //MARK:- Variables
    //MARK:===========
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gradiyentView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        //Font
        self.priceLabel.font = AppFonts.Regular.withSize(20.0)
        
        //Color
        self.priceLabel.textColor = AppColors.unicolorWhite
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configUI()
        delay(seconds: 0.05) {
            self.configUI()
        }
    }
    
    
    //MARK:- Functions
    //MARK:===========
    private func configUI() {
        
        //self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
//        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
//        self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        let shadow = AppShadowProperties()
        self.containerView.addShadow(cornerRadius: shadow.cornerRadius, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
        self.gradiyentView.addGredientWithScreenWidth(isVertical: false, cornerRadius: 0.0, colors: AppConstants.appthemeGradientColors, spacing: 16.0)
        self.gradiyentView.roundBottomCorners(cornerRadius: 10.0)
        
    }
    
    internal func configCell(price: Double) {
        let attributedString = NSMutableAttributedString()
        let textAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(20.0), NSAttributedString.Key.foregroundColor: AppColors.unicolorWhite] as [NSAttributedString.Key : Any]
        //let priceAttribute = [NSAttributedString.Key.font: AppFonts.SemiBold.withSize(20.0), NSAttributedString.Key.foregroundColor: AppColors.themeWhite]
        let text = price > 0 ? LocalizedString.PaymentPending.localized :LocalizedString.AmountToBeRefunded.localized
        let textAttributedString = NSAttributedString(string: text, attributes: textAttribute)
        //let priceAttributedString = NSAttributedString(string: price.delimiterWithSymbol, attributes: priceAttribute)
        
        let drAttr = NSMutableAttributedString(string: " \(LocalizedString.DebitShort.localized)", attributes: [.font: AppFonts.SemiBold.withSize(20.0)])
            let crAttr = NSMutableAttributedString(string: " \(LocalizedString.CreditShort.localized)", attributes: [.font: AppFonts.SemiBold.withSize(20.0)])
            let priceAttributedString = price.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(20.0))
        priceAttributedString.append((price > 0) ? drAttr : crAttr)
                
        //        let priceAttributedString = price.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(20.0))
                
        //        attributedString.append(priceAttributedString)

        attributedString.append(textAttributedString)
        attributedString.append(priceAttributedString)
        self.priceLabel.attributedText = attributedString
        
        
    }
    
    
    internal func configCurrencyChange(price: Double, attPrice: NSMutableAttributedString) {
        let attributedString = NSMutableAttributedString()
        let textAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(20.0), NSAttributedString.Key.foregroundColor: AppColors.unicolorWhite] as [NSAttributedString.Key : Any]
        let text = price > 0 ? LocalizedString.PaymentPending.localized :LocalizedString.AmountToBeRefunded.localized
        let textAttributedString = NSAttributedString(string: text, attributes: textAttribute)
        let drAttr = NSMutableAttributedString(string: " \(LocalizedString.DebitShort.localized)", attributes: [.font: AppFonts.SemiBold.withSize(20.0)])
            let crAttr = NSMutableAttributedString(string: " \(LocalizedString.CreditShort.localized)", attributes: [.font: AppFonts.SemiBold.withSize(20.0)])
            let priceAttributedString = attPrice
        priceAttributedString.append((price > 0) ? drAttr : crAttr)

        attributedString.append(textAttributedString)
        attributedString.append(priceAttributedString)
        self.priceLabel.attributedText = attributedString
        
        
    }
    
    
}

//MARK:- Extensions
//MARK:============

