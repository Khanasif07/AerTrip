//
//  FlightsOptionCollectionViewCell.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightsOptionCollectionViewCell: UICollectionViewCell {
    // MARK: - Variables
    
    // MARK: ===========
    
    // MARK: - IBOutlets
    
    // MARK: ===========
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var optionImageView: UIImageView!
    @IBOutlet var optionNameLabel: UILabel!
    @IBOutlet var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet var dividerView: UIView!
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    // MARK: - Functions
    
    // MARK: ===========
    
    private func configureUI() {
        self.optionNameLabel.textColor = AppColors.themeBlack
        self.optionNameLabel.font = AppFonts.Regular.withSize(14.0)
        self.dividerView.backgroundColor = AppColors.themeGray151.withAlphaComponent(0.52)
    }
    
    /// Configure collection view cell to set the data
    internal func configureCell(optionImage: UIImage, optionName: String, isLastCell: Bool) {
        self.optionNameLabel.text = optionName
        self.optionImageView.image = optionImage
        if isLastCell {
            self.imageViewHeightConstraint.constant = 37.0
            self.imageViewTopConstraint.constant = 6.0
            self.titleTopConstraint.constant = 15.0
            self.dividerView.isHidden = true
        } else {
            self.imageViewHeightConstraint.constant = 50.0
            self.imageViewTopConstraint.constant = 0.0
            self.titleTopConstraint.constant = 8.0
            self.dividerView.isHidden = false
        }
    }
}
