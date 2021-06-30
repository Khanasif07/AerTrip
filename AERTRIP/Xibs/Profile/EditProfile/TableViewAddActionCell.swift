//
//  TableViewAddActionCell.swift
//  AERTRIP
//
//  Created by apple on 22/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class TableViewAddActionCell: UITableViewCell {
    // MARK: - IB Outlets

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var topDividerView: ATDividerView!
    @IBOutlet weak var greenButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomDividerView: ATDividerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cellBackgroundView.backgroundColor = AppColors.headerBackground//.themeGray04
        actionLabel.textColor = AppColors.themeBlack
        self.bottomDividerView.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.topDividerView.isHidden = false
    }

    // MARK: - Helper Methods

    func configureCell(_ title: String) {
        actionLabel.text = title
    }
    
    func configureFotAddNewGroup() {
        greenButtonLeadingConstraint.constant = 16
        actionLabel.text = LocalizedString.AddNewGroup.localized
//        cellBackgroundView.backgroundColor = .white
//        topDividerView.isHidden = true
        actionLabel.font = AppFonts.Regular.withSize(14)
        actionLabel.textColor = AppColors.themeBlack
        self.bottomDividerView.isHidden = true
    }
}
