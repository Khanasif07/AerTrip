//
//  BookingDocumentsCollectionViewCell.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingDocumentsCollectionViewCell: UICollectionViewCell {

    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var documentsSizeLabel: UILabel!
    @IBOutlet weak var documentsImageView: UIImageView!
    @IBOutlet weak var progressView: CircularProgress!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        self.loaderSetUp()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        self.nameLabel.font = AppFonts.Regular.withSize(16.0)
        self.nameLabel.textColor = AppColors.themeBlack
        self.documentsSizeLabel.font = AppFonts.Regular.withSize(16.0)
        self.documentsSizeLabel.textColor = AppColors.themeGray40
    }
    
    internal func configCell(name: String , imageUrl: String , documentsSize: String) {
        self.nameLabel.text = name
//        self.documentsImageView.setImageWithUrl(imageUrl, placeholder: #imageLiteral(resourceName: "va"), showIndicator: true)
        self.documentsImageView.image = #imageLiteral(resourceName: "va")
        self.documentsSizeLabel.text = documentsSize
    }
    
    private func loaderSetUp() {
        self.progressView.progressColor = AppColors.themeWhite
        self.progressView.trackColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.4196078431, alpha: 1)
        self.progressView.isHidden = true
    }
    
    internal func animateProgressBar() {
        self.progressView.isHidden = false
        self.progressView.setProgressWithAnimation(duration: 1.5, value: 1.0)
    }
    
    //Mark:- IBActions
    //================
    
}
