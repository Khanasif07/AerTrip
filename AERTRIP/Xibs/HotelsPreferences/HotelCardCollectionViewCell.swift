//
//  HotelCardCollectionViewCell.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 31/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: UILabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var tripLogoImage: UIImageView!
    @IBOutlet weak var greenCircleRatingView: FloatRatingView!
    @IBOutlet weak var gradientView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.gradientView.frame.size
        gradientLayer.colors =
            [AppColors.clear.cgColor, AppColors.themeBlack.withAlphaComponent(0.7).cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        gradientView.backgroundColor = AppColors.clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.bgView.cornerRadius = 10
    }

    func populateData(data: HotelsModel) {
        
        self.hotelNameLabel.text = data.name
        self.starRatingView.rating = data.stars
        self.greenCircleRatingView.rating = data.taRating
        
        if let image = UIImage(named: "hotelCardPlaceHolder") {
            self.hotelImageView.setImageWithUrl(data.photo, placeholder: image, showIndicator: true)
        }
        
    }
}
