//
//  APICaller+Settings.swift
//  AERTRIP
//
//  Created by Appinventiv on 06/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {

    func getCurrencies(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: [PKCountryModel]) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.currencies, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                
                if sucess {
                   let currencies = json[APIKeys.data.rawValue].arrayValue.map { (jsonObj) -> PKCountryModel in
                        return PKCountryModel(json: jsonObj)
                    }
                    completionBlock(true,currencies)
                }else{
                    completionBlock(false,[])
                }
                
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .chatBot)
                
                completionBlock(false,[])
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                completionBlock(false, [])
            }
        }
    }

}
