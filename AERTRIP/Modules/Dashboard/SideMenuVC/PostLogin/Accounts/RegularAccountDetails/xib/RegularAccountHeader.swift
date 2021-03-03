//
//  RegularAccountHeader.swift
//  AERTRIP
//
//  Created by Appinventiv  on 03/03/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

class RegularAccountHeader: UIView {
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var accountTitleFilterView: UIView!
    @IBOutlet weak var accountLaderTitleLabel: UILabel!
    @IBOutlet weak var searchbarView: UIView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setText()
        self.setFonts()
        self.setColors()
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
    }
    
    @IBAction func optionButtonTapped(_ sender: Any) {
    }
    
    func setText(){
        self.balanceTitleLabel.text = LocalizedString.Balance.localized
        self.accountLaderTitleLabel.text = LocalizedString.AccountLegder.localized
    }
    
    func setFonts(){
        self.balanceTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.accountLaderTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    func setColors(){
        self.balanceTitleLabel.textColor = AppColors.themeGray40
        self.accountLaderTitleLabel.textColor = AppColors.themeBlack
        self.emptyView.backgroundColor = AppColors.greyO4
        
    }
    
}
