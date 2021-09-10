//
//  PhotoGalleryCell.swift
//  AERTRIP
//
//  Created by Apple  on 27.03.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

protocol ImageDownloadDelegate:NSObjectProtocol{
    func imageDownloadCompleted(with image:UIImage?, at index:Int)
}

class PhotoGalleryCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cellWidth: NSLayoutConstraint!
    
    weak var delegate:ImageDownloadDelegate?
    var cellIndex:IndexPath = [0,0]
    
    func configureData(with imageData: ATGalleryImage?) {
        guard let imgD = imageData else{return}
        self.imageView.image = ATGalleryViewConfiguration.placeholderImage
        
        if let img = imgD.image {
            self.delegate?.imageDownloadCompleted(with: img, at: self.cellIndex.row)
            self.imageView.image = img
        }
        else if let url = imgD.imageUrl {
            self.imageView.setImageWithUrl(imageUrl: url.absoluteString, placeholder: ATGalleryViewConfiguration.placeholderImage, showIndicator: ATGalleryViewConfiguration.shouldShowLoader){[weak self] image, error in
                guard let self = self else{ return ()}
                if image != nil{
                    self.delegate?.imageDownloadCompleted(with: image, at: self.cellIndex.row)
                }
                return ()
            }
        }
    }
    
}
