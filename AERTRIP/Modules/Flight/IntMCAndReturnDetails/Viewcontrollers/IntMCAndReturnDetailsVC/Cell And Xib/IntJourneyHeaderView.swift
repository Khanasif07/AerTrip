//
//  IntJourneyHeaderView.swift
//  Aertrip
//
//  Created by Apple  on 22.04.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class IntJourneyHeaderView : UIView {

    @IBOutlet weak var DepartTime: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var departAirportCode: UILabel!
    @IBOutlet weak var ArrivalAirportCode: UILabel!

    @IBOutlet weak var SingleLogoImageView: UIImageView!
    @IBOutlet weak var carrierIconOne: UIImageView!
    @IBOutlet weak var carrierIconTwo: UIImageView!

    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var dashedView: UIView!
    @IBOutlet weak var stopCountLabel: UILabel!
    @IBOutlet weak var stopsBackgroundView: UIView!
    @IBOutlet weak var stopBackgroundViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var departAirportCodeWidth: NSLayoutConstraint!
    @IBOutlet weak var arrivalAirportCodeWidth: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashedView.setupDashedView()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("JourneyHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        dashedView.setupDashedView()
        
        let p3AertrioColor = AppColors.calendarSelectedGreen//AppColors.themeGreenishWhite//UIColor(displayP3Red: (236.0/255.0), green: (253.0/255.0), blue: (244.0/255.0), alpha: 1.0)

        stopsBackgroundView.backgroundColor = p3AertrioColor
        contentView.backgroundColor = p3AertrioColor
        departAirportCode.backgroundColor = p3AertrioColor
        ArrivalAirportCode.backgroundColor = p3AertrioColor
        self.setColors()
    }
    
    
    private func setColors(){
        self.ArrivalAirportCode.textColor = AppColors.flightFormReturnEnableColor
        self.departAirportCode.textColor = AppColors.flightFormReturnEnableColor
    }
    
    
    func setValuesFrom( journey : Journey) {
        
        departAirportCodeWidth.constant = 30
        arrivalAirportCodeWidth.constant = 30
        DepartTime.text = journey.startTime
       
        arrivalTime.attributedText =  journey.endTime16size
        ArrivalAirportCode.text = journey.destinationIATACode
        departAirportCode.text = journey.originIATACode
        departAirportCodeWidth.constant = departAirportCode.intrinsicContentSize.width + 11
        arrivalAirportCodeWidth.constant = ArrivalAirportCode.intrinsicContentSize.width + 11
        
        guard let logoArray = journey.airlineLogoArray else { return }
        
        if journey.al.count == 1 {
            SingleLogoImageView.isHidden = false
            setImageFor( imageView : SingleLogoImageView , path : logoArray[0])
            carrierIconOne.isHidden = true
            carrierIconTwo.isHidden = true
        }
        else {
            SingleLogoImageView.isHidden = true
            carrierIconOne.isHidden = false
            carrierIconTwo.isHidden = false
            
            setImageFor( imageView : carrierIconOne , path : logoArray[0])
            setImageFor( imageView : SingleLogoImageView , path : logoArray[1])
        }
        setStopsUI(journey)
    }

    
    fileprivate func setStopsUI(_ journey: Journey) {
        let stopsCount = journey.loap.count
        switch stopsCount {
        case 0 :
            dashedView.isHidden = false
            stopCountLabel.isHidden = true
            stopsBackgroundView.isHidden = true
        case 1 :
            dashedView.isHidden = false
            stopsBackgroundView.isHidden = false
            stopCountLabel.isHidden = true
            addStopsRoundedView(count: 1)
        case 2 :
            dashedView.isHidden = false
            stopsBackgroundView.isHidden = false
            stopCountLabel.isHidden = true
            addStopsRoundedView(count: 2)
        default :
            stopsBackgroundView.isHidden = true
            dashedView.isHidden = true
            stopCountLabel.text = "\(stopsCount) Stops"
            stopCountLabel.isHidden = false
            stopCountLabel.textColor = UIColor.ONE_FIVE_THREE_COLOR
        }
    }
    
    
    func setValuesFrom( journey : IntJourney) {
        
        departAirportCodeWidth.constant = 30
        arrivalAirportCodeWidth.constant = 30
        guard let leg = journey.legsWithDetail.first else {return}
        DepartTime.text = leg.dt
       
        arrivalTime.attributedText =  leg.endTime16size
        ArrivalAirportCode.text = leg.destinationIATACode
        departAirportCode.text = leg.originIATACode
        departAirportCodeWidth.constant = departAirportCode.intrinsicContentSize.width + 11
        arrivalAirportCodeWidth.constant = ArrivalAirportCode.intrinsicContentSize.width + 11
        
        guard let logoArray = journey.airlineLogoArray else { return }
        
        if journey.al.count == 1 {
            SingleLogoImageView.isHidden = false
            setImageFor( imageView : SingleLogoImageView , path : logoArray[0])
            carrierIconOne.isHidden = true
            carrierIconTwo.isHidden = true
        }
        else {
            SingleLogoImageView.isHidden = true
            carrierIconOne.isHidden = false
            carrierIconTwo.isHidden = false
            
            setImageFor( imageView : carrierIconOne , path : logoArray[0])
            setImageFor( imageView : SingleLogoImageView , path : logoArray[1])
        }
        setStopsUI(journey)
    }
    
    fileprivate func setStopsUI(_ journey: IntJourney) {
        let stopsCount = journey.legsWithDetail.first?.loap.count ?? 0
        switch stopsCount {
        case 0 :
            dashedView.isHidden = false
            stopCountLabel.isHidden = true
            stopsBackgroundView.isHidden = true
        case 1 :
            dashedView.isHidden = false
            stopsBackgroundView.isHidden = false
            stopCountLabel.isHidden = true
            addStopsRoundedView(count: 1)
        case 2 :
            dashedView.isHidden = false
            stopsBackgroundView.isHidden = false
            stopCountLabel.isHidden = true
            addStopsRoundedView(count: 2)
        default :
            stopsBackgroundView.isHidden = true
            dashedView.isHidden = true
            stopCountLabel.text = "\(stopsCount) Stops"
            stopCountLabel.isHidden = false
            stopCountLabel.textColor = UIColor.ONE_FIVE_THREE_COLOR
        }
    }
    
    func addStopsRoundedView(count : Int ) {
        
        stopsBackgroundView.subviews.forEach { $0.removeFromSuperview() }

    
        if count == 1 {
            
            let view1 = UIView(frame: CGRect(x: 6, y: 0, width: 6 , height: 6))
            view1.backgroundColor = UIColor.AertripColor
            view1.layer.cornerRadius = 3.0
            stopBackgroundViewWidth.constant = 18
            stopsBackgroundView.addSubview(view1)

        }
        
        if count == 2 {
            
            let view1 = UIView(frame: CGRect(x: 6, y: 0, width: 6 , height: 6))
            view1.backgroundColor = UIColor.AertripColor
            view1.layer.cornerRadius = 3.0
            
            let view2 = UIView(frame: CGRect(x: 20, y: 0, width: 6 , height: 6))
            view2.backgroundColor = UIColor.AertripColor
            view2.layer.cornerRadius = 3.0
            
            stopBackgroundViewWidth.constant = 32.0
            stopsBackgroundView.addSubview(view1)
            stopsBackgroundView.addSubview(view2)
        }
        
    }
    
    
    func setImageFor( imageView : UIImageView , path : String) {
        
        imageView.setImageWithUrl(path, placeholder: UIImage(), showIndicator: false)
        
//        guard  let urlobj = URL(string: path) else {
//            return
//        }
//
//        let urlRequest = URLRequest(url: urlobj)
//        if let responseObj = URLCache.shared.cachedResponse(for: urlRequest ) {
//
//            let image = UIImage(data: responseObj.data)
//            imageView.image  = image
//        }
    }
}
