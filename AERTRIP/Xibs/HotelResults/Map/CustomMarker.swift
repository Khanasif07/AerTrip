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
        
        self.priceView.addShadow(cornerRadius: 8.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.5), offset: CGSize(width: 0.0, height: 3.0), opacity: 0.5, shadowRadius: 2.0)
    }
    
    private func configureData() {
        self.isFavourite = (hotel?.fav ?? "0") == "1"
        
        var price : Double = hotel?.price ?? 0.0
        if  let filter = UserInfo.hotelFilter, filter.priceType == .PerNight {
            price = hotel?.perNightPrice ?? 0.0
        }
        
        let str = NSAttributedString(string: hotel?.hotelName?.substring(to: 4) ?? "")
        self.priceLabel.attributedText = (price.amountInDelimeterWithSymbol).addPriceSymbolToLeft(using: AppFonts.SemiBold.withSize(16.0)) + str
    }
    
    private func updateFav() {
        priceView.layer.cornerRadius = 8.0
        priceView.layer.borderWidth = 1.0
        priceLabel.font = AppFonts.SemiBold.withSize(12.0)

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
