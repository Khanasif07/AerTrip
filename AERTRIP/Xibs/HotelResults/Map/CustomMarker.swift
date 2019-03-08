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
    
    class func instanceFromNib() -> CustomMarker {
        return UINib(nibName: "CustomMarker", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CustomMarker
    }
    
    
    func doInitialSetup() {
        isFavourite = false
    }
    
    private func configureData() {
        self.isFavourite = (hotel?.fav ?? "0") == "1"
        self.priceLabel.attributedText = (AppConstants.kRuppeeSymbol + "\(hotel?.price.delimiter ?? "0")").addPriceSymbolToLeft(using: AppFonts.SemiBold.withSize(16.0))
    }
    
    private func updateFav() {
        priceView.layer.cornerRadius = 8.0
        priceView.layer.borderWidth = 1.0
        priceLabel.font = AppFonts.SemiBold.withSize(16.0)

        if isFavourite {
            priceView.layer.borderColor = AppColors.themeRed.cgColor
            priceLabel.textColor = AppColors.themeRed
            connectorView.backgroundColor = AppColors.themeRed
            iconImageView.image = #imageLiteral(resourceName: "favHotelWithShadowMarker")
        }
        else {
            priceView.layer.borderColor = AppColors.themeGreen.cgColor
            priceLabel.textColor = AppColors.themeGreen
            connectorView.backgroundColor = AppColors.themeGreen
            iconImageView.image = #imageLiteral(resourceName: "clusterSmallTag")
        }
    }
}
