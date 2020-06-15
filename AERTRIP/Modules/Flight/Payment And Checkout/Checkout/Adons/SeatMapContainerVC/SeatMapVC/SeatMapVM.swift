//
//  SeatMapVM.swift
//  AERTRIP
//
//  Created by Rishabh on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class SeatMapVM {
    
    enum DeckType {
        case main
        case upper
    }
    
    typealias amount = (minAmount: Int, maxAmount: Int)
    
    var flightData = SeatMapModel.SeatMapFlight() {
        didSet {
            getFares()
        }
    }
        
//    var seatLayout: SeatCollCellVM.PlaneSeatsLayout = .ten
    var curSelectedDeck: DeckType = .main
    var hasUpperDeck = false
    var flightFares: amount = (0, 0)
    
    private func getFares() {
        var minAmount = Int.max, maxAmount = 0
        flightData.md.rows.forEach { (_, rowData) in
            rowData.forEach { (_, column) in
                if column.columnData.amount > maxAmount {
                    maxAmount = column.columnData.amount
                }
                if column.columnData.amount < minAmount && column.columnData.amount > 0 {
                    minAmount = column.columnData.amount
                }
            }
        }
        flightFares = (minAmount, maxAmount)
    }
    
    var deckRowsCount: Int {
        switch curSelectedDeck {
        case .upper:    return flightData.ud.rowsArr.count
        case .main:     return flightData.md.rowsArr.count
        }
    }
    
    var deckColumnsCount: Int {
        switch curSelectedDeck {
        case .upper:    return flightData.ud.columns.count
        case .main:     return flightData.md.columns.count
        }
    }
    
    var deckData: SeatMapModel.DeckData {
        switch curSelectedDeck {
        case .upper:    return flightData.ud
        case .main:     return flightData.md
        }
    }
}
