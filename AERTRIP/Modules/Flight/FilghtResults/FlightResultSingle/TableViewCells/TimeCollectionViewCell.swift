//
//  TimeCollectionViewCell.swift
//  Aertrip
//
//  Created by  hrishikesh on 06/01/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class TimeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var isPinnedView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        isPinnedView.layer.cornerRadius = 3.0
    }

}
