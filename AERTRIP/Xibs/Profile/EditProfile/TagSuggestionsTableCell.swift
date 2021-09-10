//
//  TagSuggestionsTableCell.swift
//  AERTRIP
//
//  Created by Admin on 19/04/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

class TagSuggestionsTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        self.titleLabel.textColor = AppColors.textFieldTextColor51
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
