//
//  RequestReschedulingVM.swift
//  AERTRIP
//
//  Created by Admin on 03/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class RequestReschedulingVM {
    
    enum TableViewCells {
        case flightDetailsCell , selectDateCell , preferredFlightNoCell, emptyCell , customerExecutiveCell , totalNetRefundCell
    }
    
    var sectionData: [[TableViewCells]] = []
    
    func getSectionData() {
        self.sectionData.append([.flightDetailsCell , .selectDateCell, .preferredFlightNoCell])
        self.sectionData.append([.emptyCell])
        self.sectionData.append([.flightDetailsCell , .selectDateCell, .preferredFlightNoCell])
        self.sectionData.append([.customerExecutiveCell , .totalNetRefundCell])
    }
}
