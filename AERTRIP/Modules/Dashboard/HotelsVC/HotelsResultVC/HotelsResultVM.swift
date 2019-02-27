//
//  HotelsResultVM.swift
//  AERTRIP
//
//  Created by Admin on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelResultDelegate : class {
    
    func getAllHotelsListResultSuccess(_ isDone:Bool)
    func getAllHotelsListResultFail(errors: ErrorCodes)
    
}

class HotelsResultVM: NSObject {
    
    var sid: String = ""
    internal var hotelListResult = [HotelsSearched]()
    var hotelSearchRequest : HotelSearchRequestModel?
    
     weak var delegate: HotelResultDelegate?
    
    func searchHotel(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(callSearchHotel(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc private func callSearchHotel(_ forText: String) {
        printDebug("search text for: \(forText)")
    }
    
    func hotelListOnPreferenceResult() {
        let params: JSONDictionary = [APIKeys.vcodes.rawValue : self.hotelSearchRequest?.vcodes.first ?? "" , APIKeys.sid.rawValue : self.hotelSearchRequest?.sid ?? ""]
        printDebug(params)
        APICaller.shared.getHotelsListOnPreferenceResult(params: params) { [weak self] (success, errors, hotels,isDone) in
            guard let sSelf = self else {return}
            if success {
                sSelf.hotelListResult = hotels
                for hotel in hotels {
                    _ =  HotelSearched.insert(dataDict: hotel.jsonDict)
                }
                
                sSelf.delegate?.getAllHotelsListResultSuccess(isDone)
            } else {
                printDebug(errors)
                // AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelSearch)
                sSelf.delegate?.getAllHotelsListResultFail(errors: errors)
            }
        }
    }
    
    
    
    
    
    
    
    
    
}
