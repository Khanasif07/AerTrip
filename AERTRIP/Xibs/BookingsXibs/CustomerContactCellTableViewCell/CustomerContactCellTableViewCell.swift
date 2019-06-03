//
//  CustomerContactCellTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 03/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class CustomerContactCellTableViewCell: UITableViewCell {
  
        //MARK:- Variables
        //MARK:===========
        
        
        //MARK:- IBOutlets
        //MARK:===========
    @IBOutlet weak var titleLabel: UILabel!
    
        
        //MARK:- LifeCycle
        //MARK:===========
        override func awakeFromNib() {
            super.awakeFromNib()
            self.titleLabel.font = AppFonts.Regular.withSize(14.0)
            self.titleLabel.textColor = AppColors.themeGray40
            self.titleLabel.text = LocalizedString.customerExecutiveWillContact.localized
        }
        
        //MARK:- Functions
        //MARK:===========
        
}
