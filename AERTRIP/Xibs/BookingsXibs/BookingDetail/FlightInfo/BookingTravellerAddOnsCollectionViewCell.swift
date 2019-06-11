//
//  BookingTravellerAddOnsCollectionViewCell.swift
//  AERTRIP
//
//  Created by apple on 11/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingTravellerAddOnsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpColor()
    }
    
    private func setUpFont() {
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.titleValueLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    private func setUpColor() {
        self.titleLabel.textColor = AppColors.themeGray40
        self.titleValueLabel.textColor = AppColors.textFieldTextColor51
    }
    
    func configure(title: String, detail: String) {
        self.titleLabel.text = title
        self.titleValueLabel.text = detail
    }
}
