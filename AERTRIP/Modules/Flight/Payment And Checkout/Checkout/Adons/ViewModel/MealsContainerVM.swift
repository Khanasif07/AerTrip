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
    var allTabsStr : [NSAttributedString] = []
    

    
    func clearAll() {
        
        for (index,item) in self.allChildVCs.enumerated() {
            
            let mealsArray = item.selectMealsVM.getMeals()
            mealsArray.enumerated().forEach { (addonIndex,_) in
                item.selectMealsVM.updateContactInMeal(mealIndex: addonIndex, contacts: [], autoSelectedFor: [])
                AddonsDataStore.shared.flightsWithDataForMeals[index].meal.addonsArray[addonIndex].mealsSelectedFor = []
                item.selectMealsVM.initializeFreeMealsToPassengers()
            }
            item.reloadData()
            
        }
        
    }
    
    func updateMealsToDataStore() {
        for (index,item) in self.allChildVCs.enumerated() {
            AddonsDataStore.shared.flightsWithDataForMeals[index].meal = item.selectMealsVM.addonsDetails
        }
    }
    
    
    func calculateTotalAmount() -> Int {
        
        var totalPrice = 0
        
        for item in self.allChildVCs {
            let mealsArray = item.selectMealsVM.getMeals()
            let selectedMeals = mealsArray.filter { !$0.mealsSelectedFor.isEmpty && $0.ssrName?.isReadOnly == 0 }
            selectedMeals.forEach { (meal) in
                totalPrice += (meal.price * meal.mealsSelectedFor.count)
            }
        }
        return totalPrice
    }
    
    
    func addPassengerToMeal(forAdon: AddonsDataCustom, vcIndex: Int, currentFlightKey: String, mealIndex: Int, contacts: [ATContact]) {
        
        let dataStore = AddonsDataStore.shared
        var flightsToModify :[AddonsFlight] = []
        let currentLegId = dataStore.flightsWithDataForMeals[vcIndex].legId
        let flightsWithSameLegId = dataStore.flightsWithDataForMeals.filter { $0.legId == currentLegId }
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
    
    
    func isAnyThingSelected() -> Bool {
        
        var isAnyThingSelected = false
        
        allChildVCs.forEach { (child) in
            
            child.selectMealsVM.addonsDetails.addonsArray.enumerated().forEach { (mealId, meal) in
                if !isAnyThingSelected {
                    isAnyThingSelected = !meal.mealsSelectedFor.isEmpty
                }
            }
        }
        
        return isAnyThingSelected
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
