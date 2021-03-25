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
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var requestNameLabel: UILabel!
    @IBOutlet weak var actionStatusLabel: UILabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
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
//        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        let shadow = AppShadowProperties()
        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
        
    }
    
    internal func configureCell(requestName: String, actionStatus: ResolutionStatus, actionStatusColor: UIColor = AppColors.themeYellow, isFirstCell: Bool, isLastCell: Bool, isStatusExpired: Bool) {
        self.requestNameLabel.text = requestName
        
        if actionStatus.rawValue.lowercased() == "aborted" ||
            actionStatus.rawValue.lowercased() == "terminated" {
            self.requestNameLabel.textColor = AppColors.themeGray20
        } else {
            self.requestNameLabel.textColor = AppColors.textFieldTextColor51
        }

        self.actionStatusLabel.text = actionStatus.rawValue

        if actionStatus.rawValue.lowercased() == "confirmation pending"{
            self.actionStatusLabel.textColor = AppColors.themeRed
        }else{
            self.actionStatusLabel.textColor = actionStatus.textColor
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
        
        if isLastCell, isFirstCell {
            //both
            //self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
            //self.containerView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.15), offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
//            self.containerView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
            let shadow = AppShadowProperties()
            self.containerView.addShadow(cornerRadius: shadow.cornerRadius, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
            self.containerViewBottomConstraint.constant = 22.5 //26.0
            self.dividerView.isHidden = true
        }
        else if isLastCell {
            self.containerViewBottomConstraint.constant = 22.5 //26.0
            self.dividerView.isHidden = true
            //self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
            //self.containerView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.15), offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
//            self.containerView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
            let shadow = AppShadowProperties()
            self.containerView.addShadow(cornerRadius: shadow.cornerRadius, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
        }
        else if isFirstCell {
            self.containerViewBottomConstraint.constant = 0.0
            self.dividerView.isHidden = false
            
            //self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
            //self.containerView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.15), offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
//            self.containerView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
            let shadow = AppShadowProperties()
            self.containerView.addShadow(cornerRadius: shadow.cornerRadius, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
        }
        else {
            self.containerViewBottomConstraint.constant = 0.0
            self.dividerView.isHidden = false
            
            //self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
//            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
            let shadow = AppShadowProperties()
            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
        }
    }
}
