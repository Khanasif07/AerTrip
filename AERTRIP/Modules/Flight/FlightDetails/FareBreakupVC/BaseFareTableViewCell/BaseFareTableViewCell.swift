//
//  BaseFareTableViewCell.swift
//  Aertrip
//
//  Created by Monika Sonawane on 27/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class BaseFareTableViewCell: UITableViewCell
{
    @IBOutlet weak var dataDisplayView: UIView!
    @IBOutlet weak var dataDisplayViewBottom: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelYPosition: NSLayoutConstraint!
    @IBOutlet weak var titleLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var upArrowImg: UIImageView!
    @IBOutlet weak var amountLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        upArrowImg.image = UIImage(named: "")
        titleLabelLeading.constant = 31
        titleLabelYPosition.constant = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
