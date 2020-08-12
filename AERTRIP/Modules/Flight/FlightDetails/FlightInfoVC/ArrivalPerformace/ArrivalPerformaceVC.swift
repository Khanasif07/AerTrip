//
//  ArrivalPerformaceVC.swift
//  Aertrip
//
//  Created by Monika Sonawane on 20/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class ArrivalPerformaceVC: UIViewController
{
    //MARK:- Outlets
    @IBOutlet weak var backgroundDisplayView: UIView!
    @IBOutlet weak var performaceDisplayView: UIView!
    @IBOutlet weak var onTimeProgressDisplayView: UIView!
    @IBOutlet weak var onTimeProgressInPercentLabel: UILabel!
    
    @IBOutlet weak var delayProgressDisplayView: UIView!
    @IBOutlet weak var delayProgressInPercentLabel: UILabel!
    @IBOutlet weak var delayedTitleLbl: UILabel!
    
    @IBOutlet weak var cancelledProgressDisplayView: UIView!
    @IBOutlet weak var cancelledProgressInPercentLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    //MARK:- Variable Declaration
    var onTimePerformanceSubView = UIView()
    var delayedPerformanceSubView = UIView()
    var cancelledPerformanceSubView = UIView()

    var onTimePerformanceInPercent = 0
    var delayedPerformanceInPercent = 0
    var cancelledPerformanceInPercent = 0
    
    var averageDelay = ""
    var observationCount = ""
    
    //MARK:- ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        performaceDisplayView.layer.cornerRadius = 10

        self.onTimeProgressDisplayView.layer.cornerRadius = onTimeProgressDisplayView.frame.height/2
        self.delayProgressDisplayView.layer.cornerRadius = delayProgressDisplayView.frame.height/2
        self.cancelledProgressDisplayView.layer.cornerRadius = cancelledProgressDisplayView.frame.height/2
        
        onTimeProgressInPercentLabel.text = "\(onTimePerformanceInPercent)%"
        delayProgressInPercentLabel.text = "\(delayedPerformanceInPercent)%"
        cancelledProgressInPercentLabel.text = "\(cancelledPerformanceInPercent)%"

        self.onTimePerformanceSubView.frame = CGRect(x: 0, y: 0, width: 0, height: self.onTimeProgressDisplayView.frame.height)
        self.delayedPerformanceSubView.frame = CGRect(x: 0, y: 0, width: 0, height: self.delayProgressDisplayView.frame.height)
        self.cancelledPerformanceSubView.frame = CGRect(x: 0, y: 0, width: 0, height: self.cancelledProgressDisplayView.frame.height)

        UIView.animate(withDuration: 0.4,delay: 0, animations: {
            self.onTimePerformanceSubView.frame.size.width = CGFloat(self.onTimePerformanceInPercent * Int(UIScreen.main.bounds.width/100))
            self.onTimePerformanceSubView.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 204.0/255.0, blue: 153.0/255.0, alpha: 1.0)
            self.onTimeProgressDisplayView.addSubview(self.onTimePerformanceSubView)
            
            self.delayedPerformanceSubView.frame.size.width = CGFloat(self.delayedPerformanceInPercent * Int(UIScreen.main.bounds.width/100))
            self.delayedPerformanceSubView.backgroundColor = UIColor(displayP3Red: 248.0/255.0, green: 185.0/255.0, blue: 8.0/255.0, alpha: 1.0)
            self.delayProgressDisplayView.addSubview(self.delayedPerformanceSubView)
            
            self.cancelledPerformanceSubView.frame.size.width = CGFloat(self.cancelledPerformanceInPercent * Int(UIScreen.main.bounds.width/100))
            self.cancelledPerformanceSubView.backgroundColor = UIColor(displayP3Red: 255.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
            self.cancelledProgressDisplayView.addSubview(self.cancelledPerformanceSubView)
        })
    
            
        if averageDelay != ""{
            let displayText = "Delayed (Avg. Delay = \(averageDelay) mins)"
            let range = (displayText as NSString).range(of: "(Avg. Delay = \(averageDelay) mins)")

            let averageDelayLbl = NSMutableAttributedString(string: displayText)
            averageDelayLbl.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SourceSansPro-Regular", size: 14.0)! , range: range)
            
            delayedTitleLbl.attributedText = averageDelayLbl
        }else{
            delayedTitleLbl.text = "Delay"
        }
        
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.headIndent = 13
        style.paragraphSpacingBefore = 16

        var displayText = ""
        if  onTimePerformanceInPercent + delayedPerformanceInPercent + cancelledPerformanceInPercent != 100{
            displayText = "\u{2022}   Based on \(observationCount) observations\n\u{2022}   Due to rounding approximations, values may not add up exactly to 100%"
        }else{
            displayText = "\u{2022}   Based on \(observationCount) observations."
        }

        
        let title = NSMutableAttributedString(string: displayText, attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
                
        noteLabel.attributedText = title
    }
    
    //MARK:- Guesture
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch: UITouch? = touches.first
        if touch?.view == backgroundDisplayView {
            self.view.removeFromSuperview()
        }
    }

    //MARK:- Button Action

    @IBAction func closeButtonClicked(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
}
