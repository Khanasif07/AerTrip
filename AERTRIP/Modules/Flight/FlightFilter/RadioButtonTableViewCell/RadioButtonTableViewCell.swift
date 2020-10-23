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
        self.textLabel?.font = AppFonts.Regular.withSize(18)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func prepareForReuse() {
        self.imageView?.image = nil
        self.radioButton.isSelected = true
    }
    
    func configureAllAircraftsCell() {
        self.textLabel?.text = "All Aircrafts"
        //  titleLabel.text = "All Aircrafts"
      }
      
      func configureAircraftCell(title : String) {
      
          self.textLabel?.text = title

      }
    
    
}
