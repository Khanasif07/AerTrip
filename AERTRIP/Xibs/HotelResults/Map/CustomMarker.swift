//
//  CustomMarker.swift
//  AERTRIP
//
//  Created by apple on 18/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class CustomMarker: UIView {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var connectorView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        doInitialSetup()
    }
    
    var hotel: HotelSearched? {
        didSet {
            self.configureData()
        }
    }
    var isFavourite: Bool = false {
        didSet {
           self.updateFav()
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            self.updateSelection()
            self.updateMakerImage()
        }
    }
    
    var isDetailsShown = false{
        didSet{
            updateMakerImage()
        }
    }
    
    class func instanceFromNib() -> CustomMarker {
        return UINib(nibName: "CustomMarker", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CustomMarker
    }
    
    
    func doInitialSetup() {
        isFavourite = false
        
        self.priceView.addShadow(cornerRadius: 8.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize(width: 0.0, height: 3.0), opacity: 1, shadowRadius: 3.0)
    }
    
    func updateMakerImage(){
        self.priceView.isHidden = !(isDetailsShown || isSelected)
        self.connectorView.isHidden = !(isDetailsShown || isSelected)
    }
    
    private func configureData() {
        self.isFavourite = (hotel?.fav ?? "0") == "1"
        
        var price : Double = hotel?.perNightPrice ?? 0.0
        if  let filter = UserInfo.hotelFilter, filter.priceType == .Total {
            price = hotel?.price ?? 0.0
        }
        
//        let str = NSAttributedString(string: hotel?.hotelName?.substring(to: 4) ?? "")
//        ttributedFontForText(text: price.getPreferredCurrency, textFont: AppFonts.Regular.withSize(12))

        self.priceLabel.attributedText = price.getConvertedAmount(using: AppFonts.SemiBold.withSize(16.0))
        self.priceLabel.AttributedFontForText(text: price.getPreferredCurrency, textFont: AppFonts.SemiBold.withSize(12.0))
        updateMakerImage()
        
//        self.priceLabel.sizeToFit()
        self.priceView.layoutSubviews()
        self.layoutIfNeeded()

    }
    
    private func updateFav() {
        priceView.layer.cornerRadius = 8.0
        priceView.layer.borderWidth = 1.0
       // priceLabel.font = AppFonts.SemiBold.withSize(12.0)

        if isFavourite {
            priceView.layer.borderColor = AppColors.themeRed.cgColor
            priceView.backgroundColor = AppColors.themeRed
            priceLabel.textColor = AppColors.themeWhite
            connectorView.backgroundColor = AppColors.themeRed
            iconImageView.image = AppImages.favHotelWithShadowMarker
        }
        else {
            iconImageView.image = AppImages.clusterSmallTag
            self.updateSelection()
        }
    }
    
    private func updateSelection() {
        
        if isSelected && isFavourite {
            self.updateFav()
            return
        }
//        guard !isFavourite else {
//            self.updateFav()
//            return
//        }
        
        connectorView.backgroundColor = (isFavourite ? AppColors.themeRed : AppColors.themeGreen)
        
        priceView.layer.borderColor = isSelected ? AppColors.clear.cgColor : (isFavourite ? AppColors.themeRed.cgColor : AppColors.themeGreen.cgColor)
        priceView.layer.borderWidth = isSelected ? 0.0 : 1.0
        priceView.backgroundColor = isSelected ? (isFavourite ? AppColors.themeRed : AppColors.themeGreen) : AppColors.themeWhite

        priceLabel.textColor = isSelected ? AppColors.themeWhite : (isFavourite ? AppColors.themeRed : AppColors.themeGray60)
    }
}
