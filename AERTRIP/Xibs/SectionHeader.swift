//
//  SectionHeader.swift
//  AERTRIP
//
//  Created by apple on 08/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {

    @IBOutlet weak var sectionHeaderLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sectionHeaderLabel.font = AppFonts.Regular.withSize(14.0)
        sectionHeaderLabel.textColor = AppColors.themeGray40
    }
}
