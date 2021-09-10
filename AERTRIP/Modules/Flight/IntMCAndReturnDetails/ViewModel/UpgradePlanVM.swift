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
    var oldIntJourney : [IntJourney]?
    var isInternational:Bool = false
    var otherFareData = [[OtherFareModel]?]()
    var selectedOtherFareData = [OtherFareModel?]()
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
        
        if self.retriveData(for: fk) != nil{
            delay(seconds: 0.2) {
                self.delegate?.didFetchDataAt(index: index, data: self.retriveData(for: fk))
            }
            return
        }
        self.delegate?.willFetchDataAt(index: index)
        APICaller.shared.getOtherFare(params: param) {[weak self] (success, errorCode, otherFare) in
            guard let self = self else {return}
            if success, let data = otherFare{
                self.saveDataToAppDelegate(otherFare, for: fk)
                self.delegate?.didFetchDataAt(index: index, data: data)
            }else{
                self.delegate?.failsWithError(index: index)
            }
            
        }
    }
    
    func updateFareTaxes()-> Double{
        var totalFare: Double = 0
        
        for (index, value) in self.selectedOtherFareData.enumerated(){
            
            if value != nil{
                totalFare += value?.farepr ?? 0
            }else{
                totalFare += (self.isInternational) ? (oldIntJourney?[index].farepr ?? 0) : (oldJourney?[index].farepr ?? 0)
            }
        }
        return totalFare
    }
    
    
    private  func generateParamsForConfirmation()-> JSONDictionary{
        var param:JSONDictionary = ["sid": sid]

            for (index, value) in self.selectedOtherFareData.enumerated(){
                if value != nil{
                    param["old_farepr[\(index)]"] = value?.farepr ?? 0
                    param["fk[\(index)]"] = value?.flightResult.fk ?? ""
                    
                }else{
                    if self.isInternational{
                        param["old_farepr[\(index)]"] = self.oldIntJourney?[index].farepr ?? 0
                        param["fk[\(index)]"] = self.oldIntJourney?[index].fk ?? ""
                    }else{
                        param["old_farepr[\(index)]"] = self.oldJourney?[index].farepr ?? 0
                        param["fk[\(index)]"] = self.oldJourney?[index].fk ?? ""
                    }
                }
            }
        if let bookingObject = self.bookingObject, !((bookingObject.aerinSessionId?.isEmpty ?? true)){
            param["aerin_session_id"] = bookingObject.aerinSessionId
        }
        
        return param
    }
    
    
    func fetchConfirmationData(_ completion: @escaping((_ isSuccess:Bool, _ errorCode: ErrorCodes)->())){
        let param:JSONDictionary = self.generateParamsForConfirmation()
        APICaller.shared.getConfirmation(params: param) {[weak self](success, errorCode, itineraryData) in
            guard let self = self else{return}

            if let itinerary = itineraryData{
                self.itineraryData = itinerary
            }
            completion(success, errorCode)
        }
    }
    
    
    func getOtherModelForDomestic()-> [OtherFareModel]{
        var otherFare = [OtherFareModel]()
        for (index, value) in selectedOtherFareData.enumerated(){
            if let fare = value{
                otherFare.append(fare)
            }else{
                var otherFareData = OtherFareModel()
                let journey = self.oldJourney?[index]
                otherFareData.farepr = journey?.farepr ?? 0
                otherFareData.fare.bf.value = journey?.fare.BF.value  ?? 0
                otherFareData.fare.taxes.value = journey?.fare.taxes.value  ?? 0
                otherFareData.fare.taxes.details = journey?.fare.taxes.details  ?? [:]
                otherFareData.fare.totalPayableNow.value = journey?.fare.totalPayableNow.value ?? 0
                otherFare.append(otherFareData)
            }
        }
        return otherFare
    }
    
    func saveDataToAppDelegate(_ data: [OtherFareModel]?, for fk: String){
        
        if let appDel = UIApplication.shared.delegate as? AppDelegate{
            if let index = appDel.upgradePlanData.firstIndex(where: {$0.fk == fk}){
                appDel.upgradePlanData[index].date = Date()
                appDel.upgradePlanData[index].data = data
            }else{
                let cachedModel = OtherFareCache(data: data, date: Date(), fk: fk)
                appDel.upgradePlanData.append(cachedModel)
            }
        }
    }
    
    private func clearCachedData(){
        if let appDel = UIApplication.shared.delegate as? AppDelegate{
            appDel.upgradePlanData.removeAll(where: {($0.date.add(minutes: 5) ?? Date()) <= Date()})
        }
    }
    
    func retriveData(for fk: String)-> [OtherFareModel]?{
        self.clearCachedData()
        if let appDel = UIApplication.shared.delegate as? AppDelegate, let index = appDel.upgradePlanData.firstIndex(where: {$0.fk == fk}){
            if (appDel.upgradePlanData[index].date.add(minutes: 5) ?? Date()) >= Date(){
                return appDel.upgradePlanData[index].data
            }
        }
        return nil
    }
    

    
}
