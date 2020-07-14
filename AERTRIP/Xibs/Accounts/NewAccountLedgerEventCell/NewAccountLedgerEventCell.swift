//
//  NewAccountLedgerEventCell.swift
//  AERTRIP
//
//  Created by Apple  on 09.07.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class NewAccountLedgerEventCell: UITableViewCell {
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
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceValueLabel: UILabel!
    @IBOutlet weak var containerTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstaint: NSLayoutConstraint!
    
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
//        self.mainContainerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize(width: 0.0, height: -1.0), opacity: 0.4, shadowRadius: 8.0)
        
        self.mainContainerView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.15), offset: CGSize(width: 0, height: -1), opacity: 1, shadowRadius: 8.0)

        self.backgroundColor = AppColors.themeWhite

        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        
        self.titleLabel.textColor = AppColors.themeBlack
        
        self.isSelectable = false
        self.voucherValueLabel.text = ""
        self.voucherTitleLabel.font = AppFonts.Regular.withSize(18.0)
        self.balanceTitleLabel.font = AppFonts.Regular.withSize(18.0)
        
        self.voucherValueLabel.font = AppFonts.Regular.withSize(14.0)
        self.balanceValueLabel.font = AppFonts.Regular.withSize(14.0)
        
        self.voucherTitleLabel.textColor = AppColors.themeBlack
        self.balanceTitleLabel.textColor = AppColors.themeBlack
        self.voucherValueLabel.textColor = AppColors.themeGray40
        self.balanceValueLabel.textColor = AppColors.themeGray40
        
        self.voucherTitleLabel.text = LocalizedString.Voucher.localized
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
        if let atbTxt = self.event?.attributedString{
            self.titleLabel.text = nil
            self.titleLabel.attributedText = atbTxt
        }else{
            self.titleLabel.attributedText = nil
            self.titleLabel.text = self.event?.title
        }
        
        
        self.voucherTitleLabel.text = self.event?.voucherName ?? ""
        self.balanceTitleLabel.attributedText = (self.event?.amount ?? 0.0).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
        let mutableText = NSMutableAttributedString(string: "Closing Balance : -", attributes: [.font: AppFonts.Regular.withSize(12), .foregroundColor: AppColors.themeGray40])
        mutableText.append((self.event?.balance ?? 0.0).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(12.0)))
        self.balanceValueLabel.attributedText = mutableText//(self.event?.balance ?? 0.0).amountInDelimeterWithSymbol.asStylizedPrice(using: AppFonts.Regular.withSize(12.0))
    }
}
