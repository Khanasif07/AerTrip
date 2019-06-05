//
//  ParallelLabelsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 03/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ParallelLabelsTableViewCell: UITableViewCell {

    //MARK:- Variables
    //MARK:===========
    
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var lebelsStackView: UIStackView!
    @IBOutlet weak var leftTitle: UILabel!
    @IBOutlet weak var rightTitle: UILabel!
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTrailingTopConstraint: NSLayoutConstraint!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func configureUI() {
        self.leftTitle.font = AppFonts.Regular.withSize(18.0)
        self.rightTitle.font = AppFonts.Regular.withSize(18.0)
        self.stackViewTopConstraint.constant = 10.0
        self.stackViewBottomConstraint.constant = 11.0
        self.leftTitle.textColor = AppColors.themeBlack
        self.rightTitle.textColor = AppColors.themeBlack
    }
    
    internal func configureCell(leftTitle: String , rightTitle: String , topConstraint: CGFloat = 10.0 , bottomConstraint: CGFloat = 11.0, leftTitleFont: UIFont = AppFonts.Regular.withSize(18.0) , rightTitleFont: UIFont = AppFonts.Regular.withSize(18.0) , leftTitleTextColor: UIColor = AppColors.themeBlack , rightTitleTextColor: UIColor = AppColors.themeBlack) {
        self.leftTitle.text = leftTitle
        self.rightTitle.text = rightTitle
        self.leftTitle.font = leftTitleFont
        self.rightTitle.font = rightTitleFont
        self.stackViewTopConstraint.constant = topConstraint
        self.stackViewBottomConstraint.constant = bottomConstraint
        self.leftTitle.textColor = leftTitleTextColor
        self.rightTitle.textColor = rightTitleTextColor
    }
   
}
