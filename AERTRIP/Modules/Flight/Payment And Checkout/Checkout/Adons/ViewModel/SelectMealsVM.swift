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

    
    init(){
        
    }
    
    init(vcIndex : Int, currentFlightKey : String, addonsDetails : AddonsDetails){
        self.vcIndex = vcIndex
        self.currentFlightKey = currentFlightKey
        self.addonsDetails = addonsDetails
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
     
    func updateContactInMeal(mealIndex: Int, contacts : [ATContact]){
        addonsDetails.addonsArray[mealIndex].mealsSelectedFor = contacts
    }
    
}
