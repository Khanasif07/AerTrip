//
//  APICaller+FlightPending.swift
//  AERTRIP
//
//  Created by Apple  on 03.07.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller{
    
    func getItinerayDataForPendingPayment(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ itineraryData : FlightItinerary?)->Void) {
        AppNetworking.GET(endPoint:APIEndPoint.flightItinerary, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            sSelf.handleResponse(json, success: { (success, jsonData) in
                printDebug(jsonData)
                if success {
                    let receiptModel = FlightItinerary(jsonData[APIKeys.data.rawValue][APIKeys.itinerary.rawValue])
                    completionBlock(true, [] , receiptModel)
                } else {
                    completionBlock(true, [], nil)
                }
            }, failure:  { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .flights)
                completionBlock(false, errors, nil)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], nil)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
            }
        }
    }

    
    func refundAPIForPendingPayment(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ messages : String?)->Void) {
        AppNetworking.GET(endPoint:APIEndPoint.refundCase, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            sSelf.handleResponse(json, success: { (success, jsonData) in
                printDebug(jsonData)
                if success {
                    let msg = jsonData[APIKeys.data.rawValue].arrayValue.map{$0.stringValue}.first
                    completionBlock(true, [] , msg)
                } else {
                    completionBlock(true, [], nil)
                }
            }, failure:  { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .flights)
                completionBlock(false, errors, nil)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], nil)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
            }
        }
    }
    
}
