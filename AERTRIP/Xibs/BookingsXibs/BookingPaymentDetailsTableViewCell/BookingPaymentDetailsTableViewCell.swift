//
//  BookingPaymentDetailsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingPaymentDetailsTableViewCell: UITableViewCell {
    // Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    // Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        self.containerView.backgroundColor = AppColors.themeWhiteDashboard
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.costLabel.attributedText = nil
        self.containerView.backgroundColor = AppColors.themeWhiteDashboard
    }
    
    // Mark:- Functions
    //================
    private func configUI() {
        self.titleLabel.font = AppFonts.Regular.withSize(16.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.costLabel.font = AppFonts.Regular.withSize(16.0)
        self.costLabel.textColor = AppColors.textFieldTextColor51
        self.clipsToBounds = true
        self.dividerView.isHidden = true
        self.cellHeight.constant = 41.5
        self.containerViewBottomConstraint.constant = 0.0
        //self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
//        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        let shadow = AppShadowProperties()
        self.containerView.addShadow(cornerRadius: 0, maskedCorners: [], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
    }
    
    internal func configCell(title: String, titleFont: UIFont = AppFonts.Regular.withSize(16.0), titleColor: UIColor = AppColors.themeBlack, isFirstCell: Bool, price: String? = nil, isLastCell: Bool, cellHeight: CGFloat = 41.0) {
        self.lastCellShadowSetUp(isLastCell: isLastCell, cellHeight: cellHeight)
        self.titleLabel.textColor = titleColor
        self.costLabel.textColor = titleColor
        self.titleLabel.font = titleFont
        self.costLabel.font = titleFont
        self.titleLabel.text = title
        
        self.costLabel.text = price

        if let prc = price, let prcD = prc.toDouble {

            let drAttr = NSMutableAttributedString(string: " \(LocalizedString.DebitShort.localized)", attributes: [.font: titleFont])
                let crAttr = NSMutableAttributedString(string: " \(LocalizedString.CreditShort.localized)", attributes: [.font: titleFont])
                let cost = abs(prcD).amountInDelimeterWithSymbol.asStylizedPrice(using: titleFont)
            
            cost.append((prcD > 0) ? drAttr : crAttr)
            self.costLabel.attributedText = cost
        }
    }
    
    
    internal func configCellForAmount(title: String, titleFont: UIFont = AppFonts.Regular.withSize(16.0), titleColor: UIColor = AppColors.themeBlack, isFirstCell: Bool, price: NSMutableAttributedString, priceInRupee: Double, isLastCell: Bool, cellHeight: CGFloat = 41.0) {
        self.lastCellShadowSetUp(isLastCell: isLastCell, cellHeight: cellHeight)
        self.titleLabel.textColor = titleColor
        self.costLabel.textColor = titleColor
        self.titleLabel.font = titleFont
        self.costLabel.font = titleFont
        self.titleLabel.text = title
        let drAttr = NSMutableAttributedString(string: " \(LocalizedString.DebitShort.localized)", attributes: [.font: titleFont])
        let crAttr = NSMutableAttributedString(string: " \(LocalizedString.CreditShort.localized)", attributes: [.font: titleFont])
        let cost = price
        
        cost.append((priceInRupee > 0) ? drAttr : crAttr)
        self.costLabel.attributedText = cost
        
    }
    
    
    private func lastCellShadowSetUp(isLastCell: Bool, cellHeight: CGFloat) {
        if isLastCell {
            self.cellHeight.constant = 41.5
            self.dividerView.isHidden = false
//            self.containerView.addShadow(cornerRadius: 15.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
            let shadow = AppShadowProperties()
            self.containerView.addShadow(cornerRadius: 15.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
            
        } else {
            self.cellHeight.constant = cellHeight // 43.0
            self.dividerView.isHidden = true
//            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
            let shadow = AppShadowProperties()
            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
        }
    }
    
    // Mark:- IBActions
    //================
}
