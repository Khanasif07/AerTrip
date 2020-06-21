//
//  SelectOtherAdonsContainerVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 12/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class SelectOtherAdonsContainerVM {
    
    var currentIndex = 0
    var allChildVCs = [SelectOtherAdonsVC]()
    
    
    func addPassengerToMeal(forAdon: AddonsDataCustom, vcIndex: Int, currentFlightKey: String, othersIndex: Int, contacts: [ATContact]) {
                
        let dataStore = AddonsDataStore.shared
        var flightsToModify :[AddonsFlight] = []
        
        let currentLegId = dataStore.flightsWithData[vcIndex].legId
        
        let flightsWithSameLegId = dataStore.flightsWithData.filter { $0.legId == currentLegId }
        
        let flightsWithCurrentAddon = flightsWithSameLegId.filter { $0.special.addonsArray.contains { $0.adonsName == forAdon.adonsName } }
        
        if self.checkIfReadOnlyValuesAreDifferent(flights: flightsWithCurrentAddon, forAdon: forAdon) {
            flightsToModify = flightsWithCurrentAddon
       
            flightsToModify.forEach { (flight) in
                
                if let calculatedVcIndex = self.allChildVCs.firstIndex(where: { (vc) -> Bool in
                    vc.otherAdonsVm.getCurrentFlightKey() == flight.flightId
                }) {
                    
                    let otherFlightsExceptCurrentOne = flightsToModify.filter { $0.flightId != flight.flightId  }
                    
                    allChildVCs[calculatedVcIndex].otherAdonsVm.updateContactInOthers(OthersIndex: othersIndex, contacts: contacts, autoSelectedFor: otherFlightsExceptCurrentOne.map { $0.flightId })
                    allChildVCs[calculatedVcIndex].reloadData()
                }
                
            }

        }else{
            
            allChildVCs[vcIndex].otherAdonsVm.updateContactInOthers(OthersIndex: othersIndex, contacts: contacts, autoSelectedFor: [])
            allChildVCs[vcIndex].reloadData()
            
        }
        
    }
    
    
    func checkIfReadOnlyValuesAreDifferent(flights : [AddonsFlight], forAdon: AddonsDataCustom) -> Bool {
        
        var readOnlyValues : [Int] = []
        
        flights.forEach { (flight) in
            let addon = flight.special.addonsArray.filter { $0.adonsName ==  forAdon.adonsName }
            guard let firstAddon = addon.first else { return }
            readOnlyValues.append(firstAddon.ssrName?.isReadOnly ?? 0)
        }
        
        let filteredReadOnly = readOnlyValues.filter { $0 == 0 }
        
        return filteredReadOnly.count != readOnlyValues.count
        
    }
    
    
}
