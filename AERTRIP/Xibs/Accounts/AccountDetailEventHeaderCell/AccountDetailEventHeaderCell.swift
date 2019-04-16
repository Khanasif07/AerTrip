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
        self.mainContainerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.5), offset: CGSize(width: 0.0, height: 2.0), opacity: 0.7, shadowRadius: 2.0)
        
        self.clipsToBounds = true
        
        self.backgroundColor = AppColors.themeWhite
        
        self.dividerView.defaultHeight = 1.0
        
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        
        self.titleLabel.textColor = AppColors.themeBlack
    }
    
    private func setData() {
        self.iconImageView.image = self.event?.voucher.image
        self.titleLabel.text = self.event?.title
    }
}
