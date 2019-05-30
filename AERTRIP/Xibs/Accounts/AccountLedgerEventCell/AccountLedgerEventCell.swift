//
//  AccountLedgerEventCell.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AccountLedgerEventCell: UITableViewCell {
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var selectButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectButtonLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var voucherTitleLabel: UILabel!
    @IBOutlet weak var voucherValueLabel: UILabel!
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var amountValueLabel: UILabel!
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    
    var event: AccountDetailEvent? {
        didSet {
            self.setData()
        }
    }
    
    var isSelectable: Bool = false {
        didSet {
            self.manageSelectable()
        }
    }
    
    var isHotelSelected: Bool = false {
        didSet {
            self.manageSelectedState()
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
        self.mainContainerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize(width: 0.0, height: -1.0), opacity: 0.4, shadowRadius: 8.0)
        
        self.clipsToBounds = false
        self.backgroundColor = AppColors.themeWhite
        self.mainContainerView.backgroundColor = AppColors.themeWhite
        self.mainContainerView.clipsToBounds = false
        
        self.backgroundColor = AppColors.themeWhite
        
        self.dividerView.defaultHeight = 1.0
        
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        
        self.titleLabel.textColor = AppColors.themeBlack
        
        self.isSelectable = false
        
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
    
    private func manageSelectable() {
        self.selectButtonHeightConstraint.constant = self.isSelectable ? 22.0 : 0.0
        self.selectButtonLeadingConstraint.constant = self.isSelectable ? 16.0 : 0.0
    }
    
    private func manageSelectedState() {
        self.selectionButton.isSelected = self.isHotelSelected
    }
    
    private func setData() {
        self.iconImageView.image = self.event?.iconImage
        self.titleLabel.text = self.event?.title
        
        self.voucherValueLabel.text = self.event?.voucherName ?? ""
        self.amountValueLabel.attributedText = (self.event?.amount ?? 0.0).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
        self.balanceValueLabel.attributedText = (self.event?.balance ?? 0.0).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
    }
}
