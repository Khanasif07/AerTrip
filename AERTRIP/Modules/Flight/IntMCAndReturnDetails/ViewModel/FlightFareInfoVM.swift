//
//  FlightFareInfoVM.swift
//  AERTRIP
//
//  Created by Appinventiv  on 11/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol  FlightFareInfoVMDelegate: NSObjectProtocol{
    func flightFareInfoData(data: Data, index:Int)
    func flightFareRules(data: JSONDictionary, index: Int)
}

class FlightFareInfoVM{
    
    weak var delegate : FlightFareInfoVMDelegate?
    var itineraryId = ""
    
    func getFareInfoAPICall(sid: String, fk: String, index:Int, count: Int = 3){
        guard count >= 0 else {return}
        let param = [APIKeys.sid.rawValue: sid, "fk[]":fk]
        if let data = self.checkDataInCach(with: fk){
            self.delegate?.flightFareInfoData(data: data, index: index)
        }else{
            APICaller.shared.getFlightFareInfo(params: param) {[weak self](fareData, error) in
                guard let self = self else {return}
                if let data = fareData{
                    self.delegate?.flightFareInfoData(data: data, index: index)
                    self.storeDataInCaching(with: fk, data: data)
                }else{
                    self.getFareInfoAPICall(sid: sid, fk: fk, index:index, count: (count - 1))
                }
            }
        }
    }
    
    func getFareRulesAPICall(sid: String, fk: String, index:Int, count: Int = 3){
        guard count >= 0 else {
//            AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .flights)
            return
        }
        let param = ["sid": sid, "fk[]": fk]
        APICaller.shared.getFareRules(params: param) {[weak self] (data, error) in
            guard let self = self else {return}
            if let fareRulesdata = data {
                self.delegate?.flightFareRules(data: fareRulesdata, index: index)
                
            }else{
                self.getFareRulesAPICall(sid: sid, fk: fk, index:index, count: (count - 1))
            }
        }

    }
    
}


extension FlightFareInfoVM{
    
    
    func storeDataInCaching(with fk:String, data: Data){
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let _ = parse(data: data, into: updatedFareInfoStruct.self, with:decoder) {
            let dict = [fk:data, "date":Date()] as [String : Any]
            appDelegate.flightFareInfoMutableArray.append(dict)
        }
    }
    
    
    func checkDataInCach(with fk: String)-> Data?{
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let index = appDelegate.flightFareInfoMutableArray.firstIndex(where: {$0[fk] != nil}), let date = appDelegate.flightFareInfoMutableArray[index]["date"] as? Date{
            if Date().minutesFrom(date) < 5{
                return appDelegate.flightFareInfoMutableArray[index][fk] as? Data
            }else{
                appDelegate.flightFareInfoMutableArray.remove(at: index)
                return nil
            }
        }
        return nil
    }
    
}
