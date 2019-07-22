//
//  APICaller+HotelInfo.swift
//  AERTRIP
//
//  Created by Admin on 14/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    //hotelInfo
    
    func getHotelDetails(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ hotels: HotelDetails?,_ currencyPref: String) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.hotelInfo, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject, let hotel = response["results"] as? JSONDictionary, let currencyPref = response[APIKeys.currencyPref.rawValue] as? String {
                    let hotelInfo = HotelDetails.hotelInfo(response: hotel)
                    completionBlock(true, [], hotelInfo, currencyPref)
                }
                else {
                    completionBlock(false, [], nil, "")
                }
            }, failure: { errors in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors, nil, "" )
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], nil, "")
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil, "")
            }
        }
    }
    //
    
    func getHotelDistanceAndTravelTime (originLat: String,originLong: String , destinationLat: String, destinationLong : String, mode: String, completionBlock: @escaping (_ success: Bool, _ response: PlaceModel?) -> Void) {
        let endPoint = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originLat),\(originLong)&destination=\(destinationLat),\(destinationLong)&travelMode=\(mode)&key=\(AppConstants.kGoogleAPIKey)&sensor=false"
        AppNetworking.POSTWithString (endPoint: endPoint, success: { (json) in
            if let data = json[APIKeys.routes.rawValue].arrayObject as? JSONDictionaryArray, let routes = data.first, let legs = routes[APIKeys.legs.rawValue] as? JSONDictionaryArray , let finalRouteData = legs.first {
                let placeData = PlaceModel.placeInfo(response: finalRouteData)
                printDebug(placeData)
                completionBlock(true, placeData)
            } else {
                completionBlock(false, nil)
            }
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, nil)
            }
            else {
                completionBlock(false, nil)
            }
        }
    }
    
    func getHotelTripAdvisorDetailsApi(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ hotelTripAdvisorDetails: HotelDetailsReviewsModel?)->Void) {
        AppNetworking.POST(endPoint: APIEndPoint.hotelReviews, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            printDebug(json)
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject {
                    let hotelInfo = HotelDetailsReviewsModel.hotelDetailsReviews(response: response)
                    completionBlock(true, [], hotelInfo)
                } else {
                    completionBlock(true, [], nil)
                }
            }, failure:  { (errors) in
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
