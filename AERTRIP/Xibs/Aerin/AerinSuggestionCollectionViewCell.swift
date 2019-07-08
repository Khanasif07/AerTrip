//
//  AerinSuggestionCollectionViewCell.swift
//  AERTRIP
//
//  Created by apple on 22/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AerinSuggestionCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: - Properties

    @IBOutlet weak var suggestionImageView: UIImageView!
    @IBOutlet weak var suggestionTitleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.setUpFont()
        self.setUpColor()
        self.doInitialSetup()
        
    }
    
    
    func setUpFont() {
       self.suggestionTitleLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    func setUpColor() {
        self.suggestionTitleLabel.textColor = AppColors.themeGray60
    }
    
    func doInitialSetup() {
        self.layer.cornerRadius = 22.5
        self.layer.borderWidth = 1.0
        self.layer.borderColor = AppColors.themeGray10.cgColor
    }
    
    
    

}
