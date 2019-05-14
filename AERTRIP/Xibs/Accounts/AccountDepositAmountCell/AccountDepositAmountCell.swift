//
//  AccountDepositAmountCell.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AccountDepositAmountCell: UITableViewCell {
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!

    //MARK:- ViewLifeCycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.setFontAndColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.amountTextField.font = AppFonts.SemiBold.withSize(40.0)
    }
    
    private func setFontAndColor() {
        
        self.backgroundColor = AppColors.themeWhite
        
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.currencyLabel.font = AppFonts.Regular.withSize(18.0)
        self.amountTextField.font = AppFonts.SemiBold.withSize(40.0)
        
        self.titleLabel.textColor = AppColors.themeGreen
        self.currencyLabel.textColor = AppColors.themeTextColor
        self.amountTextField.textColor = AppColors.themeBlack
        self.amountTextField.backgroundColor = AppColors.themeBlue.withAlphaComponent(0.26)
        
        self.titleLabel.text = LocalizedString.DepositAmount.localized
        self.currencyLabel.text = AppConstants.kRuppeeSymbol
        self.amountTextField.text = "0"
    }
    
}
