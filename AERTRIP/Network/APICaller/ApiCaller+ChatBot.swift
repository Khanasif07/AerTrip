//
//  ApiCaller+ChatBot.swift
//  AERTRIP
//
//  Created by Appinventiv on 27/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {

    func startChatBotSession(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: MessageModel?, _ sessionId : String) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.chatBotStart, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in

                if sucess {
                    completionBlock(true, MessageModel(json: jsonData[APIKeys.data.rawValue]),jsonData[APIKeys.data.rawValue][APIKeys.session_id.rawValue].stringValue)
                }else{
                    completionBlock(false,nil,"")
                }
                
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .chatBot)
                
                completionBlock(false,nil,"")
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
//                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, nil,"")
            }
            else {
                completionBlock(false, nil,"")
            }
        }
    }
    
    
        func communicateWithChatBot(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: MessageModel?, _ sessionId : String) -> Void) {
            AppNetworking.GET(endPoint: APIEndPoint.chatBotStart, parameters: params, success: { [weak self] json in
                guard let sSelf = self else { return }
                printDebug(json)
                sSelf.handleResponse(json, success: { sucess, jsonData in

                    if sucess {
                        
                        print("jsonData...\(jsonData)")
                        
                        completionBlock(true, MessageModel(json: jsonData[APIKeys.data.rawValue]),jsonData[APIKeys.data.rawValue][APIKeys.session_id.rawValue].stringValue)
                    }else{
                        completionBlock(false,nil,"")
                    }
                    
                }, failure: { error in
                    ATErrorManager.default.logError(forCodes: error, fromModule: .chatBot)
                    
                    completionBlock(false,nil,"")
                })
            }) { (error) in
                if error.code == AppNetworking.noInternetError.code {
    //                AppGlobals.shared.stopLoading()
                    AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                    completionBlock(false, nil,"")
                }
                else {
                    completionBlock(false, nil,"")
                }
            }
        }
    
    func recentSearchesApi(searchFor : ChatVM.RecentSearchFor, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ recentSearchesData: [RecentSearchesModel]) -> Void) {
        let endPoints = "https://beta.aertrip.com/api/v1/recent-search/get?product=\(searchFor.rawValue)"
        AppNetworking.GET(endPoint: endPoints, loader: loader, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
            
                if sucess, let response = jsonData[APIKeys.data.rawValue][APIKeys.search.rawValue].arrayObject as? JSONDictionaryArray {
                    let recentSearchesData = RecentSearchesModel.recentSearchDataWithType(type: searchFor, jsonArr: response)
                    completionBlock(true, [], recentSearchesData)
                }
            }, failure: { errors in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors, [])
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], [])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [])
            }
        }
    }
    
}
