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
    
    var contactsComplition : (([ATContact]) -> Void) = {_ in ([])}
    
    var selectedContacts : [ATContact] = []
    
    var setupFor: SetupFor = .others
    var seatModel = SeatMapModel.SeatMapRow()
}
