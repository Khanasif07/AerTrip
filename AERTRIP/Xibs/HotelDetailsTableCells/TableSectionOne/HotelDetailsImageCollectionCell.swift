//
//  HotelFilterImageCell.swift
//  AERTRIP
//
//  Created by Admin on 08/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsImageCollectionCell: UICollectionViewCell {

    //Mark:- Variables
    //================
    
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var smallLineView: UIView!
    
    weak var delegate:ImageDeletionDelegate?
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.smallLineView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        self.smallLineView.cornerradius = self.smallLineView.height/2.0
        self.smallLineView.clipsToBounds = true
        self.smallLineView.isHidden = true
        self.initialSetup()
    }
    
    
    //Mark:- Methods
    //==============
    internal func configCell(imgUrl: String, cornerRadius: CGFloat = 10.0) {
        self.bgView.roundTopCorners(cornerRadius: cornerRadius)
        self.hotelImageView.setImageWithUrl(imgUrl, placeholder: #imageLiteral(resourceName: "hotelCardPlaceHolder"), showIndicator: true)
    }
    
    func configureCell(with images: ATGalleryImage, cornerRadius: CGFloat = 10.0){
        self.bgView.roundTopCorners(cornerRadius: cornerRadius)
        if let img = images.image {
            self.hotelImageView.image = img
        }
        else if let url = images.imageUrl {
            self.hotelImageView.setImageWithUrl(imageUrl: url.absoluteString, placeholder: ATGalleryViewConfiguration.placeholderImage, showIndicator: ATGalleryViewConfiguration.shouldShowLoader){[weak self] image, error in
                guard let self = self else {return () }
                self.delegate?.shouldRemoveImage(image, for: images.imagePath)
                return ()
            }
        }else{
            self.delegate?.shouldRemoveImage(nil, for: images.imagePath)
        }
    }
    
    private func initialSetup() {
        self.gradientView.backgroundColor = AppColors.clear
        self.gradientView.addGredientWithScreenWidth(isVertical: true, colors: [AppColors.themeBlack.withAlphaComponent(0.5),AppColors.themeBlack.withAlphaComponent(0.0)])
    }
    
}
