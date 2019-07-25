//
//  FlightBookingRequestsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightBookingRequestsTableViewCell: UITableViewCell {
    // MARK: - Variables
    
    // MARK: ===========
    
    // MARK: - IBOutlets
    
    // MARK: ===========
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var requestNameLabel: UILabel!
    @IBOutlet var actionStatusLabel: UILabel!
    @IBOutlet var rightArrowImageView: UIImageView!
    @IBOutlet var dividerView: ATDividerView!
    @IBOutlet var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var containerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //removing all shadow
        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeWhite.withAlphaComponent(0.0001), offset: CGSize.zero, opacity: 0.0, shadowRadius: 0.0)
    }
    
    // MARK: - Functions
    
    // MARK: ===========
    
    private func configureUI() {
        self.requestNameLabel.font = AppFonts.Regular.withSize(18.0)
        self.requestNameLabel.textColor = AppColors.textFieldTextColor51
        self.actionStatusLabel.font = AppFonts.Regular.withSize(14.0)
        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
    }
    
    internal func configureCell(requestName: String, actionStatus: ResolutionStatus, actionStatusColor: UIColor = AppColors.themeYellow, isFirstCell: Bool, isLastCell: Bool, isStatusExpired: Bool) {
        self.requestNameLabel.text = requestName
        self.actionStatusLabel.text = actionStatus.rawValue
        self.actionStatusLabel.textColor = actionStatus.textColor

        self.containerViewTopConstraint.constant = isFirstCell ? 10.0 : 0.0
        
        // Commented as not required here ,manaed  using enum
//        if isStatusExpired {
//            self.actionStatusLabel.textColor = AppColors.themeGray20
//            self.requestNameLabel.textColor = AppColors.themeGray20
//        } else {
//            self.actionStatusLabel.textColor = actionStatusColor
//            self.requestNameLabel.textColor = AppColors.textFieldTextColor51
//        }
        
        if isLastCell, isFirstCell {
            //both
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
            self.containerViewBottomConstraint.constant = 26.0
            self.dividerView.isHidden = true
        }
        else if isLastCell {
            self.containerViewBottomConstraint.constant = 26.0
            self.dividerView.isHidden = true
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        }
        else if isFirstCell {
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        }
        else {
            self.containerViewBottomConstraint.constant = 0.0
            self.dividerView.isHidden = false
            
            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        }
    }
}
