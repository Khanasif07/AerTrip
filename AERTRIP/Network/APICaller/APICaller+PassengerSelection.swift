//
//  APICaller+PassengerSelection.swift
//  AERTRIP
//
//  Created by Apple  on 27.05.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller{
    
    
    func getAddonsMaster(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ data: AddonsMaster)->Void ) {
        
         let endPoints = "https://beta.aertrip.com/api/v1/flights/addons-master?\(APIKeys.it_id.rawValue)=\(params[APIKeys.it_id.rawValue] as? String ?? "")"
//        let path = "\(APIEndPoint.addonsMaster.path)?\(APIKeys.it_id.rawValue)=\(params[APIKeys.it_id.rawValue] as? String ?? "")"
        AppNetworking.GET(endPoint: endPoints,success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    completionBlock(true, [], AddonsMaster(json[APIKeys.data.rawValue]))
                }
                else {
                    completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], AddonsMaster())
                }
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors, AddonsMaster())
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], AddonsMaster())
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], AddonsMaster())
            }
        }
    }
    
    
    func getConfirmation(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ data: FlightItineraryData?)->Void ) {
        
        AppNetworking.GET(endPoint: .fareConfirmation, parameters: params, success: { [weak self] (json) in
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
