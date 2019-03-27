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
    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var checkOutLabel: UILabel!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkInDayLabel: UILabel!
    @IBOutlet weak var checkOutDayLabel: UILabel!
    @IBOutlet weak var moonImageView: UIImageView!
    @IBOutlet weak var totlaNightsLabel: UILabel!
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
        self.checkInLabel.font = AppFonts.Regular.withSize(16.0)
        self.checkOutLabel.font = AppFonts.Regular.withSize(16.0)
        self.checkInDateLabel.font = AppFonts.Regular.withSize(26.0)
        self.checkOutDateLabel.font = AppFonts.Regular.withSize(26.0)
        self.checkInDayLabel.font = AppFonts.Regular.withSize(16.0)
        self.checkOutDayLabel.font = AppFonts.Regular.withSize(16.0)
        self.totlaNightsLabel.font = AppFonts.SemiBold.withSize(14.0)
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
        self.totlaNightsLabel.textColor = AppColors.themeBlack
    }
    
    ///COnfigure Cell
    internal func configCell() {
        
    }
}
