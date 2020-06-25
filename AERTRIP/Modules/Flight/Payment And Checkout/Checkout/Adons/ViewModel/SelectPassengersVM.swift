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
        case meals
        case baggage
    }
    
    var contactsComplition : (([ATContact]) -> Void) = {_ in ([])}
    
    var allowedPassengers : [ATContact] = []
    var selectedContacts : [ATContact] = []
    var adonsData = AddonsDataCustom()
    var flightKys : [String] = []
    
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
        flightData.ud.rows.forEach { (kev, val) in
            val.forEach { (key, seatData) in
                seatDataArr.append(seatData)
            }
        }
    }

    
    func resetFlightData(_ selectedPassenger: ATContact?) {
        resetFlightDataFor(&flightData.md, selectedPassenger)
        resetFlightDataFor(&flightData.ud, selectedPassenger)
    }
    
    private func resetFlightDataFor(_ deckData: inout SeatMapModel.DeckData, _ selectedPassenger: ATContact?) {
        deckData.rows.forEach { (rowKey, row) in
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
            deckData.rows.updateValue(newRow, forKey: rowKey)
        }
    }

    
    func getAllowedPassengerForParticularAdon() {
        
        guard let allPassengers = GuestDetailsVM.shared.guests.first else { return }
        
        if setupFor == .seatSelection {
            allowedPassengers = allPassengers.filter { $0.passengerType != .infant }
            return
        }
        
        if adonsData.isAdult{
            allowedPassengers.append(contentsOf: allPassengers.filter { $0.passengerType == .Adult })
        }
        
        if adonsData.isChild{
            allowedPassengers.append(contentsOf: allPassengers.filter { $0.passengerType == .child })
        }
        
        if adonsData.isInfant{
            allowedPassengers.append(contentsOf: allPassengers.filter { $0.passengerType == .infant })
        }
    }
}
