//
//  BookingFequentFlyerCollectionViewCell.swift
//  AERTRIP
//
//  Created by Admin on 30/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingFequentFlyerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var frequentFlyerLabel: UILabel!
    @IBOutlet weak var airlineNoLabel: UILabel!
    @IBOutlet weak var airlineNameLabel: UILabel!
    @IBOutlet weak var airlineIconView: UIImageView!
    @IBOutlet weak var frequentFlyerView: UIView!
    
    
    var frequentFlyer: FF? {
        didSet {
            self.configureCell()
        }
    }
    
    var showFrequentFlyerView: Bool = false {
        didSet {
            self.mangeFrequentFlyerViewVisibility()
        }
    }
    
    // MARK: - View life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpTextColor()
        self.configureCell()
    }
    
    // MARK: - Helper methods
    
    private func setUpFont() {
        self.frequentFlyerLabel.font = AppFonts.Regular.withSize(14.0)
        self.airlineNameLabel.font = AppFonts.Regular.withSize(18.0)
        self.airlineNoLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    private func setUpTextColor() {
        self.frequentFlyerLabel.textColor = AppColors.themeGray40
        self.airlineNameLabel.textColor = AppColors.themeBlack
        self.airlineNoLabel.textColor = AppColors.themeBlack
    }
    
     private func configureCell() {
        
        self.frequentFlyerLabel.text = LocalizedString.FrequentFlyer.localized
        self.airlineNameLabel.text = frequentFlyer?.key ?? ""
        self.airlineNoLabel.text = frequentFlyer?.value ?? ""
        self.airlineIconView.image = AppImages.greenFlightIcon
        
    }
    
    private func mangeFrequentFlyerViewVisibility() {
        self.frequentFlyerView.isHidden = !showFrequentFlyerView
    }
}
