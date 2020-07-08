//
//  FlightDetailsVM.swift
//  AERTRIP
//
//  Created by Apple  on 07.07.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol FlightDetailsVMDelegate : NSObjectProtocol{
    func startFetchingConfitmationData()
    func getResponseForConfirmationData(isSuccess: Bool)
}

class FlightDetailsVM{
    
    var sid = ""
    var journey: [Journey]?
    var intJourney:[IntJourney]?
    var journeyType = JourneyType.international
    var itineraryData = FlightItineraryData()
    
    func fetchConfirmationData(_ completion: @escaping((_ isSuccess:Bool, _ errorCode: ErrorCodes)->())){
        var param:JSONDictionary = ["sid": sid]
        
        if journeyType == .international{
            if self.intJourney == nil{
                param["old_farepr[]"] = self.journey?.first?.farepr ?? 0
                param["fk[]"] = self.journey?.first?.fk ?? ""
            }else{
                param["old_farepr[]"] = self.intJourney?.first?.farepr ?? 0
                param["fk[]"] = self.intJourney?.first?.fk ?? ""
                param["combo"] = true
            }
        }else{
            guard let journey = journey else{return}
            for i in 0..<journey.count{
                param["old_farepr[\(i)]"] = journey[i].farepr
                param["fk[\(i)]"] = journey[i].fk
            }
        }
        APICaller.shared.getConfirmation(params: param) {[weak self](success, errorCode, itineraryData) in
            guard let self = self else{return}

            if let itinerary = itineraryData{
                self.itineraryData = itinerary
            }
            completion(success, errorCode)
        }
    }

    
}
