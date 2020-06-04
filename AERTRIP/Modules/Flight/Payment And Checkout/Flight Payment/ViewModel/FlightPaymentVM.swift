//
//  FlightPaymentVM.swift
//  AERTRIP
//
//  Created by Apple  on 03.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class FlightPaymentVM{
    
    var itinerary = FlightItinerary()
    var taxesResult = [String:String]()
    var taxAndFeesData = [NSDictionary]()
    
    func taxesDataDisplay(){
        taxAndFeesData.removeAll()
        var taxesDetails : [String:Int] = [String:Int]()
        var taxAndFeesDataDict = [taxStruct]()
        taxesDetails = self.itinerary.details.fare.taxes.details
        for (_, value) in taxesDetails.enumerated() {
            let newObj = taxStruct.init(name: taxesResult[value.key] ?? "", taxVal: value.value)
            taxAndFeesDataDict.append(newObj)
        }
        let newDict = Dictionary(grouping: taxAndFeesDataDict) { $0.name }
        for ( key , _ ) in newDict {
            let dataArray = newDict[key]
            var newTaxVal = 0
            for i in 0..<dataArray!.count{
                newTaxVal += (dataArray?[i].taxVal ?? 0)
            }
            let newArr = ["name" : key, "value":newTaxVal] as NSDictionary
            taxAndFeesData.append(newArr)
            
        }
        
    }

    
}
