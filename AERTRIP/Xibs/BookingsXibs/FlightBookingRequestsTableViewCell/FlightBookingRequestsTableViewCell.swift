//
//  FlightBookingRequestsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
enum ResolutionStatus: String {
    case paymentPending = "Payment Pending"
    case actionRequired = "Action Required"
    case successfull = "Successful"
    case inProgress = "In Progress"
    case aborted = "Aborted"
}

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
    
    // MARK: - Functions
    
    // MARK: ===========
    
    private func configureUI() {
        self.requestNameLabel.font = AppFonts.Regular.withSize(18.0)
        self.requestNameLabel.textColor = AppColors.textFieldTextColor51
        self.actionStatusLabel.font = AppFonts.Regular.withSize(14.0)
        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
    }
    
    internal func configureCell(requestName: String, actionStatus: String, actionStatusColor: UIColor = AppColors.themeYellow, isFirstCell: Bool, isLastCell: Bool, isStatusExpired: Bool) {
        self.requestNameLabel.text = requestName
        self.actionStatusLabel.text = actionStatus
        switch actionStatus {
        case ResolutionStatus.paymentPending.rawValue, ResolutionStatus.actionRequired.rawValue:
            self.actionStatusLabel.textColor = AppColors.themeRed
            
        case ResolutionStatus.successfull.rawValue:
            self.actionStatusLabel.textColor = AppColors.themeGreen
        case ResolutionStatus.inProgress.rawValue:
            self.actionStatusLabel.textColor = AppColors.themeYellow
            
        case ResolutionStatus.aborted.rawValue:
            self.requestNameLabel.textColor =
                self.actionStatusLabel.textColor
        default:
            break
        }
        
        self.containerViewTopConstraint.constant = isFirstCell ? 10.0 : 0.0
        
        // Commented as not required here ,manaed  using enum
//        if isStatusExpired {
//            self.actionStatusLabel.textColor = AppColors.themeGray20
//            self.requestNameLabel.textColor = AppColors.themeGray20
//        } else {
//            self.actionStatusLabel.textColor = actionStatusColor
//            self.requestNameLabel.textColor = AppColors.textFieldTextColor51
//        }
        
        if isLastCell {
            self.containerViewBottomConstraint.constant = 26.0
            self.dividerView.isHidden = true
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        } else {
            self.containerViewBottomConstraint.constant = 0.0
            self.dividerView.isHidden = false
            
            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        }
        
        if isFirstCell {
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        }
    }
}
