//
//  APICaller+Currency.swift
//  AERTRIP
//
//  Created by Admin on 29/04/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation


extension APICaller{
    
    
//    func getCurrencyList(completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ trips: [TripModel], _ defaultTrip: TripModel?) -> Void) {
//        AppNetworking.GET(endPoint: .currenices, parameters: [:], success: { [weak self] json in
//            guard let sSelf = self else { return }
//            printDebug(json)
//            sSelf.handleResponse(json, success: { sucess, jsonData in
//                if sucess {
//                    let (trips, defTrip) = TripModel.models(jsonArr: jsonData[APIKeys.data.rawValue].arrayObject as? [JSONDictionary] ?? [[:]])
//                    completionBlock(true, [], trips, defTrip)
//                }
//                else {
//                    completionBlock(false, [], [], nil)
//                }
//            }, failure: { error in
//                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
//                completionBlock(false, error, [], nil)
//            })
//        }) { (error) in
//            if error.code == AppNetworking.noInternetError.code {
//                AppGlobals.shared.stopLoading()
//                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
//                completionBlock(false, [], [], nil)
//            }
//            else {
//                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [], nil)
//            }
//        }
//    }
    
}
