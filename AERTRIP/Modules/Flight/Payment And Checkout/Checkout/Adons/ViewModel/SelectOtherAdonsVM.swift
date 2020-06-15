//
//  SelectOtherAdonsVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 27/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SelectOtherAdonsVM  {

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
    
    func getOthers() -> [AddonsDataCustom] {
        return addonsDetails.addonsArray
    }
    
    func getVcIndex() -> Int {
        return vcIndex
    }
    
    func getCurrentFlightKey() -> String {
        return currentFlightKey
    }
     
    func updateContactInOthers(OthersIndex: Int, contacts : [ATContact]){
        addonsDetails.addonsArray[OthersIndex].othersSelectedFor = contacts
    }
    
    
}
