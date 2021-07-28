//
//  DomesticMultiLegTemplateCell.swift
//  Aertrip
//
//  Created by  hrishikesh on 15/07/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class DomesticMultiLegTemplateCell: UITableViewCell {

    //MARK:- Outlets

    @IBOutlet weak var airlineLogo: UIView!
    @IBOutlet weak var flightCode: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var departureAirportCode: UILabel!
    @IBOutlet weak var arrivalAirportCode: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var dashedView: UIView!
   
    
    //MARK:- Override methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashedView.setupDashedView(strokeColor: AppColors.common51)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.backgroundColor = AppColors.themeWhite
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showTemplateView()
        self.contentView.backgroundColor = AppColors.themeWhite
        dashedView.setupDashedView(strokeColor: AppColors.common51)
    }
    
   //MARK:- Methods
    func showTemplateView() {
        
        self.addShimmerEffect(to: [airlineLogo, departureTime ,departureAirportCode], backgroundClr: AppColors.shimmerEffectLayerColor2, gradientColors: [AppColors.unicolorWhite.withAlphaComponent(0), AppColors.shimmerEffectColor, AppColors.unicolorWhite.withAlphaComponent(0)] )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
                        
            self.addShimmerEffect(to: [ self.flightCode ,  self.arrivalTime , self.arrivalAirportCode , self.price ], backgroundClr: AppColors.shimmerEffectLayerColor2, gradientColors: [AppColors.unicolorWhite.withAlphaComponent(0), AppColors.shimmerEffectColor, AppColors.unicolorWhite.withAlphaComponent(0)])
            
        }
    }
    
}
