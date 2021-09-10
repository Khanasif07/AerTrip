//
//  IntMultiCityAndReturnDisplay.swift
//  Aertrip
//
//  Created by Rishabh on 22/04/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation

class IntMultiCityAndReturnDisplay {
    
    var journeyArray : [IntMultiCityAndReturnWSResponse.Results.J]
    var isCollapsed = true
    
    init (_ journeyArray : [IntMultiCityAndReturnWSResponse.Results.J]) {
        self.journeyArray = journeyArray.sorted {  $0.departTimeInterval <  $1.departTimeInterval }
    }
    
    var count : Int {
        return journeyArray.count
    }
    
    var isCheapest : Bool {
        let sorted =  journeyArray.sorted(by: { $0.farepr < $1.farepr })
        return sorted.first!.isCheapest ??  false
    }
    
    var isFastest : Bool {
        
        let sorted =  journeyArray.sorted(by: { $0.duration < $1.duration })
        return  sorted.first?.isFastest ?? false
    }
    
    var first : IntMultiCityAndReturnWSResponse.Results.J {
        return journeyArray.first!
    }

    var isAboveHumanScore : Bool {
        return first.isAboveHumanScore ?? false
    }
    
    var computedHumanScore : Float {
        return getJourneyWithLeastHumanScore().computedHumanScore!
    }
    
    //    var isPinned : Bool?
    
    var cellType : OnewayCellType {
        
        if journeyArray.count > 1 {
            return .groupedJourneyCell
        }
        return .singleJourneyCell
    }
    
    var fare : Double {
        
        let sorted =  journeyArray.sorted(by: { $0.farepr < $1.farepr })
        return sorted.first!.farepr
    }
    
    
    
    var debugDescription: String {
        
        var fkArray = [String]()
        
        for jouney in journeyArray {
            
            fkArray.append(jouney.fk)
        }
        
        fkArray.sort(by: {$0 < $1 })
        
        let joined = fkArray.joined(separator: ",")
        let newString = joined.replacingOccurrences(of: ",", with: "\n")
        
        return newString
    }
    
    var containsPinnedFlight : Bool {
        return self.journeyArray.reduce(journeyArray[0].isPinned ?? false ){ $0 || $1.isPinned  ?? false }
    }
    
    var pinnedFlights : [IntMultiCityAndReturnWSResponse.Results.J] {
        return self.journeyArray.filter{ $0.isPinned  ?? false }
    }
    
    func setPinned(_ isPinned : Bool , atIndex : Int) {
        self.journeyArray[atIndex].isPinned = isPinned
    }
    
    func isPinned( atIndex : Int) -> Bool {
        return self.journeyArray[atIndex].isPinned  ?? false
    }
    
    func getJourneyWith(fk : String) -> IntMultiCityAndReturnWSResponse.Results.J? {
        
        return self.journeyArray.first(where:{ $0.fk == fk })
    }
    
    func getJourneyWithLeastHumanScore () ->  IntMultiCityAndReturnWSResponse.Results.J {
            let sorted =  journeyArray.sorted(by: { $0.computedHumanScore! < $1.computedHumanScore! })
            return sorted.first!
    }
    
    var selectedFK = String()
    
    func getMaxThresholdFor(_ journeyArr: [IntMultiCityAndReturnWSResponse.Results.J]) -> Double {
        
        let sectionsPerJourney = journeyArr.map { $0.leg.count }
        let maxSections = sectionsPerJourney.max() ?? 0
        let newJourneyArr = journeyArr.compactMap { (journey) -> IntMultiCityAndReturnWSResponse.Results.J? in
            if journey.leg.count == maxSections {
                return journey
            } else {
                return nil
            }
        }
        var minDurationForSection = [Int:Int]()
        
        for index in 0..<maxSections {
            let legs = newJourneyArr.compactMap { (journey) -> IntMultiCityAndReturnWSResponse.Results.Ldet? in
                if journey.legsWithDetail.indices.contains(index) {
                    return journey.legsWithDetail[index]
                }
                return nil
            }
            let minDuration = legs.min(by: { $0.duration < $1.duration })?.duration
            minDurationForSection[index] = minDuration ?? 0
        }
        let minThresholdDuration = minDurationForSection.values.reduce(0,+)
        return Double(minThresholdDuration) * 1.2
    }
    
}
