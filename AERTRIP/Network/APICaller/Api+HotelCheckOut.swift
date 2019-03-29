//
//  Api+HotelCheckOut.swift
//  AERTRIP
//
//  Created by Admin on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    
    func sendDashBoardEmailIDAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ successMessage: String)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.emailItineraries, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                completionBlock(sucess, [], jsonData[APIKeys.data.rawValue][APIKeys.msg.rawValue].stringValue)
                
            }, failure: { (errors) in
                completionBlock(false, errors, "")
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue], "")
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], "")
            }
        }
    }
    
    func getCouponDetailsApi(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ couponDetails : [HCCouponModel])->Void) {
        AppNetworking.POST(endPoint:APIEndPoint.getCoponDetails, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            printDebug(json)
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject , let couponsArray = response[APIKeys.coupons.rawValue] as? [JSONDictionary]  {
                    let couponDetails = HCCouponModel.getHCCouponData(jsonArr: couponsArray)
                    completionBlock(true, [], couponDetails)
                } else {
                    completionBlock(true, [], [])
                }
            }, failure:  { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors, [])
            })
        }) { (error) in
            completionBlock(false, [], [])
        }
    }
    

    func applyCoupnCodeApi(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ couponDetails : [HCCouponModel])->Void) {
        AppNetworking.POST(endPoint:APIEndPoint.applyCouponCode, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            printDebug(json)
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject , let couponsArray = response[APIKeys.coupons.rawValue] as? [JSONDictionary]  {
                    let couponDetails = HCCouponModel.getHCCouponData(jsonArr: couponsArray)
                    completionBlock(true, [], couponDetails)
                } else {
                    completionBlock(true, [], [])
                }
            }, failure:  { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors, [])
            })
        }) { (error) in
            completionBlock(false, [], [])
        }
    }
}
