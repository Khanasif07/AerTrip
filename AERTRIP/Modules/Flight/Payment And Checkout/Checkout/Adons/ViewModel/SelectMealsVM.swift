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
    
    private var vcIndex : Int = 0
    private var currentFlightKey : String = ""
    private var mealsArray : [Addons] = []
    weak var delegate : SelectMealVmDelegate?
    
    
    var addonsDetails = AddonsDetails()
    
    init(){
        
    }
    
    init(vcIndex : Int, currentFlightKey : String, mealsArray : [Addons], addonsDetails : AddonsDetails){
        self.vcIndex = vcIndex
        self.currentFlightKey = currentFlightKey
        self.mealsArray = mealsArray
        self.addonsDetails = addonsDetails
    }
    
    func getMeals() -> [AddonsDataCustom] {
        return addonsDetails.addonsArray
//        return mealsArray
    }
    
    func getVcIndex() -> Int {
        return vcIndex
    }
    
    func getCurrentFlightKey() -> String {
        return currentFlightKey
    }
    
//    func getMealsDataForCurrentFlight() -> [Addons] {
//        //guard let keyData = AddonsDataStore.shared.adons[self.currentFlightKey] else { return [] }
//        return mealsArray
//    }
 
    func updateContactInMeal(mealIndex: Int, contacts : [ATContact]){
        mealsArray[mealIndex].mealsSelectedFor = contacts
    }
    
}
