//
//  InternationalRetunrFlightResultCollectionViewCell.swift
//  AERTRIP
//
//  Created by apple on 07/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class InternationalRetunrFlightResultCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var flightImageView: UIImageView!
    @IBOutlet weak var flightNameLabel: UILabel!
    @IBOutlet weak var sourceDepartureTimeLabel: UILabel!
    @IBOutlet weak var sourceArrivalTimeLabel: UILabel!
    @IBOutlet weak var travelTimeLabel: UILabel!
    @IBOutlet weak var sourceAirportCodeLabel: UILabel!
    @IBOutlet weak var destinationAirportCodeLabel: UILabel!
    
    // Return View
    
    @IBOutlet weak var returnFlightImageView: UIImageView!
    @IBOutlet weak var returnFlightNameLabel: UILabel!
    @IBOutlet weak var returnDepartureTimeLabel:UILabel!
    @IBOutlet weak var returnArrivalTimeLabel: UILabel!
    @IBOutlet weak var returnTravelTimeLabel: UILabel!
    
    @IBOutlet weak var returnSourceAirportCodeLabel: UILabel!
    @IBOutlet weak var returnDestinationAirportCodeLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
  
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpColor()
    }
    

    private func setUpFont() {
        
    }
    
    private func setUpColor() {
        
    }

}
