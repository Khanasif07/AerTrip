//
//  AirportSelectionCell.swift
//  Aertrip
//
//  Created by Hrishikesh Devhare on 12/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class AirportSelectionCell: UITableViewCell {

    @IBOutlet weak var airportCode: UILabel!
    @IBOutlet weak var airportName: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var aerportLeadingConstraints: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
