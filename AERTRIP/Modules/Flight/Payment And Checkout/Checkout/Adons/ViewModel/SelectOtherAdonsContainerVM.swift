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
    
    
    func getAllowedPassengerForParticularAdon(forAdon : AddonsDataCustom) -> [ATContact] {
         
        var allowedPassengers : [ATContact] = []

        guard let allPassengers = GuestDetailsVM.shared.guests.first else { return allowedPassengers }

         if forAdon.isAdult{
             allowedPassengers.append(contentsOf: allPassengers.filter { $0.passengerType == .Adult })
         }
         
         if forAdon.isChild{
             allowedPassengers.append(contentsOf: allPassengers.filter { $0.passengerType == .child })
         }
         
         if forAdon.isInfant{
             allowedPassengers.append(contentsOf: allPassengers.filter { $0.passengerType == .infant })
         }
        
        return allowedPassengers
     }
    
    func clearAll() {
        for (index,item) in self.allChildVCs.enumerated() {
            let othersArray = item.otherAdonsVm.getOthers()
                othersArray.enumerated().forEach { (addonIndex,_) in
                 item.otherAdonsVm.updateContactInOthers(OthersIndex: addonIndex, contacts: [], autoSelectedFor: [])
                 AddonsDataStore.shared.flightsWithData[index].special.addonsArray[addonIndex].othersSelectedFor = []
                }
                item.reloadData()
            }
    }
    
    func calculateTotalAmount() -> Int {
          var totalPrice = 0
          for item in self.allChildVCs {
              let mealsArray = item.otherAdonsVm.getOthers()
              let selectedMeals = mealsArray.filter { !$0.othersSelectedFor.isEmpty && $0.ssrName?.isReadOnly == 0 }
              selectedMeals.forEach { (meal) in
                  totalPrice += (meal.price * meal.othersSelectedFor.count)
              }
          }
        return totalPrice
    }
    
    func containsSpecialRequest() -> Bool {
        
        var containsSpecialRequest = false
        
        for item in self.allChildVCs {
            if !containsSpecialRequest {
                containsSpecialRequest = !item.otherAdonsVm.specialRequest.isEmpty
            }
        }
        return containsSpecialRequest
    }
    
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
        let sourceSansPro18 = UIFont(name: "SourceSansPro-Semibold", size: 18.0)!
        let iconImage = UIImage(named: name )!
        imageAttachment.image = iconImage
        
        let yCordinate  = roundf(Float(sourceSansPro18.capHeight - iconImage.size.height) / 2.0)
        imageAttachment.bounds = CGRect(x: CGFloat(0.0), y: CGFloat(yCordinate) , width: iconImage.size.width, height: iconImage.size.height )
        let imageString = NSAttributedString(attachment: imageAttachment)
        return imageString
    }
    
    
}
