//
//  HotelsSearchVM.swift
//  AERTRIP
//
//  Created by Admin on 25/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SearchHoteslOnPreferencesDelegate: class {
    func getAllHotelsOnPreferenceSuccess()
    func getAllHotelsOnPreferenceFail()
    
    func getAllHotelsOnPreferenceResultSuccess()
    func getAllHotelsOnPreferenceResultFail()
}

class HotelsSearchVM: NSObject{
    
    //MARK:- Properties
    //MARK:- Public
    var roomNumber: Int = 1
    var adultsCount: [Int] = [2]
    var childrenCounts: [Int] = [0]
    var childrenAge: [[Int]] = [[]]
    var checkInDate = "2019-02-24"
    var checkOutDate = "2019-03-03"
    var destId: String = ""
    var destType: String = ""
    var destName: String = ""
    var ratingCount: [Int] = []
    weak var delegate: SearchHoteslOnPreferencesDelegate?
    var vcodes: [String] = []
    var sid: String = ""
    var hotelListResult = [HotelsSearched]()
    
    //MARK:- Functions
    //================
    //MARK:- Private
    ///Params For Api
    private func paramsForApi() -> JSONDictionary {
        
        var params = JSONDictionary()
        let _adultsCount = self.adultsCount
        let _starRating = self.ratingCount
        let _chidrenAge = self.childrenAge
        params[APIKeys.check_in.rawValue] = self.checkInDate
        params[APIKeys.check_out.rawValue] = self.checkOutDate
        params[APIKeys.dest_id.rawValue] = self.destId
        params[APIKeys.dest_type.rawValue] = self.destType
        params[APIKeys.dest_name.rawValue] = self.destName
        params[APIKeys.isPageRefereshed.rawValue] = true
        
        for (idx , _ ) in _starRating.enumerated() {
            params["filter[star][\(idx)star]"] = true
        }
        
        for (idx ,  data) in _adultsCount.enumerated() {
            params["r[\(idx)][a]"] = data
        }
        
        for (idx , dataX) in _chidrenAge.enumerated() {
            for (idy , dataY) in dataX.enumerated() {
                params["r[\(idx)][c][\(idy)]"] = dataY
            }
        }
        
        printDebug(params)
        return params
    }
    
    //MARK:- Public
    ///Hotel List Api
    func hotelListOnPreferencesApi() {
        APICaller.shared.getHotelsListOnPreference(params: self.paramsForApi() ) { [weak self] (success, errors, sid, vCodes) in
            guard let sSelf = self else { return }
            if success {
                sSelf.vcodes = vCodes
                sSelf.sid = sid
                sSelf.delegate?.getAllHotelsOnPreferenceSuccess()
            } else {
                printDebug(errors)
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelSearch)
                sSelf.delegate?.getAllHotelsOnPreferenceFail()
            }
        }
    }
    
    func hotelListOnPreferenceResult() {
        let params: JSONDictionary = [APIKeys.vcodes.rawValue : self.vcodes.first ?? "" , APIKeys.sid.rawValue : self.sid]
        printDebug(params)
        APICaller.shared.getHotelsListOnPreferenceResult(params: params) { [weak self] (success, errors, hotels) in
            guard let sSelf = self else {return}
            if success {
                sSelf.hotelListResult = hotels
                for hotel in hotels {
                   _ =  HotelSearched.insert(dataDict: hotel.jsonDict)
                }
                
                sSelf.delegate?.getAllHotelsOnPreferenceResultSuccess()
            } else {
                printDebug(errors)
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelSearch)
                sSelf.delegate?.getAllHotelsOnPreferenceResultFail()
            }
        }
    }
}

