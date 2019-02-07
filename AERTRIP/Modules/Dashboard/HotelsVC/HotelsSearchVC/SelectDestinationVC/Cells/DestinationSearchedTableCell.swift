//
//  DestinationSearchedTableCell.swift
//  AERTRIP
//
//  Created by Admin on 23/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class DestinationSearchedTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    
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
        
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        self.titleLabel.textColor = AppColors.themeBlack
        
        self.addressLabel.font = AppFonts.Regular.withSize(14.0)
        self.addressLabel.textColor = AppColors.themeGray40
    }
    
    func configureData(data: SearchedDestination, forText: String) {
        self.titleLabel.attributedText = self.getAttributedBoldText(text: data.dest_name, boldText: forText, fullTextColor: AppColors.themeBlack)
        self.addressLabel.attributedText = self.getAttributedBoldText(text: data.value, boldText: forText, fullTextColor: AppColors.themeGray40)
    }
    
    private func getAttributedBoldText(text: String, boldText: String, fullTextColor: UIColor) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [.foregroundColor: fullTextColor])
        
        attString.addAttribute(.foregroundColor, value: AppColors.themeGreen, range: (text as NSString).range(of: boldText))
        return attString
    }
}
