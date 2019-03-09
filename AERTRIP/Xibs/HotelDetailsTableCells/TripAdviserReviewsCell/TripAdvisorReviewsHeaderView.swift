//
//  TripAdvisorReviewsHeaderView.swift
//  AERTRIP
//
//  Created by Admin on 09/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TripAdvisorReviewsHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dividerView: ATDividerView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    private func configUI() {
        self.containerView.backgroundColor = AppColors.themeWhite
        self.headerLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.headerLabel.textColor = AppColors.themeBlack
    }
}
