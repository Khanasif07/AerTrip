//
//  Int+Extension.swift
//  AERTRIP
//
//  Created by Appinventiv on 06/07/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


extension Int {

    var commaSeprated : String {
        let largeNumber = self
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:largeNumber)) ?? ""
    }
    
}

