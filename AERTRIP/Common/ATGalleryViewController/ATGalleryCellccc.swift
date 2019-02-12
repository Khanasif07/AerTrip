//
//  ATGalleryCell.swift
//
//  Created by Pramod Kumar on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ATGalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var imageData: ATGalleryImage? {
        didSet {
            self.configureData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        indicator.isHidden = true
        
        imageView.clipsToBounds = true
        imageView.backgroundColor = AppColors.themeBlack
    }
    
    private func configureData() {
        guard let imgD = self.imageData else {return}
        
        self.imageView.contentMode = ATGalleryViewConfiguration.viewMode == .horizontal ? .center : imgD.contentMode
        
        self.imageView.image = ATGalleryViewConfiguration.placeholderImage
        if let img = imgD.image {
            self.imageView.image = img
        }
        else if let url = imgD.imageUrl {
            self.imageView.setImageWithUrl(url.absoluteString, placeholder: ATGalleryViewConfiguration.placeholderImage, showIndicator: ATGalleryViewConfiguration.shouldShowLoader)
        }
    }
}
