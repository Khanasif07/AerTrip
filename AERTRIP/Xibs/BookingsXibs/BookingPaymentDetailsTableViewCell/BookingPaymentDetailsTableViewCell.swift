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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.costLabel.attributedText = nil
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
        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.15), offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
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
            self.costLabel.attributedText = prcD.amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(16.0))
        }
    }
    
    private func lastCellShadowSetUp(isLastCell: Bool, cellHeight: CGFloat) {
        if isLastCell {
            self.cellHeight.constant = 41.5
            self.dividerView.isHidden = false
            self.containerView.addShadow(cornerRadius: 15.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.15), offset: CGSize.zero, opacity: 1, shadowRadius: 15.0)
            
        } else {
            self.cellHeight.constant = cellHeight // 43.0
            self.dividerView.isHidden = true
            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.15), offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        }
    }
    
    // Mark:- IBActions
    //================
}
