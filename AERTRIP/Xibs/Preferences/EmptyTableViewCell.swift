//
//  EmptyTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 08/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    @IBOutlet weak var topDividerView: ATDividerView!
    @IBOutlet weak var bottomDividerView: ATDividerView!
    @IBOutlet weak var topDividerTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = AppColors.greyO4
    }
    
}
