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
    
    @IBOutlet weak var baseViewTopConstraint: NSLayoutConstraint!
    
    var isFirstCell: Bool = false {
        didSet {
            updateTopConstraints()
        }
    }
    
    fileprivate func setupBaseView() {
       
//        backgroundColor = .clear
//        layer.masksToBounds = false
//        layer.shadowOpacity = 0.4
//        layer.shadowRadius = 4
//        layer.shadowOffset = CGSize(width: 0, height: 0)
//        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
//        baseView.layer.cornerRadius = 10.0
        
        let shadowProp = AppShadowProperties()
        self.baseView.addShadow(cornerRadius: shadowProp.cornerRadius, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: shadowProp.shadowColor, offset: shadowProp.offset, opacity: shadowProp.opecity, shadowRadius: shadowProp.shadowRadius)
        
//        self.baseView.addShadow(cornerRadius: 10, maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)

    }
    
    func updateTopConstraints() {
        self.baseViewTopConstraint.constant = isFirstCell ? 10 : 8
        self.contentView.layoutIfNeeded()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.baseView.backgroundColor = AppColors.themeWhiteDashboard
        dashedView.setupDashedView()
        setupBaseView()
        addShimmerEffect(to: [singleairlineLogo,airlineTitle , DepartureTime , departureAirports ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
            self.addShimmerEffect(to: [ self.arrivalTime , self.arrivalAirports , self.price] )
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.baseView.backgroundColor = AppColors.themeWhiteDashboard
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
