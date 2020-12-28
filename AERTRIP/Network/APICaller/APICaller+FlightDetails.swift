//
//  APICaller+FlightDetails.swift
//  AERTRIP
//
//  Created by Appinventiv  on 10/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller{
    
    func getFlightbaggageDetails(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ data: JSONDictionary?, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.GET(endPoint: .flightDetails_Baggage, parameters: params,success: {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, baggageData) in
                completionBlock(data[APIKeys.data.rawValue].dictionaryObject, [])
            } failure: { (errorCode) in
                completionBlock(nil, errorCode)
            }
        }, successWithData: { _ in
//            print(data)
        },failure: { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(nil, [])
            }
            else {
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.default.message)
                completionBlock(nil, [])
            }
        })
    }
    
    
    func getOnTimePerformanceDetails(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ data: JSONDictionary?, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .flightDetails_OnTimePerformance, parameters: params, loader: loader) {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, baggageData) in
                completionBlock(data[APIKeys.data.rawValue].dictionaryObject, [])
            } failure: { (errorCode) in
                completionBlock(nil, errorCode)
            }
        } failure: { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(nil, [])
            }
            else {
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.default.message)
                completionBlock(nil, [])
            }
        }
    }
    
    func getFareInfo(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ data: JSONDictionary?, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .flightDetails_FareInfo, parameters: params, loader: loader) {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, baggageData) in
                completionBlock(data[APIKeys.data.rawValue].dictionaryObject, [])
            } failure: { (errorCode) in
                completionBlock(nil, errorCode)
            }
        } failure: { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(nil, [])
            }
            else {
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.default.message)
                completionBlock(nil, [])
            }
        }
    }

    
    func getFareRules(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ data: JSONDictionary?, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .flightDetails_FareRules, parameters: params, loader: loader) {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, baggageData) in
                completionBlock(data[APIKeys.data.rawValue].dictionaryObject, [])
            } failure: { (errorCode) in
                completionBlock(nil, errorCode)
            }
        } failure: { (error) in
        }
    }
    
    
    func getFlightPerformanceData(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ data: Data?, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .flightDetails_OnTimePerformance, parameters: params,success: {(_ _)in}, successWithData: { data in
            completionBlock(data, [])
        },failure: { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(nil, [])
            }
            else {
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.default.message)
                completionBlock(nil, [])
            }
        })
    }
    
    func getFlightFareInfo(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ data: Data?, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .flightDetails_FareInfo, parameters: params,success: {(_ _)in}, successWithData: { data in
            completionBlock(data, [])
        },failure: { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(nil, [])
            }
            else {
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.default.message)
                completionBlock(nil, [])
            }
        })
    }
    



    func getShortUrlForShare(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool,_ data: JSONDictionary?, _ errorCodes: ErrorCodes)->Void ){
        AppNetworking.POST(endPoint: .flights_getShortUrlForShare, parameters: params, loader: loader) {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, baggageData) in
//                completionBlock(data[APIKeys.data.rawValue].dictionaryObject, [])
                completionBlock(true,data[APIKeys.data.rawValue].dictionaryObject,[])
            } failure: { (errorCode) in
                completionBlock(false, nil, errorCode)
            }
        } failure: { (error) in
        }
    }
}
