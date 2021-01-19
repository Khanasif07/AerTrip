//
//  FlightsRecentSearchesParamConverter.swift
//  AERTRIP
//
//  Created by Rishabh on 24/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class FlightsRecentSearchesParamConverter: NSObject {
    
    @objc func convertParam(_ params: NSArray) -> NSDictionary {
        var filtersDict = JSONDictionary()
        params.enumerated().forEach { (filterParam) in
            let legIndex = filterParam.offset
            let filterJson = JSON(filterParam.element)
            let legFilterParams = convertToDict(filterIndex: legIndex, filterJSON: filterJson)
            filtersDict = filtersDict.merging(legFilterParams) { $1 }
        }
        let dictToReturn = NSDictionary(dictionary: filtersDict)
        return dictToReturn
    }
    
    private func convertToDict(filterIndex: Int, filterJSON: JSON) -> JSONDictionary {
        var jsonDict = JSONDictionary()
        let filter = filterJSON

        if let fq = filter["fq"].array {
            fq.enumerated().forEach { (index, fq1) in
                jsonDict["filters[\(filterIndex)][fq][\(index)]"] = fq1.stringValue
            }
        }
        
        if let stops = filter["stp"].array {
            stops.enumerated().forEach { (index, stop) in
                jsonDict["filters[\(filterIndex)][stp][\(index)]"] = stop.stringValue
            }
        }
        
        if let depDt = filter["dep_dt"].array {
            jsonDict["filters[\(filterIndex)][dep_dt][0]"] = depDt[0].stringValue
            jsonDict["filters[\(filterIndex)][dep_dt][1]"] = depDt[1].stringValue
        }
        
        if let arDt = filter["ar_dt"].array {
            jsonDict["filters[\(filterIndex)][ar_dt][0]"] = arDt[0].stringValue
            jsonDict["filters[\(filterIndex)][ar_dt][1]"] = arDt[1].stringValue
        }
        
        if let airlines = filter["al"].array {
            airlines.enumerated().forEach { (index, airline) in
                jsonDict["filters[\(filterIndex)][al][\(index)]"] = airline.stringValue
            }
        }
        
        if let tt = filter["tt"].array {
            jsonDict["filters[\(filterIndex)][tt][0]"] = tt[0].stringValue
            jsonDict["filters[\(filterIndex)][tt][1]"] = tt[1].stringValue
        }
        
        if let lott = filter["lott"].array {
            jsonDict["filters[\(filterIndex)][lott][0]"] = lott[0].stringValue
            jsonDict["filters[\(filterIndex)][lott][1]"] = lott[1].stringValue
        }
        
        if let price = filter["pr"].array {
            jsonDict["filters[\(filterIndex)][pr][0]"] = price[0].stringValue
            jsonDict["filters[\(filterIndex)][pr][1]"] = price[1].stringValue
        }
        
        if let loap = filter["loap"].array {
            loap.enumerated().forEach { (index, airline) in
                jsonDict["filters[\(filterIndex)][loap][\(index)]"] = airline.stringValue
            }
        }
        
        if let aircraft = filter["eq"].array {
            aircraft.enumerated().forEach { (index, airline) in
                jsonDict["filters[\(filterIndex)][eq][\(index)]"] = airline.stringValue
            }
        }
        
        return jsonDict
    }
}
