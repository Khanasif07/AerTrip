//
//  JourneyNameCollectionViewCell.swift
//  Aertrip
//
//  Created by Monika Sonawane on 01/10/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class JourneyNameCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var journeyNameHighlightingView: UIView!
    @IBOutlet weak var journeyNameHighlightingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var journeyNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
