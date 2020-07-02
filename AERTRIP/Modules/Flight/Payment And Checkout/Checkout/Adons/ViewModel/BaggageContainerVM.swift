//
//  BagageContainerVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 08/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class BaggageContainerVM {

    var currentIndex = 0
    var allChildVCs = [SelectBaggageVC]()
    
    init() {
        
    }
 
    func clearAll() {
        
        for (index,item) in self.allChildVCs.enumerated() {
            let mealsArray = item.selectBaggageVM.getBaggage()
            mealsArray.enumerated().forEach { (addonIndex,_) in
                item.selectBaggageVM.updateContactInBaggage(baggageIndex: addonIndex, contacts: [], autoSelectedFor: [])
        AddonsDataStore.shared.flightsWithData[index].bags.addonsArray[addonIndex].bagageSelectedFor = []
          AddonsDataStore.shared.flightsWithData[index].bags.addonsArray[addonIndex].autoSelectedFor = ""
        }
             item.reloadData()
         }
        
    }
    
    func calculateTotalAmount() -> Int {
        
        var totalPrice = 0
          for item in self.allChildVCs {
              let mealsArray = item.selectBaggageVM.getBaggage()
              let selectedMeals = mealsArray.filter { !$0.bagageSelectedFor.isEmpty && $0.ssrName?.isReadOnly == 0 }
              selectedMeals.forEach { (meal) in
                  totalPrice += (meal.price * meal.bagageSelectedFor.count)
              }
          }
        
        return totalPrice
    }
    
    func updateBaggageToDataStore(){
       
        for (index,item) in self.allChildVCs.enumerated() {
            AddonsDataStore.shared.flightsWithData[index].bags = item.selectBaggageVM.addonsDetails
        }
           
    }
    
    func addPassengerToMeal(forAdon: AddonsDataCustom, vcIndex: Int, currentFlightKey: String, baggageIndex: Int, contacts: [ATContact]) {
        
        let dataStore = AddonsDataStore.shared
               var flightsToModify :[AddonsFlight] = []
               let currentLegId = dataStore.flightsWithData[vcIndex].legId
               let flightsWithSameLegId = dataStore.flightsWithData.filter { $0.legId == currentLegId }
               let flightsWithCurrentAddon = flightsWithSameLegId.filter { $0.bags.addonsArray.contains { $0.adonsName == forAdon.adonsName } }
        
        if self.checkIfReadOnlyValuesAreDifferent(flights: flightsWithCurrentAddon, forAdon: forAdon) {
            flightsToModify = flightsWithCurrentAddon
            flightsToModify.forEach { (flight) in
                    if let calculatedVcIndex = self.allChildVCs.firstIndex(where: { (vc) -> Bool in
                        vc.selectBaggageVM.getCurrentFlightKey() == flight.flightId
                    }) {
                        
                        
                        allChildVCs[calculatedVcIndex].selectBaggageVM.addonsDetails.addonsArray.enumerated().forEach { (baggageInd,bag) in
                        contacts.forEach { (contact) in
                            if let contIndex = allChildVCs[calculatedVcIndex].selectBaggageVM.addonsDetails.addonsArray[baggageInd].bagageSelectedFor.lastIndex(where: { (cont) -> Bool in
                                return cont.id == contact.id
                            }){
                                allChildVCs[calculatedVcIndex].selectBaggageVM.addonsDetails.addonsArray[baggageInd].bagageSelectedFor.remove(at: contIndex)
                                allChildVCs[calculatedVcIndex].selectBaggageVM.addonsDetails.addonsArray[baggageInd].autoSelectedFor = ""
                            }
                          }
                        }
                        
                        let otherFlightsExceptCurrentOne = flightsToModify.filter { $0.flightId != flight.flightId  }
                        allChildVCs[calculatedVcIndex].selectBaggageVM.updateContactInBaggage(baggageIndex: baggageIndex, contacts: contacts, autoSelectedFor: otherFlightsExceptCurrentOne.map { $0.flightId })
                            allChildVCs[calculatedVcIndex].reloadData()
                    }
                }
        } else {
            
            allChildVCs[vcIndex].selectBaggageVM.addonsDetails.addonsArray.enumerated().forEach { (baggageInd,bag) in
            contacts.forEach { (contact) in
                if let contIndex = allChildVCs[vcIndex].selectBaggageVM.addonsDetails.addonsArray[baggageInd].bagageSelectedFor.lastIndex(where: { (cont) -> Bool in
                    return cont.id == contact.id
                }){
                    allChildVCs[vcIndex].selectBaggageVM.addonsDetails.addonsArray[baggageInd].bagageSelectedFor.remove(at: contIndex)
                    allChildVCs[vcIndex].selectBaggageVM.addonsDetails.addonsArray[baggageInd].autoSelectedFor = ""
                }
              }
            }
            
            allChildVCs[vcIndex].selectBaggageVM.updateContactInBaggage(baggageIndex: baggageIndex, contacts: contacts, autoSelectedFor: [])
            allChildVCs[vcIndex].reloadData()
        }
        
    }
    
    
    func checkIfReadOnlyValuesAreDifferent(flights : [AddonsFlight], forAdon: AddonsDataCustom) -> Bool {
        
        var readOnlyValues : [Int] = []
        
        flights.forEach { (flight) in
            let addon = flight.bags.addonsArray.filter { $0.adonsName ==  forAdon.adonsName }
            guard let firstAddon = addon.first else { return }
            readOnlyValues.append(firstAddon.ssrName?.isReadOnly ?? 0)
        }
        
        let filteredReadOnly = readOnlyValues.filter { $0 == 0 }
        
        return filteredReadOnly.count != readOnlyValues.count
        
    }
    
    
}
