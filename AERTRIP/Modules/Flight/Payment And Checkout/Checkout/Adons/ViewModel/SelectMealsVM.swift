//
//  SelectMealsVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol SelectMealVmDelegate : class {
    func contactAddedToMeal()
}

class SelectMealsVM {
    
    var addonsDetails = AddonsDetails()
    private var vcIndex : Int = 0
    private var currentFlightKey : String = ""
    weak var delegate : SelectMealVmDelegate?
    var freeMeal : Bool = false
    
    init(){
        
    }
    
    init(vcIndex : Int, currentFlightKey : String, addonsDetails : AddonsDetails, freeMeal : Bool){
        self.vcIndex = vcIndex
        self.currentFlightKey = currentFlightKey
        self.addonsDetails = addonsDetails
        self.freeMeal = freeMeal
//        self.freeMeal = true
//        initializeFreeMealsToPassengers()
    }
    
    func getMeals() -> [AddonsDataCustom] {
        return addonsDetails.addonsArray
    }
    
    func getVcIndex() -> Int {
        return vcIndex
    }
    
    func getCurrentFlightKey() -> String {
        return currentFlightKey
    }
     

    func updateContactInMeal(mealIndex: Int, contacts : [ATContact], autoSelectedFor: [String]){
          addonsDetails.addonsArray[mealIndex].mealsSelectedFor = contacts
          
          var autoSelectedForString = "Auto Selected for "
          var flightName : [String] = []
          
          if autoSelectedFor.isEmpty {
                   addonsDetails.addonsArray[mealIndex].autoSelectedFor = ""
                   return }
          
          autoSelectedFor.forEach { (flightId) in
                let flightAtINdex = AddonsDataStore.shared.allFlights.filter { $0.ffk == flightId }
                guard let firstFlight = flightAtINdex.first else { return }
                flightName.append("\(firstFlight.fr) → \(firstFlight.to)")
            }
            
               if flightName.count == 1 {
                    autoSelectedForString += flightName.first ?? ""
                }else if flightName.count == 2 {
                    autoSelectedForString += flightName.joined(separator: ",").replacingLastOccurrenceOfString(" ,", with: " and ")
                }else{
                   autoSelectedForString += flightName.joined(separator: ",").replacingLastOccurrenceOfString(",", with: " and ")
                }
                
                if contacts.isEmpty {
                    addonsDetails.addonsArray[mealIndex].autoSelectedFor = ""
                }else{
                    addonsDetails.addonsArray[mealIndex].autoSelectedFor = autoSelectedForString
        }
      }
    
    
    
    func initializeFreeMealsToPassengers(){
       
        if !freeMeal { return }
        
        var mealsSelectedFor : [ATContact] = []

        if let firstMeal = addonsDetails.addonsArray.firstIndex(where: { (meal) -> Bool in
            return meal.price == 0
        }){
            guard let allPassengers = GuestDetailsVM.shared.guests.first else { return }
            
            allPassengers.forEach { (contact) in
                
                if contact.passengerType == .Adult && addonsDetails.addonsArray[firstMeal].isAdult {
                    mealsSelectedFor.append(contact)
                }
                
                if contact.passengerType == .Child && addonsDetails.addonsArray[firstMeal].isChild {
                    mealsSelectedFor.append(contact)
                }
                
                if contact.passengerType == .Infant && addonsDetails.addonsArray[firstMeal].isInfant {
                    mealsSelectedFor.append(contact)
                }
            }
            addonsDetails.addonsArray[firstMeal].mealsSelectedFor = mealsSelectedFor
            AddonsDataStore.shared.flightsWithDataForMeals[vcIndex].meal.addonsArray[firstMeal].mealsSelectedFor = mealsSelectedFor
        }
    }
    
}
