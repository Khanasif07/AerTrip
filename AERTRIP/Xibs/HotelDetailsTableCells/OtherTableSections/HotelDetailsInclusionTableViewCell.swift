//
//  HotelDetailsInclusionTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 13/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsInclusionTableViewCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var inclusionLabel: UILabel!
    @IBOutlet weak var inclusionTypeLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var inclusionLabelBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var inclusionTypeLabelBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var shadowViewLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var shadowViewTrailingConstraints: NSLayoutConstraint!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //Mark:- Methods
    //==============
    ///Configure UI
    private func configureUI() {
        self.dividerView.isHidden = true
        self.shadowView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize(width: 0.0, height: 5.0), opacity: 0.7, shadowRadius: 8.0)
//        self.shadowView.addshadowOnSelectedEdge(top: false, left: true, bottom: false, right: true, opacity: 0.7, shadowRadius: 8.0, color: AppColors.themeBlack.withAlphaComponent(0.14))
        //Color
        self.backgroundColor = AppColors.screensBackground.color
        self.inclusionLabel.textColor = AppColors.themeGray40
        self.inclusionTypeLabel.textColor = AppColors.textFieldTextColor51
        
        //Font
        self.inclusionLabel.font = AppFonts.Regular.withSize(14.0)
        self.inclusionTypeLabel.font = AppFonts.Regular.withSize(18.0)
        
        //Text
        
    }
    
    ///HC ConstraintsAndData SetUp
    private func hcConstraintsAndDataSetUp(isWebsiteCell: Bool) {
        self.shadowViewLeadingConstraints.constant = 0.0
        self.shadowViewTrailingConstraints.constant = 0.0
        if isWebsiteCell {
            self.dividerView.isHidden = false
            self.inclusionLabelBottomConstraints.constant = 6.0
            self.inclusionTypeLabelBottomConstraints.constant = 21.0
            self.inclusionLabel.font = AppFonts.SemiBold.withSize(16.0)
            self.inclusionLabel.textColor = AppColors.themeBlack
        } else {
            self.dividerView.isHidden = true
            self.inclusionLabelBottomConstraints.constant = 4.0
            self.inclusionTypeLabelBottomConstraints.constant = 9.0
            self.inclusionLabel.font = AppFonts.Regular.withSize(14.0)
            self.inclusionLabel.textColor = AppColors.themeGray40
        }
    }
    
    private func getAllInclusion(ratesData: Rates) -> [String] {
        var inclusionText: [String] = []
        var internetText: [String] = []
        if let boardInclusion =  ratesData.inclusion_array[APIKeys.boardType.rawValue] as? [String], !boardInclusion.isEmpty {
            inclusionText = boardInclusion
        }
        if let internetInclusion =  ratesData.inclusion_array[APIKeys.internet.rawValue] as? [String], !internetInclusion.isEmpty {
            internetText = internetInclusion
        }
        let setA = Set(inclusionText)
        let allSet = setA.union(internetText)
        return Array(allSet)
    }
    
    internal func configureCell(ratesData: Rates) {
        self.inclusionLabel.text = LocalizedString.Inclusion.localized
        let inclusionText = self.getAllInclusion(ratesData: ratesData)
        self.inclusionTypeLabel.text = inclusionText.joined(separator: ", ")
    }
    
    
    internal func configureOtherInclusionCell(otherInclusion: [String]) {
        self.inclusionLabel.text = LocalizedString.OtherInclusions.localized
        self.inclusionTypeLabel.text = otherInclusion.joined(separator: ", ")
    }
    
    internal func configureWebsiteCell(website: String) {
        self.hcConstraintsAndDataSetUp(isWebsiteCell: true)
        self.inclusionLabel.text = LocalizedString.Website.localized
        self.inclusionTypeLabel.text = website
    }
    
    ///Config HCBeds Cell
    internal func configHCBedsCell() {
        self.hcConstraintsAndDataSetUp(isWebsiteCell: false)
        self.inclusionLabel.text = LocalizedString.Beds.localized
        self.inclusionTypeLabel.text = "2 Single Beds"
    }
    
    ///Config HCInclusion Cell
    internal func configHCInclusionCell() {
        self.hcConstraintsAndDataSetUp(isWebsiteCell: false)
        self.inclusionLabel.text = LocalizedString.Inclusion.localized
        self.inclusionTypeLabel.text = "Breakfast"
    }
    
    ///Config HCOtherInlusion Cell
    internal func configHCOtherInlusionCell() {
        self.hcConstraintsAndDataSetUp(isWebsiteCell: false)
        self.inclusionLabel.text = LocalizedString.OtherInclusions.localized
        self.inclusionTypeLabel.text = "Valet Parking"
    }
}
