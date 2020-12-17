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
    
    weak var delegate: FlightBaggageVMDelegate?

    func callAPIforBaggageInfo(sid:String, fk:String, journeyObj:IntJourney?, journey: Journey?, count: Int = 3){
        guard count >= 0 else {return}
        let param = [APIKeys.sid.rawValue:sid, "fk[]":fk]
        APICaller.shared.getFlightbaggageDetails(params: param) {[weak self] (data, error) in
            guard let self = self else {return}
            if let bgData = data{
                let keys = bgData.keys
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
        let param = [APIKeys.sid.rawValue:sid, "fk[]":fk]
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
