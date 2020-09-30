//
//  ChangeAirportTableViewCell.swift
//  Aertrip
//
//  Created by Monika Sonawane on 24/10/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class ChangeAirportTableViewCell: UITableViewCell
{
    @IBOutlet weak var topSeperatorLabel: UILabel!
    @IBOutlet weak var topSeperatorLabelTop: NSLayoutConstraint!
    @IBOutlet weak var topSeperatorLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var topSeperatorLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataLabelTop: NSLayoutConstraint!
    @IBOutlet weak var seperatorBottom: NSLayoutConstraint!
    @IBOutlet weak var bottomStroke: UILabel!
    @IBOutlet weak var bottomStrokeHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dataLabel.clipsToBounds = true
        dataLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
