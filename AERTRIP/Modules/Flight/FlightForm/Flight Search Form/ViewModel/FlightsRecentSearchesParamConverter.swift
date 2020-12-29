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
            if let leftVal = arDt[0].int {
                jsonDict["filters[\(filterIndex)][ar_dt][0]"] = leftVal.toString
            }
            if let rightVal = arDt[1].int {
                jsonDict["filters[\(filterIndex)][ar_dt][1]"] = rightVal.toString
            }
        }
        
        if let airlines = filter["al"].array {
            airlines.enumerated().forEach { (index, airline) in
                jsonDict["filters[\(filterIndex)][al][\(index)]"] = airline.stringValue
            }
        }
        
        if let minTime = filter["duration"]["min"].int {
            jsonDict["filters[\(filterIndex)][tt][0]"] = ((minTime)/3600).toString
        }
        
        if let maxTime = filter["duration"]["max"].int {
            jsonDict["filters[\(filterIndex)][tt][1]"] = ((maxTime)/3600).toString
        }
        
        if let minTime = filter["layoverDuration"]["min"].int {
            jsonDict["filters[\(filterIndex)][lott][0]"] = ((minTime)/3600).toString
        }
        
        if let maxTime = filter["layoverDuration"]["max"].int {
            jsonDict["filters[\(filterIndex)][lott][1]"] = ((maxTime)/3600).toString
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
        
        return jsonDict
    }
}
