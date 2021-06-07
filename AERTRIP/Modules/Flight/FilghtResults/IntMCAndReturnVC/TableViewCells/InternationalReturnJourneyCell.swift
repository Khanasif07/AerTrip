//
//  InternationalReturnJourneyCell.swift
//  Aertrip
//
//  Created by Appinventiv on 16/04/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit
import Kingfisher

class InternationalReturnJourneyCell : UITableViewCell {
    
    @IBOutlet weak var logoOne: UIImageView!
    @IBOutlet weak var logoTwo: UIImageView!
    @IBOutlet weak var logoThree: UIImageView!
    
    @IBOutlet weak var airlineTitle: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var durationTime: UILabel!
    @IBOutlet weak var airportsNameView: UIView!
    
    @IBOutlet weak var departureAirports: UILabel!
    @IBOutlet weak var arrivalAirports: UILabel!
    @IBOutlet weak var dashedView: UIView!
    @IBOutlet weak var immediateAirportWidth: NSLayoutConstraint!
    @IBOutlet weak var intermediateAirports: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dashedView.setupDashedView()
        self.setupColors()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setupColors()
    }
    func setUpView(){
        self.departureTime.font = AppFonts.SemiBold.withSize(18)
        self.arrivalTime.font = AppFonts.SemiBold.withSize(18)
        self.durationTime.font = AppFonts.Regular.withSize(14)
        self.departureAirports.font = AppFonts.Regular.withSize(16)
        self.arrivalAirports.font = AppFonts.Regular.withSize(16)
        self.intermediateAirports.font = AppFonts.Regular.withSize(14)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populateData(leg : IntMultiCityAndReturnWSResponse.Results.Ldet){
        self.departureTime.text = leg.dt
        self.arrivalTime.attributedText = leg.endTime18Size
        self.durationTime.text = leg.durationTitle
        self.airlineTitle.text = leg.airlinesSubString
        self.departureAirports.text = leg.originIATACode
        self.arrivalAirports.text = leg.destinationIATACode
        self.setIntermediateAirportsData(leg : leg)
        self.durationTime.textColor = (leg.isFastest ?? false) ? .AERTRIP_ORAGE_COLOR : .ONE_ZORE_TWO_COLOR
    }
    
    func setIntermediateAirportsData(leg : IntMultiCityAndReturnWSResponse.Results.Ldet){
        self.intermediateAirports.text = leg.intermediateAirports
        self.intermediateAirports.isHidden = leg.intermediateAirports.isEmpty
        let fontAttributes = [NSAttributedString.Key.font: AppFonts.Regular.withSize(14)]
        let myText = leg.intermediateAirports
        let size = (myText as NSString).size(withAttributes: fontAttributes)
        self.immediateAirportWidth.constant = size.width + 20
        self.setUpLogos(leg: leg)
        
    }
    
    func setupColors(){
        self.contentView.backgroundColor = AppColors.themeWhiteDashboard
        self.airportsNameView.backgroundColor = AppColors.themeWhiteDashboard
        self.intermediateAirports.backgroundColor = AppColors.themeWhiteDashboard
        self.intermediateAirports.textColor = AppColors.themeGray153
    }
    
    func setUpLogos(leg : IntMultiCityAndReturnWSResponse.Results.Ldet){
        if let logoArray = leg.airlineLogoArray {
            
            switch logoArray.count {
            case 1 :
                self.logoOne.isHidden = false
                self.logoTwo.isHidden = true
                self.logoThree.isHidden = true
                
                self.logoOne?.setImageWithUrl(logoArray[0], placeholder: UIImage(), showIndicator: false)
                
            case 2 :
                self.logoOne.isHidden = false
                self.logoTwo.isHidden = false
                self.logoThree.isHidden = true
                self.logoOne?.setImageWithUrl(logoArray[0], placeholder: UIImage(), showIndicator: false)
                self.logoTwo?.setImageWithUrl(logoArray[1], placeholder: UIImage(), showIndicator: false)
                
                
            case 3 :
                self.logoOne.isHidden = false
                self.logoTwo.isHidden = false
                self.logoThree.isHidden = false
                self.logoOne?.setImageWithUrl(logoArray[0], placeholder: UIImage(), showIndicator: false)
                self.logoTwo?.setImageWithUrl(logoArray[1], placeholder: UIImage(), showIndicator: false)
                self.logoThree?.setImageWithUrl(logoArray[2], placeholder: UIImage(), showIndicator: false)
                
                
            default:
                break
            }
            
//            self.logoOne.isHidden = false
//            self.logoTwo.isHidden = false
//            self.logoThree.isHighlighted = false
//
//            self.logoOne.backgroundColor = .blue
//            self.logoTwo.backgroundColor = .red
//            self.logoThree.backgroundColor = .yellow
            
            
        }
    }
    
}
