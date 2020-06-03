//
//  SelectPassengersVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 29/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SelectPassengersVM {
    
    enum SetupFor {
        case seatSelection
        case others
    }

    var selectedIndex : [Int] = []
    var setupFor: SetupFor = .others
    
}
