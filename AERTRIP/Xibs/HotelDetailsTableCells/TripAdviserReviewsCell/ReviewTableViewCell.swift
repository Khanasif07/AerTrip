//
//  ReviewTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 09/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    //Mark:- IBOutlets
    //================
    @IBOutlet weak var reviewTitle: UILabel!
    @IBOutlet weak var progressBarView: PKProgressView!
    @IBOutlet weak var numbOfReviews: UILabel!
    @IBOutlet weak var progressViewBottomConstraints: NSLayoutConstraint!

    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }

    //Mark:- Functions
    //================
    private func configUI() {
        self.reviewTitle.font = AppFonts.Regular.withSize(18.0)
        self.numbOfReviews.font = AppFonts.Regular.withSize(18.0)

        //Color
        self.progressBarView.backgroundColor = AppColors.themeGray04
        self.progressBarView.tintColor = AppColors.themeGreen

        self.reviewTitle.textColor = AppColors.themeBlack
        self.numbOfReviews.textColor = AppColors.themeBlack
    }
    
    internal func configCell(title: String ,totalNumbReviews: String, currentReviews: String) {
        self.reviewTitle.text = title
        self.progressBarView.progress = CGFloat((currentReviews.toDouble ?? 0.0)/(totalNumbReviews.toDouble ?? 0.0))
        self.numbOfReviews.text = (currentReviews.toDouble ?? 0.0).kFormatted
    }
}
