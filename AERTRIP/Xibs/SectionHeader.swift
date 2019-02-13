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
    @IBOutlet weak var labelBackgroundView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.labelBackgroundView.layer.cornerRadius = self.labelBackgroundView.frame.size.height / 2
        
    }
    
}
