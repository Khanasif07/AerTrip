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
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
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
    
    //Mark:- IBActions
    //================
    
}
