//
//  LabelWithBulletCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 29/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class LabelWithBulletCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dotLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.descriptionLabel.font = AppFonts.Regular.withSize(16)
        self.dotLabel.font = AppFonts.SemiBold.withSize(16)
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
 

    
}
