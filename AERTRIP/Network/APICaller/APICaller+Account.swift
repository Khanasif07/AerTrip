//
//  APICaller+Account.swift
//  AERTRIP
//
//  Created by Admin on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation


extension APICaller {
    
    func getAccountDetailsAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ accountLadger: JSONDictionary, _ accountLadgerVouchers: [String], _ outstanding: AccountOutstanding? , _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.accountDetail, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess {
                    let data = jsonData[APIKeys.data.rawValue]
                    let ledger = data["ledger"]
                    
                    var accLadger: JSONDictionary = JSONDictionary()
                    var accLadgerVchrs: [String] = []
                    var outStand: AccountOutstanding? = nil
                    
                    if let outstanding = data["outstanding"].dictionaryObject {
                        outStand = AccountOutstanding(json: outstanding)
                    }
                    
                    if let transactions = ledger["transactions"].arrayObject as? [JSONDictionary] {
                        let (lad, vchr) = AccountDetailEvent.modelsDict(data: transactions)
                        accLadger = lad
                        accLadgerVchrs = vchr
                    }

                    if let accData = ledger["summary"].dictionaryObject {
                        UserInfo.loggedInUser?.accountData = AccountModel(json: accData)
                    }
                    completionBlock(true, accLadger, accLadgerVchrs, outStand, [])
                }
                else {
                    completionBlock(false, [:], [], nil, [])
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, [:], [], nil, error)
            })
        }) { error in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [:], [], nil, [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, [:], [], nil, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
}
