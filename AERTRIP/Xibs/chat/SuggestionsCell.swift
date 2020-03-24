//
//  SuggestionsCellCollectionViewCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 24/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SuggestionsCell: UICollectionViewCell {

    @IBOutlet weak var suggestionBackView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var suggestionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        self.suggestionBackView.roundedCorners(cornerRadius: 10)
        self.suggestionBackView.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        self.suggestionLabel.font = AppFonts.SemiBold.withSize(18)
        self.dateLabel.font = AppFonts.Regular.withSize(14)
        self.dateLabel.textColor = AppColors.themeGray60
    }

    
    
}
