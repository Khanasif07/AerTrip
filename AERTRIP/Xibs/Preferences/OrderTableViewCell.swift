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
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var checkIconImageView: UIImageView!
    @IBOutlet var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
