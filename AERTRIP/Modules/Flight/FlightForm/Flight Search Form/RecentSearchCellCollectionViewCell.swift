//
//  RecentSearchCellCollectionViewCell.swift
//  Aertrip
//
//  Created by Hrishikesh Devhare on 02/01/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class RecentSearchCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var planeIcon: UIImageView!
    @IBOutlet weak var travelDirection: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var travelPath: UILabel!
    @IBOutlet weak var travelClass: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var TravelPax: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        blurView.layer.cornerRadius = 10.0;
        blurView.clipsToBounds = true;
        planeIcon.image = UIImage (named: "plane")?.withRenderingMode(.alwaysTemplate)
    }
    
   @objc func setProperties( recentSearch : RecentSearchDisplayModel ) {
        
        duration.text = recentSearch.searchTime
        travelPath.attributedText = recentSearch.travelPlan
        date.text = recentSearch.travelDate
        travelDirection.text = recentSearch.travelType
        travelClass.text = recentSearch.flightClass
        TravelPax.text = recentSearch.paxCount
    }
}
