//
//  APICaller+Account.swift
//  AERTRIP
//
//  Created by Admin on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation


extension APICaller {
    
    func getAccountDetailsAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ accountLadger: JSONDictionary, _ accountLadgerVouchers: [String], _ outstanding: AccountOutstanding?, _ periodicEventData: JSONDictionary, _ errorCodes: ErrorCodes) -> Void) {
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
                    
                    //***************//
                    let periodicDict: [JSONDictionary] = [
                        [
                            "id": "37",
                            "statement_date": "2018-03-08 00:00:00",
                            "period_from": "2018-03-01",
                            "period_to": "2018-03-07",
                            "due_date": "2018-03-12 00:00:00"
                        ],
                        [
                            "id": "25",
                            "statement_date": "2018-03-01 00:00:00",
                            "period_from": "2018-02-22",
                            "period_to": "2018-02-28",
                            "due_date": "2018-03-05 00:00:00"
                        ],
                        [
                            "id": "16",
                            "statement_date": "2018-02-22 00:00:00",
                            "period_from": "2018-02-15",
                            "period_to": "2018-02-21",
                            "due_date": "2018-02-26 00:00:00"
                        ],
                        [
                            "id": "1",
                            "statement_date": "2018-02-15 00:00:00",
                            "period_from": "2018-02-08",
                            "period_to": "2018-02-14",
                            "due_date": "2018-02-19 00:00:00"
                        ],
                        [
                            "id": "3",
                            "statement_date": "2018-01-15 00:00:00",
                            "period_from": "2018-01-25",
                            "period_to": "2018-02-07",
                            "due_date": "2018-02-19 00:00:00"
                        ],
                        [
                            "id": "5",
                            "statement_date": "2019-01-15 00:00:00",
                            "period_from": "2019-01-25",
                            "period_to": "2019-02-07",
                            "due_date": "2019-02-19 00:00:00"
                        ]
                    ]
                    
                    let periodicData = PeriodicStatementEvent.modelsDict(data: periodicDict)

                    //****************//
                    

                    if let accData = ledger["summary"].dictionaryObject {
                        var temp = accData
                        temp["opening_balance"] = ledger["opening_balance"]
                        temp["current_total"] = ledger["current_total"]
                        temp["running_balance"] = ledger["running_balance"]
                        let data = AccountModel(json: temp)
                        UserInfo.loggedInUser?.accountData = data
                    }
                    completionBlock(true, accLadger, accLadgerVchrs, outStand, periodicData, [])
                }
                else {
                    completionBlock(false, [:], [], nil, [:], [])
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, [:], [], nil, [:], error)
            })
        }) { error in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [:], [], nil, [:], [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, [:], [], nil, [:], [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    func accountReportActionAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.accountReportAction, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess {
                    completionBlock(true, [])
                }
                else {
                    completionBlock(false, [])
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error)
            })
        }) { error in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }

    func outstandingPaymentAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ itinerary: DepositItinerary?) -> Void) {
        AppNetworking.POST(endPoint: APIEndPoint.outstandingPayment, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess {
                    
                    var itin: DepositItinerary?
                    if let dict = jsonData[APIKeys.data.rawValue][APIKeys.itinerary.rawValue].dictionaryObject {
                        itin = DepositItinerary(json: dict)
                    }
                    
                    completionBlock(true, [], itin)
                }
                else {
                    completionBlock(false, [], nil)
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error, nil)
            })
        }) { error in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue], nil)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
            }
        }
    }
    
    
    //MARK: - Api for Save Edit profile user
    //MARK: -
    func registerOfflinePaymentAPI(params: JSONDictionary, filePath:String, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ) {
        
        if filePath.isEmpty {
            AppNetworking.POST(endPoint: APIEndPoint.registerPayment, parameters: params, success: { [weak self] (json) in
                guard let sSelf = self else {return}
                
                sSelf.handleResponse(json, success: { (sucess, jsonData) in
                    completionBlock(true, [])
                    
                }, failure: { (errors) in
                    ATErrorManager.default.logError(forCodes: errors, fromModule: .profile)
                    completionBlock(false, errors)
                })
                
            }) { (error) in
                if error.code == AppNetworking.noInternetError.code {
                    completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue])
                }
                else {
                    completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
                }
            }
            
        } else {
            let exten = filePath.hasSuffix(".pdf") ? "pdf" : "jpeg"
            AppNetworking.POSTWithMultiPart(endPoint: APIEndPoint.registerPayment, parameters: params, multipartData: [(key: "deposit_slip", filePath:filePath, fileExtention: exten, fileType: AppNetworking.MultiPartFileType.image)], loader: false, success: { (data) in
                printDebug(data)
                completionBlock(true,[])
            }, progress: { (progress) in
            }) { (error) in
                if error.code == AppNetworking.noInternetError.code {
                    completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue])
                }
                else {
                    completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
                }
            }
        }
    }
}
