//
//  IntReturnAndMCSortVM.swift
//  AERTRIP
//
//  Created by Rishabh on 16/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class IntReturnAndMCSortVM {
    var  priceHighToLow : Bool = false
    var  durationLongestFirst : Bool = false
    weak var delegate : SortFilterDelegate?
    var selectedSorting = Sort.Smart
    var airportsArr = [AirportLegFilter]()
    
    var flightSearchParameters = JSONDictionary()
    
    var curSelectedIndex: Int?
    var earliestFirstAtDepartArrive: [Int: Bool] = [:]
    
    func getAttributedStringFor(index : Int) ->NSAttributedString? {
        
        if  let sortFilter = Sort(rawValue: index) {
            
            var attributes : [NSAttributedString.Key : Any]
            if ( sortFilter == selectedSorting) {
                
                attributes = [NSAttributedString.Key.font : AppFonts.Regular.withSize(18) ,
                              NSAttributedString.Key.foregroundColor : UIColor.AertripColor]

            }
            else {
                attributes = [NSAttributedString.Key.font : AppFonts.Regular.withSize(18)]

            }
            
            let attributedString = NSMutableAttributedString(string: sortFilter.title, attributes: attributes)
            
            var substring = "  " + sortFilter.subTitle
            
            if index == 1  && priceHighToLow {
                substring = "  "  + "High to Low"
            }
            if index == 2 && durationLongestFirst {
                substring = "  " + "Longest first"
            }
            let substringAttributedString = NSAttributedString(string: substring, attributes: [NSAttributedString.Key.font : AppFonts.Regular.withSize(14), NSAttributedString.Key.foregroundColor : UIColor.ONE_FIVE_THREE_COLOR  ])
            attributedString.append(substringAttributedString)
         
            return attributedString
        }
        return nil
    }
    
    func getDepartArriveAttString(_ str: String,_ indexPath: IndexPath) -> NSAttributedString {
        var attributes : [NSAttributedString.Key : Any]
        if (curSelectedIndex == indexPath.row) {
            
            attributes = [NSAttributedString.Key.font : AppFonts.Regular.withSize(18) ,
                          NSAttributedString.Key.foregroundColor : UIColor.AertripColor]

        }
        else {
            attributes = [NSAttributedString.Key.font : AppFonts.Regular.withSize(18)]

        }
        let attributedString = NSMutableAttributedString(string: str, attributes: attributes)
        
        var substring = "  " + "Earliest First"
        
        if earliestFirstAtDepartArrive[indexPath.row] == false {
            substring = "  " + "Latest First"
        }
        
        let substringAttributedString = NSAttributedString(string: substring, attributes: [NSAttributedString.Key.font : AppFonts.Regular.withSize(14), NSAttributedString.Key.foregroundColor : UIColor.ONE_FIVE_THREE_COLOR  ])
           attributedString.append(substringAttributedString)
        
        return attributedString
    }
}
