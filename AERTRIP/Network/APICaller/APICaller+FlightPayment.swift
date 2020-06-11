//
//  APICaller+FlightPayment.swift
//  AERTRIP
//
//  Created by Apple  on 10.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller{
    //https://beta.aertrip.com/api/v1/flights/itinerary?action=traveller&it_id=5ee0f047b3561a2fe41e4032
    
    func getItineraryData(params: JSONDictionary, itId:String, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ data: FlightItineraryData?)->Void ) {
        let url = "\(APIEndPoint.baseUrlPath.rawValue)flights/itinerary?action=traveller&it_id=\(itId)"
        AppNetworking.POST(endPointPath: url, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    completionBlock(true, [], FlightItineraryData(json[APIKeys.data.rawValue]))
                }
                else {
                    completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
                }
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
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
