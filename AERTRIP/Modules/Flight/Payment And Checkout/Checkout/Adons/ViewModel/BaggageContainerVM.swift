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
 
    func getAllowedPassengerForParticularAdon(forAdon : AddonsDataCustom) -> [ATContact] {
         
        var allowedPassengers : [ATContact] = []

        guard let allPassengers = GuestDetailsVM.shared.guests.first else { return allowedPassengers }

         
         if forAdon.isAdult{
             allowedPassengers.append(contentsOf: allPassengers.filter { $0.passengerType == .Adult })
         }
         
         if forAdon.isChild{
             allowedPassengers.append(contentsOf: allPassengers.filter { $0.passengerType == .Child })
         }
         
         if forAdon.isInfant{
             allowedPassengers.append(contentsOf: allPassengers.filter { $0.passengerType == .Infant })
         }
        
        return allowedPassengers
     }
    
    func clearAll() {
        
        for (index,item) in self.allChildVCs.enumerated() {
            let mealsArray = item.selectBaggageVM.getBaggage()
            mealsArray.enumerated().forEach { (addonIndex,_) in
                item.selectBaggageVM.updateContactInBaggage(baggageIndex: addonIndex, contacts: [], autoSelectedFor: [])
        AddonsDataStore.shared.flightsWithDataForBaggage[index].bags.addonsArray[addonIndex].bagageSelectedFor = []
          AddonsDataStore.shared.flightsWithDataForBaggage[index].bags.addonsArray[addonIndex].autoSelectedFor = ""
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
                totalPrice += (meal.price.toInt * meal.bagageSelectedFor.count)
              }
          }
        
        return totalPrice
    }
    
    func isAnyThingSelected() -> Bool {
        
        var isAnyThingSelected = false
        
        allChildVCs.forEach { (child) in

            child.selectBaggageVM.addonsDetails.addonsArray.enumerated().forEach { (bagId, bag) in
                if !isAnyThingSelected {
                    isAnyThingSelected = !bag.bagageSelectedFor.isEmpty
                }
            }
        }
        
        return isAnyThingSelected
    }
    
    func updateBaggageToDataStore(){
       
        for (index,item) in self.allChildVCs.enumerated() {
            AddonsDataStore.shared.flightsWithDataForBaggage[index].bags = item.selectBaggageVM.addonsDetails
            
            let flightAtINdex = AddonsDataStore.shared.allFlights.filter { $0.ffk == AddonsDataStore.shared.flightsWithDataForBaggage[index].flightId }
            
            if let firstFlight = flightAtINdex.first {
                
                item.selectBaggageVM.addonsDetails.addonsArray.forEach { (addon) in
                   
                    if !addon.bagageSelectedFor.isEmpty {
                      
                        FirebaseEventLogs.shared.logAddons(with: FirebaseEventLogs.EventsTypeName.addBaggageAddons, addonName: addon.adonsName, flightTitle: "\(firstFlight.fr) - \(firstFlight.to)", fk: AddonsDataStore.shared.flightsWithDataForBaggage[index].flightId, addonQty: addon.bagageSelectedFor.count)
                        
                        FirebaseEventLogs.shared.logAddons(with: FirebaseEventLogs.EventsTypeName.addBaggageAddons, addonName: addon.adonsName, fk: AddonsDataStore.shared.flightsWithDataForBaggage[index].flightId, addonQty: addon.bagageSelectedFor.count)
                    }
                }
            }
            

        }
    }
    
    func addPassengerToMeal(forAdon: AddonsDataCustom, vcIndex: Int, currentFlightKey: String, baggageIndex: Int, contacts: [ATContact]) {
        
        let dataStore = AddonsDataStore.shared
               var flightsToModify :[AddonsFlight] = []
               let currentLegId = dataStore.flightsWithDataForBaggage[vcIndex].legId
               let flightsWithSameLegId = dataStore.flightsWithDataForBaggage.filter { $0.legId == currentLegId }
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
    
     func createAttHeaderTitle(_ origin: String,_ destination: String) -> NSAttributedString {
        let fullString = NSMutableAttributedString(string: origin + "" )
        let desinationAtrributedString = NSAttributedString(string: "" + destination)
        let imageString = getStringFromImage(name : "oneway")
        fullString.append(imageString)
        fullString.append(desinationAtrributedString)
        return fullString
    }
    
    private func getStringFromImage(name : String) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
//        let sourceSansPro18 = UIFont(name: "SourceSansPro-Semibold", size: 18.0)!
        let sourceSansPro18 = AppFonts.SemiBold.withSize(18)
        let iconImage = UIImage(named: name )!
        imageAttachment.image = iconImage
        let yCordinate  = roundf(Float(sourceSansPro18.capHeight - iconImage.size.height) / 2.0)
        imageAttachment.bounds = CGRect(x: CGFloat(0.0), y: CGFloat(yCordinate) , width: iconImage.size.width, height: iconImage.size.height )
        let imageString = NSAttributedString(attachment: imageAttachment)
        return imageString
    }
    
    
}
