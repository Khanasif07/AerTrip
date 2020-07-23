//
//  SingleJourneyResultTemplateCell.swift
//  Aertrip
//
//  Created by  hrishikesh on 26/04/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit
//import SkeletonView

class SingleJourneyResultTemplateCell: UITableViewCell {

    
    @IBOutlet weak var singleairlineLogo: UIImageView!
    @IBOutlet weak var airlineTitle: UILabel!
    @IBOutlet weak var DepartureTime: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    
    @IBOutlet weak var departureAirports: UILabel!
    @IBOutlet weak var arrivalAirports: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var dashedView: UIView!
    
    fileprivate func setupBaseView() {
       
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        baseView.layer.cornerRadius = 10.0
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dashedView.setupDashedView()
        setupBaseView()
        addShimmerEffect(to: [singleairlineLogo,airlineTitle , DepartureTime , departureAirports ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
            self.addShimmerEffect(to: [ self.arrivalTime , self.arrivalAirports , self.price] )
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
