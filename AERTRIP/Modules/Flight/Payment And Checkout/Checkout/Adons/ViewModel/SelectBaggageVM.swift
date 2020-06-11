//
//  SelectBaggageVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 08/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol SelectBaggageVmDelegate : class {
    func contactAddedToBagage()
}

class SelectBaggageVM {
    
        var addonsDetails = AddonsDetails()
        var vcIndex : Int = 0
        var currentFlightKey : String = ""
        weak var delegate : SelectBaggageVmDelegate?
        
        init(){
            
        }
    
    
    init(vcIndex : Int, currentFlightKey : String, addonsDetails : AddonsDetails){
        self.vcIndex = vcIndex
        self.currentFlightKey = currentFlightKey
        self.addonsDetails = addonsDetails
    }
    
    func getBaggage() -> [AddonsDataCustom] {
        return addonsDetails.addonsArray
    }
    
    func getVcIndex() -> Int {
        return vcIndex
    }
    
    func getCurrentFlightKey() -> String {
        return currentFlightKey
    }
     
    func updateContactInBaggage(mealIndex: Int, contacts : [ATContact]){
        addonsDetails.addonsArray[mealIndex].bagageSelectedFor = contacts
    }
    
    }
