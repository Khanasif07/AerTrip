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
        }
    }
    
    class func instanceFromNib() -> CustomMarker {
        return UINib(nibName: "CustomMarker", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CustomMarker
    }
    
    
    func doInitialSetup() {
        isFavourite = false
    }
    
    private func configureData() {
        self.isFavourite = (hotel?.fav ?? "0") == "1"
        
        var price : String = "\(hotel?.price.delimiter ?? "")"
        if  let filter = UserInfo.hotelFilter  {
            switch filter.priceType {
            case .Total :
                price = "\(hotel?.price.delimiter ?? "")"
            case .PerNight:
                price  = "\(hotel?.perNightPrice.delimiter ?? "")"
            }
        }
        self.priceLabel.attributedText = (AppConstants.kRuppeeSymbol + "\(price)").addPriceSymbolToLeft(using: AppFonts.SemiBold.withSize(16.0))
    }
    
    private func updateFav() {
        priceView.layer.cornerRadius = 8.0
        priceView.layer.borderWidth = 1.0
        priceLabel.font = AppFonts.SemiBold.withSize(16.0)

        if isFavourite {
            priceView.layer.borderColor = AppColors.themeRed.cgColor
            priceView.backgroundColor = AppColors.themeRed
            priceLabel.textColor = AppColors.themeWhite
            connectorView.backgroundColor = AppColors.themeRed
            iconImageView.image = #imageLiteral(resourceName: "favHotelWithShadowMarker")
        }
        else {
            iconImageView.image = #imageLiteral(resourceName: "clusterSmallTag")
            self.updateSelection()
        }
    }
    
    private func updateSelection() {
        guard !isFavourite else {
            self.updateFav()
            return
        }
        
        connectorView.backgroundColor = AppColors.themeGreen
        
        priceView.layer.borderColor = isSelected ? AppColors.clear.cgColor : AppColors.themeGreen.cgColor
        priceView.layer.borderWidth = isSelected ? 0.0 : 1.0
        priceView.backgroundColor = isSelected ? AppColors.themeGreen : AppColors.themeWhite

        priceLabel.textColor = isSelected ? AppColors.themeWhite : AppColors.themeGreen
    }
}
