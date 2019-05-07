//
//  AerinInfoTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 07/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AerinInfoTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.titleLabel.font = AppFonts.Regular.withSize(16.0)
        self.titleLabel.textColor = AppColors.themeTextColor
        
    }

    
    
}
