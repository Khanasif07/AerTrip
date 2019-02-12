//
//  ATGalleryCell.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ATGalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint! //it's a equal height to super view constraint
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func configureData() {
        guard let imgD = self.imageData else {return}
        
        self.imageView.contentMode = ATGalleryViewConfiguration.imageContentMode
        
        self.imageView.image = ATGalleryViewConfiguration.placeholderImage
        
        if let img = imgD.image {
            self.imageView.image = img
        }
        else if let url = imgD.imageUrl {
            self.imageView.setImageWithUrl(url.absoluteString, placeholder: ATGalleryViewConfiguration.placeholderImage, showIndicator: ATGalleryViewConfiguration.shouldShowLoader)
        }
    }
}
