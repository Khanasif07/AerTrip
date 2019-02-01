//
//  DestinationMyLocationTableCell.swift
//  AERTRIP
//
//  Created by Admin on 23/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class DestinationMyLocationTableCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        self.setupFontAndColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupFontAndColor() {
        self.messageLabel.font = AppFonts.Regular.withSize(18.0)
        self.messageLabel.textColor = AppColors.themeBlack
    }
    
    func configure(title: String) {
        self.messageLabel.text = title
    }
}
