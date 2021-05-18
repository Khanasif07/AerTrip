//
//  APICaller+Settings.swift
//  AERTRIP
//
//  Created by Appinventiv on 06/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {

    func getCurrencies(completionBlock: @escaping (_ success: Bool, _ currencies: [CurrencyModel]) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.currenciesList, parameters: [:], success: { [weak self] json in
            guard let sSelf = self else { return }
//            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess {
                    let currencies = CurrencyModel.retunCurrencyModelArray(json: json[APIKeys.data.rawValue].dictionaryValue)
                    if let currency = currencies.first(where: {$0.currencyCode == UserInfo.loggedInUser?.preferredCurrencyCode ?? ""}){
                        UserInfo.preferredCurrencyDetails = currency
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
    
    
    func updateUserCurrency(params: JSONDictionary, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .updateAccountDetails,parameters: params,success: {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, data) in
                completionBlock(true, [])
            } failure: { (errorCode) in
                completionBlock(false, errorCode)
            }
        },failure: { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.default.message)
                completionBlock(false, [])
            }
        })
    }

}
