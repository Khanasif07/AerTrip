//
//  CategorisedByGroupsTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 08/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class CategorisedByGroupsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var groupSwitch: UISwitch!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        groupSwitch.onTintColor = AppColors.themeGreen
    }

   
    
}
