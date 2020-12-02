//
//  TitleWithSubTitleTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TitleWithSubTitleTableViewCell: UITableViewCell {

    //Mark:- Variables
    //================
    
    
    //Mark:- IBOutlets
    //================
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var dividerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var subtitleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewTrailingConstraint: NSLayoutConstraint!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.titleLabel.textColor = AppColors.themeBlack
        self.subTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.subTitleLabel.textColor = AppColors.themeGray40
        self.titleLabelBottomConstraint.constant = 8.0
        self.titleLabelTopConstraint.constant = 8.0
        self.dividerViewLeadingConstraint.constant = 0.0
        self.dividerViewTrailingConstraint.constant = 0.0
        self.dividerView.isHidden = true
    }
    
    internal func configCell(title: String , titleFont: UIFont = AppFonts.SemiBold.withSize(22.0) , titleColor: UIColor = AppColors.themeBlack , subTitle: String , subTitleFont: UIFont = AppFonts.Regular.withSize(16.0) , subTitleColor: UIColor = AppColors.themeGray40) {
        self.titleLabel.text = title
        self.titleLabel.font = titleFont
        self.titleLabel.textColor = titleColor
        self.subTitleLabel.text = subTitle
        self.subTitleLabel.font = subTitleFont
        self.subTitleLabel.textColor = subTitleColor
        self.containerViewLeadingConstraint.constant = 0.0
        self.containerViewTrailingConstraint.constant = 0.0
        self.dividerViewLeadingConstraint.constant = 16.0
        self.dividerViewTrailingConstraint.constant = 16.0
    }
    
    internal func configHotelBookingDetailsCell(title: String , titleFont: UIFont = AppFonts.Regular.withSize(14.0) , titleColor: UIColor = AppColors.themeBlack , subTitle: String , subTitleFont: UIFont = AppFonts.Regular.withSize(14.0) , subTitleColor: UIColor = AppColors.themeBlack) {
        self.containerViewLeadingConstraint.constant = 16.0
        self.containerViewTrailingConstraint.constant = 16.0
        self.titleLabelTopConstraint.constant = 12.0
        self.titleLabelBottomConstraint.constant = 0.0
        self.subtitleLabelBottomConstraint.constant = 8.0
        self.titleLabel.text = title
        self.titleLabel.font = titleFont
        self.titleLabel.textColor = titleColor
        self.subTitleLabel.text = subTitle
        self.subTitleLabel.font = subTitleFont
        self.subTitleLabel.textColor = subTitleColor
//        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        let shadow = AppShadowProperties()
        self.containerView.addShadow(cornerRadius: 0, maskedCorners: [], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
        self.containerView.backgroundColor = AppColors.themeWhite
        self.backgroundColor = AppColors.themeWhite
        
    }
    
    //Mark:- IBActions
    //================
    
}
