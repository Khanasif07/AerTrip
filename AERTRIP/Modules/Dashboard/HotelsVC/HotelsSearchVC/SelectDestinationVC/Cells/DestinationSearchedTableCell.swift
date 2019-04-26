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
        if !data.city.isEmpty {
            self.titleLabel.attributedText =  self.getAttributedBoldText(text: data.city, boldText: forText, fullTextColor: AppColors.themeBlack)
        } else {
            let newValue = data.value.components(separatedBy: ",")
            printDebug(newValue.first)
            self.titleLabel.text = newValue.first ?? ""
        }
        //Logic for after string
        var splittedStringArray = data.value.components(separatedBy: ",")
        splittedStringArray.removeFirst()
        let stateName = splittedStringArray.joined(separator: ",").removeLeadingTrailingWhitespaces
        self.addressLabel.attributedText = self.getAttributedBoldText(text: stateName, boldText: forText, fullTextColor: AppColors.themeBlack)
    }
    
    private func getAttributedBoldText(text: String, boldText: String, fullTextColor: UIColor) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [.foregroundColor: fullTextColor])
        
        attString.addAttribute(.foregroundColor, value: AppColors.themeGreen, range: (text.lowercased() as NSString).range(of: boldText.lowercased()))
        return attString
    }
}
