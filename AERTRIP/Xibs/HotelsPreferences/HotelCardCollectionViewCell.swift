//
//  HotelCardCollectionViewCell.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 31/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelCardCollectionViewCellDelegate: class {
    func saveButtonAction(_ sender: UIButton, forHotel: HotelsModel)
}

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
    
    weak var delegate: HotelCardCollectionViewCellDelegate?
    var hotelData: HotelsModel? {
        didSet {
            self.populateData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.gradientView.frame.size
        gradientLayer.colors =
            [AppColors.clear.cgColor, AppColors.themeBlack.withAlphaComponent(0.7).cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        gradientView.backgroundColor = AppColors.clear
        
        self.saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: UIControl.Event.touchUpInside)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.bgView.cornerRadius = 10.0
        self.bgView.layer.borderWidth = 1.0
        self.bgView.layer.borderColor = AppColors.themeGray20.cgColor
    }

    private func populateData() {
        self.hotelNameLabel.text = self.hotelData?.name ?? LocalizedString.na.localized
        self.starRatingView.rating = self.hotelData?.stars ?? 0
        self.greenCircleRatingView.rating = self.hotelData?.taRating ?? 0
        self.saveButton.isSelected = self.hotelData?.isFavourite ?? false
        
        if let image = UIImage(named: "hotelCardPlaceHolder") {
            self.hotelImageView.setImageWithUrl(self.hotelData?.photo ?? "", placeholder: image, showIndicator: true)
        }
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        if let hotel = self.hotelData {
            self.delegate?.saveButtonAction(sender, forHotel: hotel)
        }
    }
}
