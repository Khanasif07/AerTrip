//
//  InternationalReturnDetailsCell.swift
//  Aertrip
//
//  Created by Apple  on 16.04.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class InternationalReturnDetailsCell: UITableViewCell {
    
    @IBOutlet weak var iconOne: UIImageView!
    @IBOutlet weak var iconTwo: UIImageView!
    @IBOutlet weak var iconThree: UIImageView!
    @IBOutlet weak var flightCode: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var departureAirportCode: UILabel!
    @IBOutlet weak var arrivalAirportCode: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var dashedView: UIView!
    @IBOutlet weak var stopCountLabel: UILabel!
    @IBOutlet weak var stopsBackgroundView: UIView!
    @IBOutlet weak var stopBackgroundViewWidth: NSLayoutConstraint!
    @IBOutlet weak var arrivalTimeWidth: NSLayoutConstraint!
    var pinnedTriangleLayer : CALayer?
    var smartIconsArray : [String]?
    var baggageSuperScript : NSAttributedString?
    var currentJourney : IntJourney?
    var disableColor:UIColor = AppColors.themeGray10WithAlpha
    
    override var isSelected: Bool{
        didSet{
            let selectedStateBGColor = AppColors.iceGreen
            
            let backgroundColor = isSelected ? selectedStateBGColor : .white
            if !duration.isHidden{
                self.backgroundColor = backgroundColor
                stopsBackgroundView.backgroundColor = backgroundColor
            }
            guard let leg = currentJourney?.legsWithDetail.first else{return}
            if leg.isDisabled{
                self.backgroundColor = disableColor
                if !duration.isHidden{
                    stopsBackgroundView.backgroundColor = disableColor
                }
            }else{
                if !duration.isHidden{
                    stopsBackgroundView.backgroundColor = backgroundColor
                }
                 self.backgroundColor = backgroundColor
            }
        }
    }
    
    
    //MARK:- Override methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let selectedStateBGColor = AppColors.iceGreen
        
        let backgroundColor = selected ? selectedStateBGColor : .white
        if !duration.isHidden{
            self.backgroundColor = backgroundColor
            stopsBackgroundView.backgroundColor = backgroundColor
        }
        guard let leg = currentJourney?.legsWithDetail.first else{return}
        if leg.isDisabled{
            self.backgroundColor = disableColor
            if !duration.isHidden {
                stopsBackgroundView.backgroundColor = disableColor
            }
        }else{
            if !duration.isHidden {
                stopsBackgroundView.backgroundColor = backgroundColor
            }
             self.backgroundColor = backgroundColor
        }
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dashedView.setupDashedView()
    }
    
    //MARK:- Methods
    
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
    

    func showDetailsFrom(journey : IntJourney) {

        currentJourney = journey
        guard let leg = journey.legsWithDetail.first else{return}
        if journey.al.count == 1 {
            flightCode.text = leg.flightsWithDetails.first?.flightCode.replacingOccurrences(of: " ", with: "")
        }
        else {
            flightCode.isHidden = true
        }
        
        departureTime.text = leg.dt
        arrivalTime.attributedText = leg.endTime16size
        arrivalTimeWidth.constant = arrivalTime.intrinsicContentSize.width

        arrivalAirportCode.text = leg.destinationIATACode
        departureAirportCode.text = leg.originIATACode
        self.duration.text = leg.durationTitle

        if leg.isFastest ?? false{
            duration.textColor = .AERTRIP_ORAGE_COLOR
        }
        setStopsUI(journey)
        if leg.isDisabled{
            self.backgroundColor = disableColor
            self.isUserInteractionEnabled = false
        }else{
            self.backgroundColor = AppColors.themeWhite
            self.isUserInteractionEnabled = true
        }
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
            stopCountLabel.textColor = UIColor.ONE_FIVE_THREE_COLOR
        }
    }
    
    
    override func prepareForReuse() {
        
        self.layer.borderWidth = 0
        
        pinnedTriangleLayer?.removeFromSuperlayer()
        duration.textColor = .black
        dashedView.isHidden = false
        stopCountLabel.isHidden = true
        flightCode.isHidden = false
        stopCountLabel.textColor = UIColor.ONE_FIVE_THREE_COLOR
        stopsBackgroundView.subviews.forEach { $0.removeFromSuperview() }
        super.prepareForReuse()
    }
    
    
    func textToImage(drawText text: String, diameter: CGFloat, color: UIColor ) -> UIImage {
        let textColor = UIColor.white
//        let textFont = UIFont(name: "SourceSansPro-Semibold", size: 16)!
  
        let textFont = AppFonts.SemiBold.withSize(16)
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, scale)
        let ctx = UIGraphicsGetCurrentContext()!
        
        var rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.paragraphStyle : titleParagraphStyle
            ] as [NSAttributedString.Key : Any]
        rect = CGRect(x: 0, y: -1, width: diameter, height: 16)
        
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
}
