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
    
    var vcIndex : Int = 0
    var currentFlightKey : String = ""
    weak var delegate : SelectMealVmDelegate?
    

    init(){
        
    }
    
    init(vcIndex : Int, currentFlightKey : String){
        self.vcIndex = vcIndex
        self.currentFlightKey = currentFlightKey
    }
    
    
    func getMealsDataForCurrentFlight() -> [Addons] {
        guard let keyData = AddonsDataStore.shared.adons[self.currentFlightKey] else { return [] }
        return keyData.meal
    }
    
}
