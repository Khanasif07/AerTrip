//
//  TripAdvisorTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 12/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TripAdvisorTableViewCell: UITableViewCell {

    //Mark:- Variables
    //================
    @IBOutlet weak var tripAdviserImgView: UIImageView!
    @IBOutlet weak var checkTripAdvisorLabel: UILabel!
    @IBOutlet weak var rightArrowImgView: UIImageView!
    @IBOutlet weak var dividerView: ATDividerView!
    
    
    //Mark:- IBOutlets
    //================
    
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUps()
    }
    
    //Mark:- Functions
    //================
    private func initialSetUps() {
        self.checkTripAdvisorLabel.text = LocalizedString.CheckTripAdvisor.localized
        self.checkTripAdvisorLabel.font = AppFonts.Regular.withSize(18.0)
        self.checkTripAdvisorLabel.textColor = AppColors.themeGreen
    }

    
}
