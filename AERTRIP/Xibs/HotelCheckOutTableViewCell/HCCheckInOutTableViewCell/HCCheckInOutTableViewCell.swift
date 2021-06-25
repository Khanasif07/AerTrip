//
//  HCCheckInOutTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCCheckInOutTableViewCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var topDividerView: ATDividerView!
    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var checkOutLabel: UILabel!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nightsContainerView: UIView!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkInDayLabel: UILabel!
    @IBOutlet weak var checkOutDayLabel: UILabel!
    @IBOutlet weak var moonImageView: UIImageView!
    @IBOutlet weak var totalNightsLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkinLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkinDayLabelBottomConstriant: NSLayoutConstraint!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Methods
    //==============
    ///COnfigure UI
    private func configUI() {
        //Font
        self.checkInLabel.font = AppFonts.Regular.withSize(16.0)
        self.checkOutLabel.font = AppFonts.Regular.withSize(16.0)
        self.checkInDateLabel.font = AppFonts.Regular.withSize(26.0)
        self.checkOutDateLabel.font = AppFonts.Regular.withSize(26.0)
        self.checkInDayLabel.font = AppFonts.Regular.withSize(16.0)
        self.checkOutDayLabel.font = AppFonts.Regular.withSize(16.0)
        self.totalNightsLabel.font = AppFonts.SemiBold.withSize(14.0)
        //Text
        self.checkInLabel.text = LocalizedString.CheckIn.localized
        self.checkOutLabel.text = LocalizedString.CheckOut.localized
        //Color
        self.checkInLabel.textColor = AppColors.themeGray40
        self.checkOutLabel.textColor = AppColors.themeGray40
        self.checkInDateLabel.textColor = AppColors.textFieldTextColor51
        self.checkOutDateLabel.textColor = AppColors.textFieldTextColor51
        self.checkInDayLabel.textColor = AppColors.textFieldTextColor51
        self.checkOutDayLabel.textColor = AppColors.textFieldTextColor51
        self.totalNightsLabel.textColor = AppColors.themeBlack
    }
    
    ///COnfigure Cell
    //yyyy-MM-dd
    internal func configCell( checkInDate: String , checkOutDate: String , totalNights: Int) {
        self.checkInDateLabel.text = Date.getDateFromString(stringDate: checkInDate , currentFormat: "yyyy-MM-dd", requiredFormat: "dd MMM")
        self.checkOutDateLabel.text = Date.getDateFromString(stringDate: checkOutDate , currentFormat: "yyyy-MM-dd", requiredFormat: "dd MMM")
        
        if totalNights == 0 {
            var numberOfNights = 0
            if !checkOutDate.isEmpty && !checkInDate.isEmpty{
                numberOfNights = checkOutDate.toDate(dateFormat: "yyyy-MM-dd")!.daysFrom(checkInDate.toDate(dateFormat: "yyyy-MM-dd")!)
            }
            self.totalNightsLabel.text = (numberOfNights == 1) ? "\(numberOfNights) \(LocalizedString.Night.localized)" : "\(numberOfNights) \(LocalizedString.Nights.localized)"
        } else {
            self.totalNightsLabel.text = (totalNights == 1) ? "\(totalNights) \(LocalizedString.Night.localized)" : "\(totalNights) \(LocalizedString.Nights.localized)"
        }
        self.checkInDayLabel.text = Date.getDateFromString(stringDate: checkInDate, currentFormat: "yyyy-MM-dd", requiredFormat: "EEEE")
        self.checkOutDayLabel.text = Date.getDateFromString(stringDate: checkOutDate, currentFormat: "yyyy-MM-dd", requiredFormat: "EEEE")
    }
    
    internal func setupForAllDoneVC() {
        self.containerViewLeadingConstraint.constant = 16
        self.containerViewTrailingConstraint.constant = 16
        self.checkinLabelTopConstraint.constant = 6
        self.checkinDayLabelBottomConstriant.constant = 16
        self.layoutIfNeeded()
        self.topDividerView.isHidden = true
//        self.shadowView.addShadow(cornerRadius: 0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 8.0)
        let shadow = AppShadowProperties()
        self.shadowView.addShadow(cornerRadius: 0, maskedCorners: [], color: shadow.shadowColor, offset: shadow.offset, opacity: shadow.opecity, shadowRadius: shadow.shadowRadius)
        self.checkInLabel.font = AppFonts.Regular.withSize(14.0)
        self.checkOutLabel.font = AppFonts.Regular.withSize(14.0)
        self.checkInDateLabel.font = AppFonts.Regular.withSize(22.0)
        self.checkOutDateLabel.font = AppFonts.Regular.withSize(22.0)
        self.checkInDayLabel.font = AppFonts.Regular.withSize(14.0)
        self.checkOutDayLabel.font = AppFonts.Regular.withSize(14.0)
        self.totalNightsLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.checkInDayLabel.textColor = AppColors.themeGray153
        self.checkOutDayLabel.textColor = AppColors.themeGray153
        self.containerView.backgroundColor = AppColors.themeWhiteDashboard
        self.nightsContainerView.backgroundColor = AppColors.themeWhiteDashboard
    }
}
