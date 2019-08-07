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
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var optionNameLabel: UILabel!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerView: UIView!
    
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
        self.dividerView.isHidden = true
    }
    
    /// Configure collection view cell to set the data
    internal func configureCell(optionImage: UIImage, optionName: String, isLastCell: Bool) {
        self.optionNameLabel.text = optionName
        self.optionImageView.image = optionImage
        if isLastCell {
            self.imageViewHeightConstraint.constant = 37.0
            self.imageViewTopConstraint.constant = 6.0
            self.titleTopConstraint.constant = 15.0
        } else {
            self.imageViewHeightConstraint.constant = 50.0
            self.imageViewTopConstraint.constant = 0.0
            self.titleTopConstraint.constant = 8.0
        }
        
    }
}
