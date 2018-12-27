//
//  TableViewAddActionCell.swift
//  AERTRIP
//
//  Created by apple on 22/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class TableViewAddActionCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var actionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Helper Methods

    func configureCell( _ title: String) {
        actionLabel.text = title
    }
    
}
