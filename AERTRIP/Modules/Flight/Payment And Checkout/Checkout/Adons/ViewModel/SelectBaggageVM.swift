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
        
       self.addonsDetails.addonsArray = self.addonsDetails.addonsArray.map { (addon) -> AddonsDataCustom in
            var newAddon = addon
            newAddon.isInternational = newAddon.adonsName.contains("_IN")
            return newAddon
        }
        
        
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
     
    func updateContactInBaggage(baggageIndex: Int, contacts : [ATContact], autoSelectedFor: [String]){
        addonsDetails.addonsArray[baggageIndex].bagageSelectedFor = contacts
        
        var autoSelectedForString = "Auto Selected for "
        var flightName : [String] = []
        
//        if autoSelectedFor.isEmpty {
//                 addonsDetails.addonsArray[baggageIndex].autoSelectedFor = ""
//                 return }
        
        autoSelectedFor.forEach { (flightId) in
              let flightAtINdex = AddonsDataStore.shared.allFlights.filter { $0.ffk == flightId }
              guard let firstFlight = flightAtINdex.first else { return }
              flightName.append("\(firstFlight.fr) → \(firstFlight.to)")
          }
          
            if flightName.isEmpty {
                autoSelectedForString = ""
            } else if flightName.count == 1 {
                  autoSelectedForString += flightName.first ?? ""
              }else if flightName.count == 2 {
                  autoSelectedForString += flightName.joined(separator: ",").replacingLastOccurrenceOfString(" ,", with: " and ")
              }else{
                 autoSelectedForString += flightName.joined(separator: ",").replacingLastOccurrenceOfString(",", with: " and ")
              }
              
              if contacts.isEmpty {
                  addonsDetails.addonsArray[baggageIndex].autoSelectedFor = ""
              }else{
                  addonsDetails.addonsArray[baggageIndex].autoSelectedFor = autoSelectedForString
              }
             
        
        self.formatData()
    }
    
    }
