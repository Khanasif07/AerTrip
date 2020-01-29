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
    

    override func awakeFromNib() {
        super.awakeFromNib()
         self.menuOptionLabel.font = AppFonts.Regular.withSize(20.0)
        // Initialization code
    }
    
    func configureCell(_ title: String) {
        menuOptionLabel.text  = title
        self.menuOptionLabel.font = AppFonts.Regular.withSize(20.0)
    }
}
