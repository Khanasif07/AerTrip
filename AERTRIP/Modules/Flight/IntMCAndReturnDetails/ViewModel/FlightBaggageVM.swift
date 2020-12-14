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

    func callAPIforBaggageInfo(sid:String, fk:String, journeyObj:IntJourney?, journey: Journey?){

        let param = [APIKeys.sid.rawValue:sid, "fk[]":fk]
        APICaller.shared.getFlightbaggageDetails(params: param) {[weak self] (data, error) in
            guard let self = self , let bgData = data else {
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
                return
            }
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
        }
    }
    
    func callAPIforBaggageInfoForDomestic(sid:String, fk:String, journeyObj:IntLeg){
        
        let param = [APIKeys.sid.rawValue:sid, "fk[]":fk]
        APICaller.shared.getFlightbaggageDetails(params: param) {[weak self] (data, error) in
            guard let self = self , let bgData = data else {
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
                return
            }
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
        }
    }
    
}
