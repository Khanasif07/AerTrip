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
    var selectedSeatData = SeatMapModel.SeatMapRow()
    var flightData = SeatMapModel.SeatMapFlight() {
        didSet {
            populateSeatDataArr()
        }
    }
    var initalPassengerForSeat: ATContact?
    var seatDataArr = [SeatMapModel.SeatMapRow]()
    
    private func populateSeatDataArr() {
        seatDataArr.removeAll()
        flightData.md.rows.forEach { (kev, val) in
            val.forEach { (key, seatData) in
                seatDataArr.append(seatData)
            }
        }
    }

    
    func resetFlightData(_ selectedPassenger: ATContact?) {
        flightData.md.rows.forEach { (rowKey, row) in
            var newRow = row
            newRow.forEach { (columnKey, column) in
                var newColumn = column
                if newColumn.columnData.ssrCode == selectedSeatData.columnData.ssrCode {
                    newColumn.columnData.passenger = selectedPassenger
                } else {
                    if newColumn.columnData.passenger?.id == selectedPassenger?.id {
                        newColumn.columnData.passenger = nil
                    }
                }
                newRow.updateValue(newColumn, forKey: columnKey)
            }
            flightData.md.rows.updateValue(newRow, forKey: rowKey)
        }
    }
}
