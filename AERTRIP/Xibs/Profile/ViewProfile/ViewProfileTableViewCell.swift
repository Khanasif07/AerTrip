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
        // Initialization code
    }
    
    func configureCell(_ title: String) {
        menuOptionLabel.text  = title
    }
}
