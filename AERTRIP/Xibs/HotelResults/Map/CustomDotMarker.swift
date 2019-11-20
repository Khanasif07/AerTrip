//
//  CustomDotMarker.swift
//  AERTRIP
//
//  Created by apple on 18/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class CustomDotMarker: UIView {
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

    class func instanceFromNib() -> CustomDotMarker {
        return UINib(nibName: "CustomDotMarker", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CustomDotMarker
    }
    
    
    func doInitialSetup() {
        isFavourite = false
    }
    
    private func configureData() {
        self.isFavourite = (hotel?.fav ?? "0") == "1"
    }
    
    private func updateFav() {
//        if isFavourite {
//            iconImageView.image = #imageLiteral(resourceName: "favHotelWithShadowMarker")
//        }
//        else {
            iconImageView.image = #imageLiteral(resourceName: "clusterSmallTag")
//        }
    }
}
