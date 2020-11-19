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
        self.priceLabel.textColor = AppColors.themeWhite
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configUI()
    }
    
    
    //MARK:- Functions
    //MARK:===========
    private func configUI() {
        
        //self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
//        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        self.gradiyentView.addGredientWithScreenWidth(isVertical: false, cornerRadius: 0.0, colors: AppConstants.appthemeGradientColors, spacing: 16.0)
        self.gradiyentView.roundBottomCorners(cornerRadius: 10.0)
        
    }
    
    internal func configCell(price: Double) {
        let attributedString = NSMutableAttributedString()
        let textAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(20.0), NSAttributedString.Key.foregroundColor: AppColors.themeWhite] as [NSAttributedString.Key : Any]
        //let priceAttribute = [NSAttributedString.Key.font: AppFonts.SemiBold.withSize(20.0), NSAttributedString.Key.foregroundColor: AppColors.themeWhite]
        let text = price > 0 ? LocalizedString.PaymentPending.localized :LocalizedString.AmountToBeRefunded.localized
        let textAttributedString = NSAttributedString(string: text, attributes: textAttribute)
        //let priceAttributedString = NSAttributedString(string: price.delimiterWithSymbol, attributes: priceAttribute)
        
        let priceAttributedString = price.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.SemiBold.withSize(20.0))
        
        attributedString.append(textAttributedString)
        attributedString.append(priceAttributedString)
        self.priceLabel.attributedText = attributedString
        
        
    }
    
    
    
}

//MARK:- Extensions
//MARK:============

