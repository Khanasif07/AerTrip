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
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            //self.shadowView.shadowOnHotelDetailsTabelCell(color: AppColors.themeGray20, offset: CGSize(width: 0.0, height: 3.0), opacity: 0.7, shadowRadius: 4.0)        }
        }
    }
    
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //Mark:- Methods
    //==============
    private func configureUI() {
        //Color
        self.backgroundColor = AppColors.screensBackground.color
        self.containerView.layoutMargins = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        self.inclusionLabel.textColor = AppColors.themeGray40
        self.inclusionTypeLabel.textColor = AppColors.textFieldTextColor51

        //Size
        self.inclusionLabel.font = AppFonts.Regular.withSize(14.0)
        self.inclusionTypeLabel.font = AppFonts.Regular.withSize(18.0)

        //Text
        
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
    
}
