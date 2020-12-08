//
//  Leg.swift
//  Aertrip
//
//  Created by  hrishikesh on 20/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


struct Leg

{
    let origin : String
    let destination : String

    var descriptionOneFiveThree : NSAttributedString {
    
    
        let sourcePro14 = AppFonts.SemiBold.withSize(14)
        let attributes =   [NSAttributedString.Key.font :AppFonts.SemiBold.withSize(14) , NSAttributedString.Key.foregroundColor : UIColor.ONE_FIVE_THREE_COLOR]
    
    let combinedString = NSMutableAttributedString(string: origin + " ", attributes: attributes)
    let destinationString = NSAttributedString(string: " " + destination, attributes: attributes)
    
    let textAttachment = NSTextAttachment()
    if let image = UIImage(named: "oneway")?.withAlpha(0.4) {
        textAttachment.bounds = CGRect(x: 0.0, y: Double((sourcePro14.capHeight - image.size.height)/2.0), width: Double(image.size.width), height: Double(image.size.height))
        textAttachment.image = image
        
        let join = NSAttributedString(attachment: textAttachment)
        
        combinedString.append(join)
        
    }
    combinedString.append(destinationString)
    
    return combinedString
    }
    

    
    func getTitle(isCurrentlySelected : Bool , isFilterApplied: Bool) -> NSMutableAttributedString {
        
        let dot = " \u{2022}"
        let font = AppFonts.SemiBold.withSize(14)
        let aertripColorAttributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : UIColor.AertripColor]
        let whiteColorAttributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : UIColor.white]
        let clearColorAttributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : UIColor.clear]

        let combinedString : NSMutableAttributedString
        let destinationString :  NSMutableAttributedString
         if isCurrentlySelected {
                combinedString = NSMutableAttributedString(string: origin + " ", attributes: whiteColorAttributes)
                destinationString = NSMutableAttributedString(string: " " + destination , attributes: whiteColorAttributes)
         }
         else {
          combinedString = NSMutableAttributedString(string: origin + " ", attributes: aertripColorAttributes)
          destinationString = NSMutableAttributedString(string: " " + destination , attributes: aertripColorAttributes)
        }
       

        let imageName : String
        if isCurrentlySelected {
            imageName = "onewayWhite"
        }
        else {
            imageName = "onewayAertripColor"
        }
        
        if let image = UIImage(named: imageName) {
            let textAttachment = NSTextAttachment()
            textAttachment.bounds = CGRect(x: 0.0, y: 0.0 , width: 10, height: 10)
            textAttachment.image = image
            let join = NSAttributedString(attachment: textAttachment)
            combinedString.append(join)
        }
        
        
        let dotString : NSAttributedString
        if isCurrentlySelected {
            
            if isFilterApplied {
              dotString = NSMutableAttributedString(string: dot , attributes: whiteColorAttributes)
            }
            else {
                dotString = NSMutableAttributedString(string: dot , attributes: clearColorAttributes)
            }
        }
        else {
            if isFilterApplied {
                dotString = NSMutableAttributedString(string: dot , attributes: aertripColorAttributes)
            }
            else {
                dotString = NSMutableAttributedString(string: dot , attributes: clearColorAttributes)
            }
        }
        
        combinedString.append(destinationString)
        combinedString.append(dotString)
        return combinedString
    }
    
}
