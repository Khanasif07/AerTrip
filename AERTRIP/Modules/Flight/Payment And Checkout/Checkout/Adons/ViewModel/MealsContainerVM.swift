//
//  MealsContainerVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class MealsContainerVM {
    
    var currentIndex = 0
    var allChildVCs = [SelectMealsdVC]()
    
    
    func addPassengerToMeal(forAdon: AddonsDataCustom, vcIndex: Int, currentFlightKey: String, mealIndex: Int, contacts: [ATContact]) {
        
        let dataStore = AddonsDataStore.shared
        var flightsToModify :[AddonsFlight] = []
        let currentLegId = dataStore.flightsWithData[vcIndex].legId
        let flightsWithSameLegId = dataStore.flightsWithData.filter { $0.legId == currentLegId }
        let flightsWithCurrentAddon = flightsWithSameLegId.filter { $0.meal.addonsArray.contains { $0.adonsName == forAdon.adonsName } }
        
        if self.checkIfReadOnlyValuesAreDifferent(flights: flightsWithCurrentAddon, forAdon: forAdon) {
            flightsToModify = flightsWithCurrentAddon
            flightsToModify.forEach { (flight) in
                
                if let calculatedVcIndex = self.allChildVCs.firstIndex(where: { (vc) -> Bool in
                    vc.selectMealsVM.getCurrentFlightKey() == flight.flightId
                }) {
                    allChildVCs[calculatedVcIndex].selectMealsVM.addonsDetails.addonsArray.enumerated().forEach { (mealInd,bag) in
                        contacts.forEach { (contact) in
                            if let contIndex = allChildVCs[calculatedVcIndex].selectMealsVM.addonsDetails.addonsArray[mealInd].mealsSelectedFor.lastIndex(where: { (cont) -> Bool in
                                return cont.id == contact.id
                            }){
                                allChildVCs[calculatedVcIndex].selectMealsVM.addonsDetails.addonsArray[mealInd].mealsSelectedFor.remove(at: contIndex)
                                allChildVCs[calculatedVcIndex].selectMealsVM.addonsDetails.addonsArray[mealInd].autoSelectedFor = ""
                            }
                        }
                    }
                    
                    let otherFlightsExceptCurrentOne = flightsToModify.filter { $0.flightId != flight.flightId  }
                    allChildVCs[calculatedVcIndex].selectMealsVM.updateContactInMeal(mealIndex: mealIndex, contacts: contacts, autoSelectedFor: otherFlightsExceptCurrentOne.map { $0.flightId })
                    allChildVCs[calculatedVcIndex].reloadData()
                }
            }
        } else {
            
            allChildVCs[vcIndex].selectMealsVM.addonsDetails.addonsArray.enumerated().forEach { (mealInd,meal) in
                
                contacts.forEach { (contact) in
                    if let contIndex = allChildVCs[vcIndex].selectMealsVM.addonsDetails.addonsArray[mealInd].mealsSelectedFor.lastIndex(where: { (cont) -> Bool in
                        return cont.id == contact.id
                    }){
                        allChildVCs[vcIndex].selectMealsVM.addonsDetails.addonsArray[mealInd].mealsSelectedFor.remove(at: contIndex)
                        allChildVCs[vcIndex].selectMealsVM.addonsDetails.addonsArray[mealInd].autoSelectedFor = ""

                    }
                }
                
            }
            allChildVCs[vcIndex].selectMealsVM.updateContactInMeal(mealIndex: mealIndex, contacts: contacts, autoSelectedFor: [])
            allChildVCs[vcIndex].reloadData()
        }
        
        
    }
    
    
    func checkIfReadOnlyValuesAreDifferent(flights : [AddonsFlight], forAdon: AddonsDataCustom) -> Bool {
        
        var readOnlyValues : [Int] = []
        
        flights.forEach { (flight) in
            let addon = flight.meal.addonsArray.filter { $0.adonsName ==  forAdon.adonsName }
            guard let firstAddon = addon.first else { return }
            readOnlyValues.append(firstAddon.ssrName?.isReadOnly ?? 0)
        }
        
        let filteredReadOnly = readOnlyValues.filter { $0 == 0 }
        
        return filteredReadOnly.count != readOnlyValues.count
        
    }
    
    
    func initializeFreeMealsToPassengers(){
        
        
        
    }
    
}
