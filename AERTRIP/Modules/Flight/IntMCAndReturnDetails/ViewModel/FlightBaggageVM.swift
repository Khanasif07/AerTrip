//
//  FlightBaggageVM.swift
//  AERTRIP
//
//  Created by Appinventiv  on 11/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol  FlightBaggageVMDelegate : NSObjectProtocol {
    func flightBaggageDetailsApiResponse(details:[JSONDictionary], journeyObj:IntJourney?, journey: Journey?)
    func flightBaggageDetailsResDomestic(details:[JSONDictionary], journeyObj:IntLeg)
}
extension FlightBaggageVMDelegate{
    func flightBaggageDetailsResDomestic(details:[JSONDictionary], journeyObj:IntLeg){}
}

class FlightBaggageVM{
    var itineraryId = ""
    weak var delegate: FlightBaggageVMDelegate?
    var intJourrney:IntJourney?

    func callAPIforBaggageInfo(sid:String, fk:String, journeyObj:IntJourney?, journey: Journey?, count: Int = 3){
        guard count >= 0 else {return}
        var param = [APIKeys.sid.rawValue:sid, "fk[]":fk]
        if !self.itineraryId.isEmpty{
            param[APIKeys.it_id.rawValue] = self.itineraryId
        }
        APICaller.shared.getFlightbaggageDetails(params: param) {[weak self] (data, error) in
            guard let self = self else {return}
            if let bgData = data{
                
                var keys:[String] = Array(bgData.keys)
                ///To keep same order for baggage data as flights all keys are changed with flight ffk.
                if let journey = self.intJourrney{
                    let ffk = (journey.legsWithDetail.flatMap{$0.flightsWithDetails}).map{$0.ffk}
                    if keys.count == ffk.count{
                        keys = ffk
                    }
                }
                var baggageData = [JSONDictionary]()
                if keys.count > 0{
                    for key in keys{
                        if let datas = bgData["\(key)"] as? JSONDictionary{
                            baggageData += [datas]
                        }
                    }
                }
                self.delegate?.flightBaggageDetailsApiResponse(details: baggageData, journeyObj: journeyObj, journey: journey)
                
            }else{
                self.callAPIforBaggageInfo(sid:sid, fk:fk, journeyObj: journeyObj, journey: journey, count: (count - 1))
            }
            
        }
    }
    
    func callAPIforBaggageInfoForDomestic(sid:String, fk:String, journeyObj:IntLeg,  count: Int = 3){
        guard count >= 0 else {return}
//        let param = [APIKeys.sid.rawValue:sid, "fk[]":fk]
        var param = [APIKeys.sid.rawValue:sid, "fk[]":fk]
        if !self.itineraryId.isEmpty{
            param[APIKeys.it_id.rawValue] = self.itineraryId
        }
        APICaller.shared.getFlightbaggageDetails(params: param) {[weak self] (data, error) in
            guard let self = self else {return}
            if let bgData = data {
                let keys = bgData.keys
                var baggageData = [JSONDictionary]()
                if keys.count > 0{
                    for key in keys{
                        if let datas = bgData["\(key)"] as? JSONDictionary{
                            baggageData += [datas]
                        }
                    }
                }
                self.delegate?.flightBaggageDetailsResDomestic(details: baggageData, journeyObj: journeyObj)
            }else{
                self.callAPIforBaggageInfoForDomestic(sid: sid, fk: fk, journeyObj: journeyObj,  count: (count - 1))
            }
            
        }
    }
    
}
