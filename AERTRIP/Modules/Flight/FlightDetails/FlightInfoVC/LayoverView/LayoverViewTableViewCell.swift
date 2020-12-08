//
//  LayoverViewTableViewCell.swift
//  Aertrip
//
//  Created by Monika Sonawane on 17/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class LayoverViewTableViewCell: UITableViewCell
{
    @IBOutlet weak var layoverView: UIView!
    @IBOutlet weak var overNightLayoverImg: UIImageView!
    @IBOutlet weak var layoverLabel: UILabel!
    
    var displayImgName = ""
    var isArrivalAirportChange = false
    var isArrivalTerminalChange = false
    var displayText = ""
    var llo = -1
    var slo = -1
    var ovgtlo = -1
    var layoverTime = ""
    var layoverCityName = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layoverView.layer.borderWidth = 0.5
        layoverView.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        layoverView.layer.cornerRadius = layoverView.frame.height/2
    }
    
    
    func getLayoverString()->NSMutableAttributedString
    {
        if layoverCityName == "" || layoverCityName == " "{
            displayText = "Layover  • "
            displayImgName = ""
        }else{
            if isArrivalAirportChange == true{
                displayText = "Change Airport in \(layoverCityName)  • "
                displayImgName = "redchangeAirport"
            }else if isArrivalTerminalChange == true{
                displayText = "Change Terminal in \(layoverCityName)  • "
                displayImgName = "changeOfTerminal"
            }else if ovgtlo == 1{
                displayText = "Overnight layover in \(layoverCityName)  • "
                displayImgName = "overnight"
            }else {
                displayText = "Layover in \(layoverCityName)  • "
                displayImgName = ""
            }
        }
        
        displayText = displayText + " " + layoverTime
        let completeText = NSMutableAttributedString(string: "")
        
        let imageAttachment =  NSTextAttachment()
        if displayImgName != ""{
            imageAttachment.image = UIImage(named:displayImgName)
            let imageOffsetY:CGFloat = -4.0;
            imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 16, height: 16)
            let attachmentString = NSAttributedString(attachment: imageAttachment)
            completeText.append(attachmentString)
        }
        let textAfterIcon = NSMutableAttributedString(string: displayText, attributes: [.font: AppFonts.Regular.withSize(14)])
        
        if llo == 1 || slo == 1{
            if isArrivalAirportChange == true{
                let range1 = (displayText as NSString).range(of: displayText)
                
                textAfterIcon.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range1)
                textAfterIcon.addAttribute(NSAttributedString.Key.font, value: AppFonts.SemiBold.withSize(14) , range: (displayText as NSString).range(of: layoverTime))
            }else{
                let range1 = (displayText as NSString).range(of: layoverTime)
                
                textAfterIcon.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range1)
                textAfterIcon.addAttribute(NSAttributedString.Key.font, value: AppFonts.SemiBold.withSize(14), range: range1)
            }
        }else if isArrivalAirportChange == true{
            let range1 = (displayText as NSString).range(of: displayText)
            
            textAfterIcon.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range1)
            textAfterIcon.addAttribute(NSAttributedString.Key.font, value: AppFonts.SemiBold.withSize(14), range: (displayText as NSString).range(of: layoverTime))
        }else{
            let range1 = (displayText as NSString).range(of: layoverTime)
            
            textAfterIcon.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range1)
            textAfterIcon.addAttribute(NSAttributedString.Key.font, value: AppFonts.SemiBold.withSize(14), range: range1)
        }
        
        completeText.append(NSMutableAttributedString(string: "  "))
        completeText.append(textAfterIcon)
        layoverLabel.textAlignment = .center;
        return completeText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
