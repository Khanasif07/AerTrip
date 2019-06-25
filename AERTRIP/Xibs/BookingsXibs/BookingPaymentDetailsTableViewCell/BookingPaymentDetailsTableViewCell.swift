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
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var dividerView: ATDividerView!
    @IBOutlet var cellHeight: NSLayoutConstraint!
    @IBOutlet var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var containerViewBottomConstraint: NSLayoutConstraint!
    
    // Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
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
        self.cellHeight.constant = 43.0
        self.containerViewBottomConstraint.constant = 0.0
        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
    }
    
    internal func configCell(title: String, titleFont: UIFont = AppFonts.Regular.withSize(16.0), titleColor: UIColor = AppColors.themeBlack, isFirstCell: Bool, price: String? = nil, isLastCell: Bool, cellHeight: CGFloat = 43.0) {
        self.lastCellShadowSetUp(isLastCell: isLastCell, cellHeight: cellHeight)
        self.titleLabel.textColor = titleColor
        self.costLabel.textColor = titleColor
        self.titleLabel.font = titleFont
        self.costLabel.font = titleFont
        self.titleLabel.text = title
        self.costLabel.text = price
    }
    
    private func lastCellShadowSetUp(isLastCell: Bool, cellHeight: CGFloat) {
        if isLastCell {
            self.cellHeight.constant = 48.0
            self.dividerView.isHidden = false
            self.containerView.addShadow(cornerRadius: 15.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.themeRed.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 15.0)
            
        } else {
            self.cellHeight.constant = cellHeight // 43.0
            self.dividerView.isHidden = true
            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        }
    }
    
    // Mark:- IBActions
    //================
}
