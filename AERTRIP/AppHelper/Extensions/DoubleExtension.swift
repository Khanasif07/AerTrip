//
//  DoubleExtension.swift
//  AERTRIP
//
//  Created by Admin on 10/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension Double {
    func asString(units: NSCalendar.Unit, style: DateComponentsFormatter.UnitsStyle) -> String {
        ///****************************///
        /* units:
            [.hour, .minute, .second, .nanosecond]
        */
        
        /*  style:
            10000.asString(style: .positional)  // 2:46:40
            10000.asString(style: .abbreviated) // 2h 46m 40s
            10000.asString(style: .short)       // 2 hr, 46 min, 40 sec
            10000.asString(style: .full)        // 2 hours, 46 minutes, 40 seconds
            10000.asString(style: .spellOut)    // two hours, forty-six minutes, forty seconds
            10000.asString(style: .brief)       // 2hr 46min 40sec
        */
        ///****************************///
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = style
        guard let formattedString = formatter.string(from: self) else { return "" }
        return formattedString
    }
    
    func formatedCount() ->String{
        var thousandNum = self/1000
        var millionNum = self/1000000
        if self >= 1000 && self < 1000000{
            if(floor(thousandNum) == thousandNum){
                return("\(Int(thousandNum))k")
            }
            return("\(thousandNum.roundToPlaces(places: 1))k")
        }
        if self >= 1000000{
            if(floor(millionNum) == millionNum){
                return("\(Int(thousandNum))k")
            }
            return ("\(millionNum.roundToPlaces(places: 1))M")
        }
        else{
            if(floor(self) == self){
                return ("\(Int(self))")
            }
            return ("\(self)")
        }
                
    }
    
    mutating func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return  (self * divisor).rounded() / divisor
    }
    var removeZeroAfterDecimal: String{
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }

    var numberAfterDecimal:String{
        let powerOfTen:Double = pow(10.0, 2.0)
        let targetedDecimalPlaces:Int = Int(self * powerOfTen)%Int(powerOfTen)
        return "\(targetedDecimalPlaces)"
    }
    
}
