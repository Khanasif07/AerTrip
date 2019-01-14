//
//  AssignGroupTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 14/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AssignGroupTableViewCell: UITableViewCell {
    @IBOutlet var groupNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(_ groupName: String) {
        groupNameLabel.text = groupName
    }
}
