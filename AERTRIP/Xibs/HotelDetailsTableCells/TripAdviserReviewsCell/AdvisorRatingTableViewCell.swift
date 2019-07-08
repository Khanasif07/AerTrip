//
//  AdvisorRatingTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 09/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AdvisorRatingTableViewCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dividerViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var tripAdvisorRatingView: FloatRatingView!
    @IBOutlet weak var dividerView: ATDividerView!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    private func configureUI() {
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
        //Color
        self.titleLabel.textColor = AppColors.themeBlack
    }
    
    internal func configCell(ratingSummary: RatingSummary) {
        self.titleLabel.text = ratingSummary.localizedName
        self.tripAdvisorRatingView.rating = ratingSummary.value.toDouble ?? 0.0
    }
    
}
