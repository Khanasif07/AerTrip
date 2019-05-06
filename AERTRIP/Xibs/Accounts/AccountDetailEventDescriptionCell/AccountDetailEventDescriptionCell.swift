//
//  AccountDetailEventDescriptionCell.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AccountDetailEventDescriptionCell: UITableViewCell {
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var voucherTitleLabel: UILabel!
    @IBOutlet weak var voucherValueLabel: UILabel!
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var amountValueLabel: UILabel!
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    @IBOutlet weak var mainContainerBottomConstraint: NSLayoutConstraint!
    
    var event: AccountDetailEvent? {
        didSet {
            self.setData()
        }
    }
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.setFontAndColor()
    }
    
    private func setFontAndColor() {
        
        self.mainContainerView.backgroundColor = AppColors.themeWhite
        self.mainContainerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner ,.layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize(width: 0.0, height: 1.0), opacity: 0.7, shadowRadius: 3.0)
        
        self.clipsToBounds = true
        
        self.backgroundColor = AppColors.themeWhite
        
        self.voucherTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.amountTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.balanceTitleLabel.font = AppFonts.Regular.withSize(14.0)
        
        self.voucherValueLabel.font = AppFonts.Regular.withSize(18.0)
        self.amountValueLabel.font = AppFonts.Regular.withSize(18.0)
        self.balanceValueLabel.font = AppFonts.Regular.withSize(18.0)
        
        self.voucherTitleLabel.textColor = AppColors.themeGray40
        self.amountTitleLabel.textColor = AppColors.themeGray40
        self.balanceTitleLabel.textColor = AppColors.themeGray40
        
        self.voucherTitleLabel.text = LocalizedString.Voucher.localized
        self.amountTitleLabel.text = LocalizedString.Amount.localized
        self.balanceTitleLabel.text = LocalizedString.Balance.localized
    }
    
    private func setData() {
        self.voucherValueLabel.text = "Sales"
        self.amountValueLabel.text = (self.event?.amount ?? 0.0).amountInDelimeterWithSymbol
        self.balanceValueLabel.text = (self.event?.balance ?? 0.0).amountInDelimeterWithSymbol
    }
}
