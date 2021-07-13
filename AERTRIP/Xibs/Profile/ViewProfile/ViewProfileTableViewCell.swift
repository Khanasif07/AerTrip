//
//  ViewProfileTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 18/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class ViewProfileTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var menuOptionLabel: UILabel!
    @IBOutlet weak var separatorView: ATDividerView!
    @IBOutlet weak var bottomViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var topViewHeightConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = AppColors.themeWhite
         self.menuOptionLabel.font = AppFonts.Regular.withSize(20.0)
        // Initialization code
        
    }
    
    func configureCell(_ title: String) {
        menuOptionLabel.textColor = AppColors.themeBlack
        menuOptionLabel.text  = title
        self.menuOptionLabel.font = AppFonts.Regular.withSize(20.0)
    }
}
