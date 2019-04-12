//
//  HCConfirmationVoucherTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCConfirmationVoucherTableViewCell: UITableViewCell {
    
    //Mark:- Variables
    //================
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var confirmationVoucherLabel: UILabel!
    @IBOutlet weak var viewButton: ATButton!
    
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
        
        //view button
        self.viewButton.shadowColor = AppColors.themeWhite
        self.viewButton.gradientColors = [AppColors.themeWhite, AppColors.themeWhite]
        self.viewButton.setTitle(LocalizedString.View.localized, for: .normal)
        
        //Font
        self.confirmationVoucherLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.viewButton.titleLabel?.font = AppFonts.SemiBold.withSize(18.0)

        //Text
        self.confirmationVoucherLabel.text = LocalizedString.ConfirmationVoucher.localized
        self.viewButton.setTitle(LocalizedString.View.localized, for: .normal)
        
        //Color
        self.confirmationVoucherLabel.textColor = AppColors.themeBlack
        self.viewButton.setTitleColor(AppColors.themeGreen, for: .normal)

    }
    
    ///COnfigure Cell
    internal func configCell() {
    }
}
