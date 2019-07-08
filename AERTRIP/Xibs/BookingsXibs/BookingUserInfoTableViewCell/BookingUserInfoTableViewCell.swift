//
//  BookingUserInfoTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 24/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingUserInfoTableViewCell: UITableViewCell {

    //MARK:- Variables
    //MARK
    
    
    //MARK:- IBOutlets
    //MARK
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var subtitleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    //MARK:- LifeCycle
    //MARK
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //MARK:- Functions
    //MARK
    private func configUI() {
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.titleLabel.textColor = AppColors.themeGray40
        self.subTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.subTitleLabel.textColor = AppColors.textFieldTextColor51
        self.titleLabelTopConstraint.constant = 8.0
        self.subtitleLabelBottomConstraint.constant = 9.0
    }
    
    internal func configCell(title: String , titleFont: UIFont = AppFonts.SemiBold.withSize(22.0) , titleColor: UIColor = AppColors.themeBlack , subTitle: String , subTitleFont: UIFont = AppFonts.Regular.withSize(16.0) , subTitleColor: UIColor = AppColors.themeGray40) {
        self.titleLabel.text = title
        self.titleLabel.font = titleFont
        self.titleLabel.textColor = titleColor
        self.subTitleLabel.text = subTitle
        self.subTitleLabel.font = subTitleFont
        self.subTitleLabel.textColor = subTitleColor
    }

}
