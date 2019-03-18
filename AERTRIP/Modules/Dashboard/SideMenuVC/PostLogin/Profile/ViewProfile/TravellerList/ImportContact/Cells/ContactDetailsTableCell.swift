//
//  ContactDetailsTableCell.swift
//  AERTRIP
//
//  Created by Admin on 09/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ContactDetailsTableCell: UITableViewCell {
    
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    
    var contact: ATContact? {
        didSet {
            self.populateData()
        }
    }
    
    var traveller: TravellerModel? {
        didSet {
            self.populateData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupTextAndColor() {
        self.nameLabel.textColor = AppColors.themeBlack
        self.nameLabel.font = AppFonts.Regular.withSize(18.0)
    }

    private func populateData() {
        if contact != nil {
            self.selectionButton.isSelected = false
            self.nameLabel.text = self.contact?.fullName ?? ""
        }
        else {
            self.selectionButton.isSelected = false
            self.nameLabel.text = self.traveller?.fullName ?? ""
        }
    }
}
