//
//  SingleJourneyGroupedResultsCell.swift
//  Aertrip
//
//  Created by  hrishikesh on 13/05/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class SingleJourneyGroupedResultsCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var logoOne: UIImageView!
    @IBOutlet weak var logoTwo: UIImageView!
    @IBOutlet weak var logoThree: UIImageView!
    @IBOutlet weak var airlineName: UILabel!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var dayTimelineView: UIView!
    @IBOutlet weak var summaryLabel: UILabel!
 
    @IBOutlet weak var baseTimeView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()

        setupBaseView()
    }
    fileprivate func setupBaseView() {
       
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
        baseView.layer.cornerRadius = 10.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func setVaulesFrom( journey: JourneyOnewayDisplay) {
        
        let firstJourney = journey.first
        
        self.price.text = firstJourney.priceAsString
        self.airlineName.text = firstJourney.airlinesSubString
        

        let groupedTimeDictionary = Dictionary(grouping: journey.journeyArray, by: {$0.startTimePercentile})
        let sortedKeys = groupedTimeDictionary.keys.sorted(by: < )
        for key in sortedKeys {

            guard let journeyArray = groupedTimeDictionary[key] else { continue }
            guard let firstJourney = journeyArray.first else { continue }
            let timeView = roudedView(isPined: firstJourney.isPinned ??  false )
            var timeViewFrame = timeView.frame
            let width = UIScreen.main.bounds.size.width - 134
            timeViewFrame.origin.x = firstJourney.startTimePercentile * CGFloat(width) - 5
            timeView.frame = timeViewFrame
            baseTimeView.addSubview(timeView)
            
            if journeyArray.count > 1 {
                let count = String("\(journeyArray.count)")
                let countLabel = getFlightLabelWith(count: count)
                
                countLabel.center = CGPoint(x:timeView.center.x , y: 9.0)
                baseTimeView.addSubview(countLabel)
            }
        }
        
        let sortedByDuration =   journey.journeyArray.sorted(by: { $0.duration < $1.duration })
        let fastestFlight = sortedByDuration.first!

        
        if journey.isFastest  {
            
//            var attributes = [NSAttributedString.Key.font :UIFont(name: "SourceSansPro-Semibold", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.AertripColor]
  
            var attributes = [NSAttributedString.Key.font :AppFonts.SemiBold.withSize(16), NSAttributedString.Key.foregroundColor : UIColor.AertripColor]

            let summaryText = String(journey.count) + " options from "
            let combinedString = NSMutableAttributedString(string: summaryText + " ", attributes: attributes)
            
//            attributes = [NSAttributedString.Key.font :UIFont(name: "SourceSansPro-Semibold", size: 16.0)!, NSAttributedString.Key.foregroundColor : UIColor.AERTRIP_ORAGE_COLOR]
            
            attributes = [NSAttributedString.Key.font :AppFonts.SemiBold.withSize(16), NSAttributedString.Key.foregroundColor : UIColor.AERTRIP_ORAGE_COLOR]

            let timeString = NSAttributedString(string: fastestFlight.durationTitle, attributes: attributes)
            combinedString.append(timeString)
            summaryLabel.attributedText = combinedString
            
        }
        else {
            let summaryText = String(journey.count) + " options from " + fastestFlight.durationTitle
            summaryLabel.text = summaryText
        }
        
        if firstJourney.isCheapest ?? false {
            price.textColor = .AERTRIP_ORAGE_COLOR
        }
    }
    
    
    func getFlightLabelWith( count : String) -> UILabel
    {
        
        let label = UILabel(frame: CGRect(x:0 , y: 0, width: 20,  height: 18))
        label.textAlignment = .center
//        label.font = UIFont(name: "SourceSansPro-regular", size: 14)!
        label.font = AppFonts.Regular.withSize(14)

        label.textColor = .AertripColor
        label.text = count
        return label
    }
    
    func roudedView(isPined :Bool) -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 18, width: 12, height: 12))
        view.backgroundColor = .white
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 6.0
        
        
        if isPined {
            view.layer.borderColor = UIColor.AERTRIP_RED_COLOR.cgColor

        }else {
            view.layer.borderColor = UIColor.AertripColor.cgColor
        }
        
        return view
    }
    
    override func prepareForReuse() {
        
        for view in self.baseTimeView.subviews {
            view.removeFromSuperview()
        }
        
        logoOne.isHidden = false
        logoTwo.isHidden = false
        logoThree.isHidden = false
        
        price.textColor = .black
        
    }
}
