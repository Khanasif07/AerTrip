//
//  APICaller+ViewProfile.swift
//  AERTRIP
//
//  Created by apple on 19/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    //MARK: - Api for travel detail
    
    func getTravelDetail(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ data: TravelDetailModel?, _ errorCodes: ErrorCodes)->Void ) {
        
        
        AppNetworking.GET(endPoint: .getTravellerDetail, parameters: params, loader: loader, success: { [weak self] (data) in
            
            
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                printDebug(jsonData)
                let data = TravelDetailModel(json: jsonData[APIKeys.data.rawValue])
                completionBlock(true, data, [])
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .profile)
                completionBlock(false, nil, errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, nil, [])
            }
            else {
                completionBlock(false, nil, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    func callLogOutAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.POST(endPoint: APIEndPoint.logout, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(json, success: { _, jsonData in
                
                completionBlock(true, [])
                
                //remove Previos Search Form Data
                HotelsSearchVM.hotelFormData = HotelFormPreviosSearchData()
                
            }, failure: { errors in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .profile)
                completionBlock(false, errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    func getAccountSummaryAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes) -> Void) {
            AppNetworking.GET(endPoint: APIEndPoint.accountsummary, parameters: params, success: { [weak self] json in
                guard let sSelf = self else { return }
                printDebug(json)
                sSelf.handleResponse(json, success: { sucess, jsonData in
                    if sucess {
                        if let acc = jsonData["data"].dictionaryObject {
                            //if there is account data then save it
                            UserInfo.loggedInUser?.accountData = AccountModel(json: acc)
                        }
                        completionBlock(true, [])
                    }
                    else {
                        completionBlock(false, [])
                    }
                }, failure: { error in
                    ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                    completionBlock(false,error)
                })
            }) { (error) in
                if error.code == AppNetworking.noInternetError.code {
                    AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                    completionBlock(false,[])
                }
                else {
                    completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
                }
            }
        }
}
