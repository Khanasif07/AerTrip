//
//  FlightBookingRequestsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightBookingRequestsTableViewCell: UITableViewCell {
    
    
    //MARK:- Variables
    //MARK:===========
    
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var requestNameLabel: UILabel!
    @IBOutlet weak var actionStatusLabel: UILabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func configureUI() {
        self.requestNameLabel.font = AppFonts.Regular.withSize(18.0)
        self.requestNameLabel.textColor = AppColors.textFieldTextColor51
        self.actionStatusLabel.font = AppFonts.Regular.withSize(14.0)
//        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
    }
    
    internal func configureCell(requestName: String, actionStatus: String , actionStatusColor: UIColor, isFirstCell: Bool, isLastCell: Bool , isStatusExpired: Bool) {
        self.requestNameLabel.text = requestName
        self.actionStatusLabel.text = actionStatus
        self.actionStatusLabel.textColor = actionStatusColor
        
        self.containerViewTopConstraint.constant = isFirstCell ? 10.0 : 0.0
        
        if isStatusExpired {
            self.actionStatusLabel.textColor = AppColors.themeGray20
            self.requestNameLabel.textColor = AppColors.themeGray20
        } else {
            self.actionStatusLabel.textColor = actionStatusColor
            self.requestNameLabel.textColor = AppColors.textFieldTextColor51
        }
        
        if isLastCell {
            self.containerViewBottomConstraint.constant = 26.0
            self.dividerView.isHidden = true
//            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner ,.layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner ,.layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        } else {
            self.containerViewBottomConstraint.constant = 0.0
            self.dividerView.isHidden = false
//            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)

        }
        
        if isFirstCell {
//            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        }
    }
    
    //MARK:- IBActions
    //MARK:===========
    
}
