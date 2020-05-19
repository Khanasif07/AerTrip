//
//  RadioButtonTableViewCell.swift
//  Aertrip
//
//  Created by  hrishikesh on 08/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class RadioButtonTableViewCell: UITableViewCell {
    @IBOutlet weak var radioButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel?.font = UIFont(name:"SourceSansPro-Regular" , size: 18)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func prepareForReuse() {
        self.imageView?.image = nil
        self.radioButton.isSelected = true
    }
    
}
