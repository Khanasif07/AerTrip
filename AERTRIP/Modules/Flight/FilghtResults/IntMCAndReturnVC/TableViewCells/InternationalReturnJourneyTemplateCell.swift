//
//  InternationalReturnJourneyCell.swift
//  Aertrip
//
//  Created by Appinventiv on 16/04/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class InternationalReturnJourneyTemplateCell : UITableViewCell {

        @IBOutlet weak var logoTwo: UIImageView!
        @IBOutlet weak var airlineTitle: UILabel!
        @IBOutlet weak var departureTime: UILabel!
        @IBOutlet weak var arrivalTime: UILabel!
        @IBOutlet weak var durationTime: UILabel!
    @IBOutlet weak var airportsNameView: UIView!
    @IBOutlet weak var departureAirports: UILabel!
        @IBOutlet weak var arrivalAirports: UILabel!
        @IBOutlet weak var dashedView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dashedView.setupDashedView()
        self.contentView.backgroundColor = AppColors.themeWhiteDashboard
        self.airportsNameView.backgroundColor = AppColors.themeWhiteDashboard
        self.selectionStyle = .none
        self.addShimmerEffect(to: [ self.logoTwo ,  self.airlineTitle ,self.arrivalTime , self.departureTime, self.arrivalAirports ,self.departureAirports] )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.airportsNameView.backgroundColor = AppColors.themeWhiteDashboard
        self.contentView.backgroundColor = AppColors.themeWhiteDashboard
    }
    
    func setUpView(){
        self.departureTime.font = AppFonts.SemiBold.withSize(18)
        self.arrivalTime.font = AppFonts.SemiBold.withSize(18)
        self.durationTime.font = AppFonts.Regular.withSize(14)
        self.departureAirports.font = AppFonts.Regular.withSize(16)
        self.arrivalAirports.font = AppFonts.Regular.withSize(16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
