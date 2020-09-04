//
//  TravellSefetyCell.swift
//  AERTRIP
//
//  Created by Appinventiv  on 28/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class TravellSefetyCell: UITableViewCell {
    // Mark:- IBOutlets
    // Mark:-
    @IBOutlet weak var titleLabel: UILabel!
    
    // Mark:- LifeCycles
    // Mark:-
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        configUI()
    }
    
    // Mark:- Functions
    // Mark:-
    
    private func configUI() {
        titleLabel.font = AppFonts.SemiBold.withSize(16.0)
        titleLabel.textColor = AppColors.themeBlack
        titleLabel.text = LocalizedString.TravelSafetyGuidelines.localized
        
        
    }
    
    
}
