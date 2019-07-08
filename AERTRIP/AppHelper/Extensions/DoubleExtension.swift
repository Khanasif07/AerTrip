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
}
