//
//  IntFareInfoCell.swift
//  Aertrip
//
//  Created by Apple  on 12.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class IntFareInfoCell: UITableViewCell {
    @IBOutlet weak var topSeperatorLabel: UILabel!
    @IBOutlet weak var topSeperatorLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleView: UIView!
//    @IBOutlet weak var titleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fareRulesButton: UIButton!
    
    @IBOutlet weak var nonReschedulableView: UIView!
    @IBOutlet weak var nonReschedulableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nonRefundableView: UIView!
    @IBOutlet weak var nonRefundableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cancellationNoteDisplayView: UIView!
    @IBOutlet weak var cancellationNoteDisplayViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottomSeparatorLabel: UILabel!
    @IBOutlet weak var bottomSeparatorLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomSeparatorLabelLeading: NSLayoutConstraint!
    
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var seperatorViewHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
