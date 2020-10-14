//
//  PerSlabFareInfoTableViewCell.swift
//  Aertrip
//
//  Created by Monika Sonawane on 23/12/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class PerSlabFareInfoTableViewCell: UITableViewCell
{
    @IBOutlet weak var dataDisplayView: UIView!
    @IBOutlet weak var dataDisplayViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var topSeperatorLabel: ATDividerView!
    @IBOutlet weak var topSeperatorLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var topSeperatorLabelTop: NSLayoutConstraint!
    
    @IBOutlet weak var slabTitleView: UIView!
    @IBOutlet weak var slabTitleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var slabTimeLabel: UILabel!
    @IBOutlet weak var slabDataDisplayView: UIView!
    @IBOutlet weak var slabDataDisplayViewHeight: NSLayoutConstraint!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var perAdultDataDisplayView: UIView!
    @IBOutlet weak var perAdultDataDisplayViewHeight: NSLayoutConstraint!
    @IBOutlet weak var perAdultAmountLabel: UILabel!

    @IBOutlet weak var perChildDataDisplayView: UIView!
    @IBOutlet weak var perChildDataDisplayViewHeight: NSLayoutConstraint!
    @IBOutlet weak var perChildAmountLabel: UILabel!

    @IBOutlet weak var perInfantDataDisplayView: UIView!
    @IBOutlet weak var perInfantDataDisplayViewHeight: NSLayoutConstraint!
    @IBOutlet weak var perInfantAmountLabel: UILabel!
    
    @IBOutlet weak var bottomSeparatorLabel: ATDividerView!
    @IBOutlet weak var bottomSeparatorLabelTop: NSLayoutConstraint!
    
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var seperatorViewHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        statusLabel.text = ""
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
