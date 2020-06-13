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
    var seatModel = SeatMapModel.SeatMapRow()
    var initalPassengerForSeat: ATContact?
    
    
    func getAllowedPassengerForParticularAdon() {
        
        guard let allPassengers = GuestDetailsVM.shared.guests.first else { return }
                
        if adonsData.isAdult{
            allowedPassengers.append(contentsOf: allPassengers.filter { $0.passengerType == .Adult })
        }
        
        if adonsData.isChild{
         allowedPassengers.append(contentsOf: allPassengers.filter { $0.passengerType == .child })
        }
        
        if adonsData.isChild{
            allowedPassengers.append(contentsOf: allPassengers.filter { $0.passengerType == .infant })
        }
    }
    
}
