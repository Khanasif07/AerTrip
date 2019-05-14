//
//  NightStateTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 09/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class NightStateTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
 
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.titleLabel.textColor = AppColors.themeBlack
    }

    
    
}
