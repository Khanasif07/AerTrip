//
//  FlightEmptyCell.swift
//  Aertrip
//
//  Created by Apple  on 04.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class FlightEmptyCell: UITableViewCell {

       @IBOutlet weak var topDividerView: ATDividerView!
       @IBOutlet weak var bottomDividerView: ATDividerView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.topDividerView.backgroundColor = AppColors.divider.color
        self.bottomDividerView.backgroundColor = AppColors.divider.color
        self.backgroundColor = AppColors.themeGray04
    }
}
