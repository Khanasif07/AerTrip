//
//  SortTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class SortTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var rightTitleLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        doInitialSetup()
    }
    
    
    
    
    func doInitialSetup() {
        leftTitleLabel.font = AppFonts.Regular.withSize(18.0)
        rightTitleLabel.font = AppFonts.Regular.withSize(14.0)
    }

    
     func configureCell(leftTitle:String,rightTitle:String) {
        leftTitleLabel.text = leftTitle
        rightTitleLabel.text = rightTitle
    }
   
    
}
