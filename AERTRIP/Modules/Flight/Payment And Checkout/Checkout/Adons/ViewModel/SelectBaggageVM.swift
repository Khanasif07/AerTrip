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
    
        var vcIndex : Int = 0
        var currentFlightKey : String = ""
        weak var delegate : SelectBaggageVmDelegate?
        
        init(){
            
        }
        
        init(vcIndex : Int, currentFlightKey : String){
            self.vcIndex = vcIndex
            self.currentFlightKey = currentFlightKey
        }
        
        func getBaggageDataForCurrentFlight() -> [Addons] {
            guard let keyData = AddonsDataStore.shared.adons[self.currentFlightKey] else { return [] }
            return keyData.baggage
        }
        
    }
