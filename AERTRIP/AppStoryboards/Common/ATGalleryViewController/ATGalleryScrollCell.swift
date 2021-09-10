//
//  ATGalleryCell.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ATGalleryScrollCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint! //it's a equal height to super view constraint
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        
        scrollView.minimumZoomScale = 1.0

        scrollView.maximumZoomScale = ATGalleryViewConfiguration.maximumZoomScale
        scrollView.zoomScale = 1.0
        scrollView.delegate = self
        
        self.makeImageInCenter()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.zoomScale = 1.0
    }
    
    private func configureData() {
        guard let imgD = self.imageData else {return}
        
        self.imageView.contentMode = .scaleAspectFit//ATGalleryViewConfiguration.imageContentMode
        
        self.imageView.image = ATGalleryViewConfiguration.placeholderImage        
        
        if let img = imgD.image {
            self.imageView.image = img
        }
        else if let url = imgD.imageUrl {
            self.imageView.setImageWithUrl(url.absoluteString, placeholder: ATGalleryViewConfiguration.placeholderImage, showIndicator: ATGalleryViewConfiguration.shouldShowLoader)
        }
    }
    
    func makeImageInCenter() {
//        self.imageView.removeFromSuperview()
//        self.imageView.translatesAutoresizingMaskIntoConstraints = true
        
        let newFrame = CGRect(x: 0.0, y: (UIDevice.screenHeight - ATGalleryViewConfiguration.imageViewHeight)/2.0, width: UIDevice.screenWidth, height: ATGalleryViewConfiguration.imageViewHeight)
        
//        self.imageView.frame = newFrame
        
//        self.scrollView.addSubview(self.imageView)
    }
}

extension ATGalleryScrollCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        let subView = scrollView.subviews[0] // get the image view
//        subView.center = scrollView.center
//    }
//    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
//        let subView = scrollView.subviews[0] // get the image view
////        subView.center = scrollView.center
//    }
}
