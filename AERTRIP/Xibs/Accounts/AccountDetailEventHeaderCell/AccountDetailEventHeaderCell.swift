//
//  AccountDetailEventHeaderCell.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AccountDetailEventHeaderCell: UITableViewCell {
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var selectButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectButtonLeadingConstraint: NSLayoutConstraint!
    
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
//        self.mainContainerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize(width: 0.0, height: -1.0), opacity: 0.5, shadowRadius: 5.0)
        
//        self.mainContainerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 0.5, shadowRadius: 4.0)

        let shadowProp = AppShadowProperties()
        self.mainContainerView.addShadow(cornerRadius: shadowProp.cornerRadius, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: shadowProp.shadowColor, offset: shadowProp.offset, opacity: shadowProp.opecity, shadowRadius: shadowProp.shadowRadius)

        self.dividerView.defaultHeight = 0.5
        
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        
        self.titleLabel.textColor = AppColors.themeBlack
        
        self.isSelectable = false
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
    }
}
