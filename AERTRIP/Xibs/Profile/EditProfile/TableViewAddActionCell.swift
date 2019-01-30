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

    @IBOutlet var cellBackgroundView: UIView!
    @IBOutlet var actionLabel: UILabel!

    @IBOutlet weak var topDividerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: - Helper Methods

    func configureCell(_ title: String) {
        actionLabel.text = title
    }
}
