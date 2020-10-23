//
//  SeeResultsAgainCell.swift
//  AERTRIP
//
//  Created by Rishabh on 19/10/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SeeResultsAgainCell: UITableViewCell {

    // Properties
    
    
    // Outlets
    
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialSetup()
    }
    
    
    // Mark: IBActions
    
    
    // MARK: Functions
    private func initialSetup() {
        titleLbl.text = LocalizedString.seeResultsAgain.localized
        titleLbl.font = AppFonts.Regular.withSize(14)
        titleLbl.textColor = AppColors.themeGreen
    }
    
}
