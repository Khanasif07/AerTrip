//
//  BookingPaymentDetailsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingPaymentDetailsTableViewCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        self.titleLabel.font = AppFonts.Regular.withSize(16.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.costLabel.font = AppFonts.Regular.withSize(16.0)
        self.costLabel.textColor = AppColors.textFieldTextColor51
        self.clipsToBounds = true
        self.dividerView.isHidden = true
        self.rightArrowImageView.isHidden = true
        self.containerViewTopConstraint.constant = 0.0
        self.containerViewBottomConstraint.constant = 0.0
        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
    }
    
    internal func configCell(title: String , titleFont: UIFont = AppFonts.Regular.withSize(16.0) , titleColor: UIColor = AppColors.themeBlack , isFirstCell: Bool , price: String? = nil , isLastCell: Bool) {
        self.firstCellShadowSetUp(isFirstCell: isFirstCell)
        self.lastCellShadowSetUp(isLastCell: isLastCell)
        self.titleLabel.text = title
        self.costLabel.text = price
    }
    
    private func firstCellShadowSetUp(isFirstCell: Bool) {
        if isFirstCell {
            self.rightArrowImageView.isHidden = false
            self.costLabel.isHidden = true
            self.titleLabel.font = AppFonts.Regular.withSize(14.0)
            self.titleLabel.textColor = AppColors.themeGray40
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
        } else {
            return
        }
    }
    
    private func lastCellShadowSetUp(isLastCell: Bool) {
        if isLastCell {
            self.dividerView.isHidden = false
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner ,.layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
        } else {
            return
        }
    }
    
    
    //Mark:- IBActions
    //================
    
}
