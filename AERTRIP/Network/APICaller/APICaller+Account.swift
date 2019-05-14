//
//  APICaller+Account.swift
//  AERTRIP
//
//  Created by Admin on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation


extension APICaller {
    
    func getAccountDetailsAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ accountLadger: JSONDictionary, _ outstandingLadger: JSONDictionary, _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.accountDetail, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess {
                    let data = jsonData[APIKeys.data.rawValue]
                    let ledger = data["ledger"]
                    
                    var accLadger: JSONDictionary = JSONDictionary()
                    var outLadger: JSONDictionary = JSONDictionary()
                    
                    if let transactions = data["outstanding"]["transactions"].arrayObject as? [JSONDictionary] {
                        outLadger = AccountDetailEvent.modelsDict(data: transactions)
                    }
                    
                    if let transactions = ledger["transactions"].arrayObject as? [JSONDictionary] {
                        accLadger = AccountDetailEvent.modelsDict(data: transactions)
                    }

                    if let accData = ledger["summary"].dictionaryObject {
                        UserInfo.loggedInUser?.accountData = AccountModel(json: accData)
                    }
                    completionBlock(true, accLadger, outLadger, [])
                }
                else {
                    completionBlock(false, [:], [:], [])
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, [:], [:], error)
            })
        }) { error in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [:], [:], [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, [:], [:], [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
}
