//
//  ThingsCanBeAskedHeader.swift
//  AERTRIP
//
//  Created by Appinventiv on 10/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class ThingsCanBeAskedHeader : UITableViewHeaderFooterView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var hraderTitle: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
 
    func populateData(section : Int){
        
        if section == 0{
            hraderTitle.text = LocalizedString.flights.localized
            imageView.image = #imageLiteral(resourceName: "blueflight")
        }else{
            hraderTitle.text = LocalizedString.hotels.localized
            imageView.image = #imageLiteral(resourceName: "hotelCopy4")
        }
        
    }
    
}
