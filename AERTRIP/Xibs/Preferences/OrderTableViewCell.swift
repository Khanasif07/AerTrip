//
//  OrderTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 08/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    // MARK: - IB Oultets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkIconImageView: UIImageView!
    @IBOutlet weak var separatorView: ATDividerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.checkIconImageView.isHidden = true
    }
}
