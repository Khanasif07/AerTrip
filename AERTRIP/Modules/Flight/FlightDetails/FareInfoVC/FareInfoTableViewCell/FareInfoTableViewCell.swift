//
//  FareInfoTableViewCell.swift
//  Aertrip
//
//  Created by Monika Sonawane on 23/12/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class FareInfoTableViewCell: UITableViewCell
{
    @IBOutlet weak var topSeperatorLabel: ATDividerView!
    @IBOutlet weak var topSeperatorLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fareRulesButton: UIButton!
    
    @IBOutlet weak var nonReschedulableView: UIView!
    @IBOutlet weak var nonReschedulableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nonRefundableView: UIView!
    @IBOutlet weak var nonRefundableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cancellationNoteDisplayView: UIView!
    @IBOutlet weak var cancellationNoteDisplayViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottomSeparatorLabel: ATDividerView!
    @IBOutlet weak var bottomSeparatorLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomSeparatorLabelLeading: NSLayoutConstraint!
    
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var seperatorViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var journeyNameView: UIView!
    @IBOutlet weak var journeyNameViewHeight: NSLayoutConstraint!
    @IBOutlet weak var journeyNameLbl: UILabel!
    @IBOutlet weak var carrierImgView: UIImageView!
    
    @IBOutlet weak var journeyNameSeperatorLabel: UILabel!
    @IBOutlet weak var titleLabelTop: NSLayoutConstraint!
    @IBOutlet weak var fareRulesView: UIView!
    @IBOutlet weak var fareRulesViewHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        carrierImgView.layer.cornerRadius = 3.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setAirlineImage(with url: String){
        
        if let urlobj = URL(string: url){
            let urlRequest = URLRequest(url: urlobj)
            if let responseObj = URLCache.shared.cachedResponse(for: urlRequest) {
                let image = UIImage(data: responseObj.data)
                self.carrierImgView.image = image
            }else{
                self.carrierImgView.setImageWithUrl(url, placeholder: UIImage(), showIndicator: true)
            }
        }else{
            self.carrierImgView.setImageWithUrl(url, placeholder: UIImage(), showIndicator: true)
        }

    }
    
    
    
    func setupFareRulesButton(fareRulesData:[JSONDictionary],index:Int)->Bool
    {
        var isFareRulesButtonVisble = false
        
        if fareRulesData.count > 0{
            if fareRulesData.count > index{
                let data = [fareRulesData[index]]
                let val = data[0]
                if val.count > 0{
                    
                    let vall = val.values
                    if vall.count > 0{
                        if vall.first as? String != nil{
                            if vall.first as! String != ""
                            {
                                fareRulesButton.isHidden = false
                                fareRulesButton.isUserInteractionEnabled = true
                                
                                isFareRulesButtonVisble = true
                            }
                        }
                    }
                }
            }
        }else{
            fareRulesButton.isHidden = true
            fareRulesButton.isUserInteractionEnabled = false
            
            isFareRulesButtonVisble = false
        }
        
        return isFareRulesButtonVisble
    }
    
    
    func setupTitle(flight:FlightDetail,journey:[Journey],index:Int,airportDetailsResult:[String : AirportDetailsWS])
    {
//        let flight = flights![indexPath.row]
        let cc = flight.cc
        let fbn = flight.fbn
        var bc = flight.bc
        if bc != ""{
            bc =  " (" + bc + ")"
        }
        var displayTitle = ""
        if fbn != ""{
            displayTitle = fbn.capitalized + bc
        }else{
            displayTitle = cc.capitalized + bc
        }
        
        if journey.count > 0{
            var location = ""
            titleLabel.text = displayTitle
            
            if journey.count == 1{
                titleLabelTop.constant = 16
                journeyNameLbl.isHidden = true
                carrierImgView.isHidden = true
                journeyNameSeperatorLabel.isHidden = true
            }else{
                titleLabelTop.constant = 73.5
                journeyNameLbl.isHidden = false
                carrierImgView.isHidden = false
                journeyNameSeperatorLabel.isHidden = false
                
                let ap = journey[index].ap
                let departureAirportDetails = airportDetailsResult[ap[0]]
                let arrivalAirportDetails = airportDetailsResult[ap[1]]
                
                if departureAirportDetails != nil && arrivalAirportDetails != nil{
                    location = departureAirportDetails!.c! + " → " + arrivalAirportDetails!.c!
                }else if departureAirportDetails != nil{
                    location = departureAirportDetails!.c!
                }else if arrivalAirportDetails != nil{
                    location = arrivalAirportDetails!.c!
                }else{
                    location = displayTitle
                }
                
                journeyNameLbl.text = location
                
                let al = journey[index].al.first ?? ""
                
                let logoURL = "http://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/" + al.uppercased() + ".png"
                setAirlineImage(with: logoURL)
                
            }
        }
    }
}
