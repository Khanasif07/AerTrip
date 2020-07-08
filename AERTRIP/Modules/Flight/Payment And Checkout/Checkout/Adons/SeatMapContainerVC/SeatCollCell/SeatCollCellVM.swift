//
//  SeatCollCellVM.swift
//  AERTRIP
//
//  Created by Rishabh on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class SeatCollCellVM {
    
    typealias amount = (minAmount: Int, maxAmount: Int)
    
    var seatData: SeatMapModel.SeatMapRow
    var flightFares: amount
    var setupFor: SeatMapContainerVM.SetupFor = .preSelection
    
    init() {
        seatData = SeatMapModel.SeatMapRow()
        flightFares = (0, 0)
        setupFor = .preSelection
    }
    
    init(_ seatData: SeatMapModel.SeatMapRow,_ flightFares: amount,_ setupFor: SeatMapContainerVM.SetupFor) {
        self.seatData = seatData
        self.flightFares = flightFares
        self.setupFor = setupFor
    }
}
