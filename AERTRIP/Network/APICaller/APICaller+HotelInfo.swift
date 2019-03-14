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
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject, let hotel = response["results"] as? JSONDictionary, let currencyPref = response[APIKeys.currency_pref.rawValue] as? String {
                    let hotelInfo = HotelDetails.hotelInfo(response: hotel)
                    completionBlock(true, [], hotelInfo, currencyPref)
                }
                else {
                    completionBlock(false, [], nil, "")
                }
            }, failure: { _ in
                completionBlock(false, [], nil, "" )
            })
        }) { _ in
            completionBlock(false, [], nil, "" )
        }
    }
    //
    
    func getHotelDistanceAndTravelTime (originLat: String,originLong: String , destinationLat: String, destinationLong : String, mode: String, completionBlock: @escaping (_ success: Bool, _ response: PlaceModel?) -> Void) {
        let endPoint = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originLat),\(originLong)&destination=\(destinationLat),\(destinationLong)&travelMode=\(mode)&key=AIzaSyApXSYHgVAgLeXfWp6EbSai71dp7hxUulE&sensor=false"
        AppNetworking.POSTWithString (endPoint: endPoint, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                printDebug(jsonData)
                if sucess, let data = jsonData[APIKeys.routes.rawValue].arrayObject as? JSONDictionaryArray, let routes = data.first {
                    let placeData = PlaceModel.placeInfo(response: routes)
                    printDebug(placeData)
                    completionBlock(true, placeData)
                }
                else {
                    completionBlock(false, nil)
                }
            }, failure: { (errors) in
                completionBlock(false, nil)
            })
        }) { (error) in
            printDebug(error)
            completionBlock(false, nil)
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
                completionBlock(false, errors, nil)
            })
        }) { (error) in
            completionBlock(false, [], nil)
        }
    }
}
