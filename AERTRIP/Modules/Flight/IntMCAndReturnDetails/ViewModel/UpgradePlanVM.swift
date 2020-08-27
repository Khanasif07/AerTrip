//
//  UpgradePlanVM.swift
//  AERTRIP
//
//  Created by Appinventiv  on 26/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


protocol UpgradePlanVMDelegate:NSObjectProtocol {
    func willFetchDataAt(index: Int)
    func didFetchDataAt(index: Int, data: [OtherFareModel]?)
    func failsWithError(index: Int)
}

class UpgradePlanVM{
    
    var oldJourney: [Journey]?
    var ohterFareData = [[OtherFareModel]?]()
    var selectedOhterFareData = [OtherFareModel?]()
    var allTabsStr = [NSAttributedString]()
    var currentIndex = 0
    var sid = ""
    var flightAdultCount = 0
    var flightChildrenCount = 0
    var flightInfantCount = 0
    var selectedJourneyFK = [String]()
    var taxesResult : [String : String]!
    var bookingObject:BookFlightObject?
    weak var delegate: UpgradePlanVMDelegate?
    var itineraryData = FlightItineraryData()
    
    func getOtherFare(with fk:String, oldFare: String, index:Int){
        let param = ["sid": self.sid, "fk[]":fk, "old_farepr[]": oldFare]
        self.delegate?.willFetchDataAt(index: index)
        APICaller.shared.getOtherFare(params: param) {[weak self] (success, errorCode, otherFare) in
            guard let self = self else {return}
            if success, let data = otherFare{
                self.delegate?.didFetchDataAt(index: index, data: data)
            }else{
                self.delegate?.willFetchDataAt(index: index)
            }
            
        }
    }
    
    func updateFareTaxes()-> Int{
        var totalFare = 0
        
        for (index, value) in self.selectedOhterFareData.enumerated(){
            
            if value != nil{
                totalFare += value?.farepr ?? 0
            }else{
                totalFare += oldJourney?[index].farepr ?? 0
            }
        }
        return totalFare
    }
    
    
    func fetchConfirmationData(_ completion: @escaping((_ isSuccess:Bool, _ errorCode: ErrorCodes)->())){
        var param:JSONDictionary = ["sid": sid]
        
        for (index, value) in self.selectedOhterFareData.enumerated(){
            if value != nil{
                param["old_farepr[\(index)]"] = value?.farepr ?? 0
                param["fk[\(index)]"] = value?.flightResult.fk ?? ""
                
            }else{
                param["old_farepr[\(index)]"] = self.oldJourney?[index].farepr ?? 0
                param["fk[\(index)]"] = self.oldJourney?[index].fk ?? ""
                
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
