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
    
    var sagrigatedData : [Int:[AddonsDataCustom]] = [:]
    
    
    init(vcIndex : Int, currentFlightKey : String, addonsDetails : AddonsDetails){
        self.vcIndex = vcIndex
        self.currentFlightKey = currentFlightKey
        self.addonsDetails = addonsDetails
        self.formatData()
    }
    
    func formatData(){
        let allInternational = addonsDetails.addonsArray.filter { $0.adonsName.contains("_IN") }
        let allDomestic = addonsDetails.addonsArray.filter { !$0.adonsName.contains("_IN") }

             if !allDomestic.isEmpty && !allInternational.isEmpty{
                 sagrigatedData[0] = allDomestic
                 sagrigatedData[1] = allInternational
             }else if !allDomestic.isEmpty {
                  sagrigatedData[0] = allDomestic
             }else if !allInternational.isEmpty{
                 sagrigatedData[0] = allInternational
             }
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
     
    func updateContactInBaggage(baggageIndex: Int, contacts : [ATContact]){
        addonsDetails.addonsArray[baggageIndex].bagageSelectedFor = contacts
        self.formatData()
    }
    
    }
