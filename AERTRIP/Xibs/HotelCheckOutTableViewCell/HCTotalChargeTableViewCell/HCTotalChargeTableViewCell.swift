//
//  HCTotalChargeTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCTotalChargeTableViewCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var totalChargeLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var paymentModeLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    
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
        self.totalChargeLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.totalCostLabel.font = AppFonts.SemiBold.withSize(26.0)
        self.paymentModeLabel.font = AppFonts.Regular.withSize(16.0)
        //Text
        self.totalChargeLabel.text = LocalizedString.TotalCharge.localized
        //Color
        self.totalChargeLabel.textColor = AppColors.themeBlack
        self.totalCostLabel.textColor = AppColors.themeBlack
        self.paymentModeLabel.textColor = AppColors.themeGray40
    }
    
    ///COnfigure Cell
    internal func configCell(mode: String , totalCharge: String) {
        self.paymentModeLabel.text = mode.capitalizedFirst()
        self.totalCostLabel.text = "\(totalCharge)"
    }
}
