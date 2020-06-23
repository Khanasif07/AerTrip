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
     
    func updateContactInOthers(OthersIndex: Int, contacts : [ATContact], autoSelectedFor : [String]){
        addonsDetails.addonsArray[OthersIndex].othersSelectedFor = contacts
        
        if autoSelectedFor.isEmpty {
            addonsDetails.addonsArray[OthersIndex].autoSelectedFor = ""
            return }
        
        
        var autoSelectedForString = "Auto Selected for "
        var flightName : [String] = []
        
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
            addonsDetails.addonsArray[OthersIndex].autoSelectedFor = ""
        }else{
            addonsDetails.addonsArray[OthersIndex].autoSelectedFor = autoSelectedForString
        }
        
    }
    
    
}
