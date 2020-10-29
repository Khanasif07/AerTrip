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
    @IBOutlet weak var inclusionTypeLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var inclusionTypeLabelTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var inclusionTypeLabelBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var shadowViewLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var shadowViewTrailingConstraints: NSLayoutConstraint!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        inclusionTypeLabelTopConstraints.constant = 12
    }
    
    //Mark:- Methods
    //==============
    ///Configure UI
    private func configureUI() {
       // self.inclusionLabel.isHidden = true
        self.dividerView.isHidden = true
        self.shadowView.addShadow(cornerRadius: 0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        //Color
        self.backgroundColor = .clear//AppColors.screensBackground.color
        //self.inclusionLabel.textColor = AppColors.themeGray40
        self.inclusionTypeLabel.textColor = AppColors.themeBlack
        
        //Font
        self.inclusionTypeLabel.font = AppFonts.Regular.withSize(16.0)
        
        //Text
        
    }
    
    ///HC ConstraintsAndData SetUp
    private func hcConstraintsAndDataSetUp(isWebsiteCell: Bool) {
        self.shadowViewLeadingConstraints.constant = 0.0
        self.shadowViewTrailingConstraints.constant = 0.0
        if isWebsiteCell {
            self.dividerView.isHidden = false
          //  self.inclusionLabelBottomConstraints.constant = 6.0
            self.inclusionTypeLabelBottomConstraints.constant = 21.0
           // self.inclusionLabel.font = AppFonts.SemiBold.withSize(16.0)
           // self.inclusionLabel.textColor = AppColors.themeBlack
        } else {
            self.dividerView.isHidden = true
           // self.inclusionLabelBottomConstraints.constant = 4.0
            self.inclusionTypeLabelBottomConstraints.constant = 9.0
            //self.inclusionLabel.font = AppFonts.Regular.withSize(14.0)
           // self.inclusionLabel.textColor = AppColors.themeGray40
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
       // self.inclusionLabel.text = LocalizedString.Inclusion.localized
        let inclusionText = self.getAllInclusion(ratesData: ratesData)
        self.inclusionTypeLabel.text = inclusionText.joined(separator: ", ")
    }
    
    
    internal func configureOtherInclusionCell(otherInclusion: [String], isInclusionPresent: Bool) {
       // self.inclusionLabel.text = LocalizedString.OtherInclusions.localized
        inclusionTypeLabelTopConstraints.constant = isInclusionPresent ? 0 : 12
        self.inclusionTypeLabel.text = otherInclusion.joined(separator: ", ")
    }
    
    internal func configureWebsiteCell(website: String) {
        self.hcConstraintsAndDataSetUp(isWebsiteCell: true)
        //self.inclusionLabel.text = LocalizedString.Website.localized
        self.inclusionTypeLabel.text = website
    }
    
    ///Config HCBeds Cell
    internal func configHCBedsCell(bedDetails: String) {
        self.hcConstraintsAndDataSetUp(isWebsiteCell: false)
       // self.inclusionLabel.text = LocalizedString.Beds.localized
        self.inclusionTypeLabel.text = bedDetails
    }
    
    ///Config HCInclusion Cell
    internal func configHCInclusionCell(roomInclusions: JSONDictionary) {
        self.hcConstraintsAndDataSetUp(isWebsiteCell: false)
      //  self.inclusionLabel.text = LocalizedString.Inclusion.localized
        var inclusionText: [String] = []
//        var internetText: [String] = []
        if let inclusionData =  roomInclusions[APIKeys.Inclusions.rawValue] as? [String], !inclusionData.isEmpty {
            inclusionText = inclusionData
        }
//        if let internetInclusion =  roomInclusions[APIKeys.internet.rawValue] as? [String], !internetInclusion.isEmpty {
//            internetText = internetInclusion
//        }
//        let setA = Set(inclusionText)
//        let allSet = setA.union(internetText)
         self.inclusionTypeLabel.text = inclusionText.joined(separator: ", ")
    }
    
    ///Config HCOtherInlusion Cell
    internal func configHCOtherInlusionCell(roomInclusions: JSONDictionary) {
        self.hcConstraintsAndDataSetUp(isWebsiteCell: false)
       // self.inclusionLabel.text = LocalizedString.OtherInclusions.localized
        var otherInclusionText : [String] = []
        if let otherInclusionData =  roomInclusions[APIKeys.other_inclusions.rawValue] as? [String], !otherInclusionData.isEmpty {
            otherInclusionText = otherInclusionData
        }
        self.inclusionTypeLabel.text = otherInclusionText.joined(separator: ", ")
    }
    
}
