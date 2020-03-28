//
//  PhotoGalleryCell.swift
//  AERTRIP
//
//  Created by Apple  on 27.03.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class PhotoGalleryCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cellWidth: NSLayoutConstraint!
        
    func configureData(with imageData: ATGalleryImage?) {
        guard let imgD = imageData else{return}
        self.imageView.image = ATGalleryViewConfiguration.placeholderImage
        
        if let img = imgD.image {
            self.imageView.image = img
        }
        else if let url = imgD.imageUrl {
            self.imageView.setImageWithUrl(url.absoluteString, placeholder: ATGalleryViewConfiguration.placeholderImage, showIndicator: ATGalleryViewConfiguration.shouldShowLoader)
        }
    }
    
}
