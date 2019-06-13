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
    }
    
    //MARK:- Functions
    //MARK:===========
    private func configUI() {
        //Font
        self.priceLabel.font = AppFonts.Regular.withSize(20.0)
        
        //Color
        self.priceLabel.textColor = AppColors.themeWhite
        
        //        self.shadowView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.5, shadowRadius: 6.0)
        
//        self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner ,.layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        self.gradiyentView.addGredient(isVertical: true, cornerRadius: 0.0, colors: [AppColors.themeGreen, AppColors.shadowBlue])
        self.gradiyentView.roundBottomCorners(cornerRadius: 10.0)
        
    }
    
    internal func configCell(price: String) {
        let attributedString = NSMutableAttributedString()
        let textAttribute = [NSAttributedString.Key.font: AppFonts.Regular.withSize(20.0), NSAttributedString.Key.foregroundColor: AppColors.themeWhite] as [NSAttributedString.Key : Any]
        let priceAttribute = [NSAttributedString.Key.font: AppFonts.SemiBold.withSize(20.0), NSAttributedString.Key.foregroundColor: AppColors.themeWhite]
        let textAttributedString = NSAttributedString(string: LocalizedString.PaymentPending.localized, attributes: textAttribute)
        let priceAttributedString = NSAttributedString(string: price, attributes: priceAttribute)
        attributedString.append(textAttributedString)
        attributedString.append(priceAttributedString)
        self.priceLabel.attributedText = attributedString
    }
    
    
    
}

//MARK:- Extensions
//MARK:============
