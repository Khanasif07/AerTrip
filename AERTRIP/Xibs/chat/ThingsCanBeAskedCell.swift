//
//  ThingsCanBeAskedCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 10/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class ThingsCanBeAskedCell: UITableViewCell {

    @IBOutlet weak var labelTop: NSLayoutConstraint!
    @IBOutlet weak var thingsCanAskedLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        thingsCanAskedLabel.font = AppFonts.Regular.withSize(16)
        thingsCanAskedLabel.textColor = AppColors.themeTextColor
        thingsCanAskedLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func populateData(indexpath : IndexPath, data : [String]){
        if indexpath.section == 0{
            thingsCanAskedLabel.text = "\"" + data[indexpath.row] + "\""
            labelTop.constant = 36
        }else{
            thingsCanAskedLabel.text = "\(LocalizedString.CommingSoon.localized)..."
            labelTop.constant = 12
        }
        
    }
}
