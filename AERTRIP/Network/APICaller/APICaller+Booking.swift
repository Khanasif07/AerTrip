//
//  APICaller+Booking.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    func getHotelInfo(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ hotel: HotelDetails?) -> Void) {
        let frameworkBundle = Bundle(for: PKCountryPicker.self)
        guard let jsonPath = frameworkBundle.path(forResource: "hotelData", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            return completionBlock(false, [], nil)
        }
        
        do {
            if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? JSONDictionary {
                if let hotelDetail = jsonObjects["data"] as? JSONDictionary {
                    let hotel = hotelDetail["results"] as? JSONDictionary
                    let hotelInfo = HotelDetails.hotelInfo(response: hotel!) as? HotelDetails
                    
                    completionBlock(true, [], hotelInfo)
                }
                else {
                    completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
                }
            }
        }
        catch {
            completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
        }
    }
    
    func getBookingList(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.bookingList, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject, let bookings = response["bookings"] as? [JSONDictionary] {
                    BookingData.insert(dataDictArray: bookings, completionBlock: { _ in
                        completionBlock(true, [])
                    })
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
    
    // MARK: - Booking detail
    
    func getBookingDetail(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ hotels: [HotelsSearched], _ done: Bool) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.getBookingDetails, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject, let hotels = response["results"] as? [JSONDictionary] {
                    let hotelsInfo = HotelsSearched.models(jsonArr: hotels)
                    let done = response["done"] as? Bool
                    let filters = response["filters"] as? JSONDictionary
                    HotelFilterVM.shared.minimumPrice = filters?["min_price"] as? Double ?? 0.0
                    HotelFilterVM.shared.maximumPrice = filters?["max_price"] as? Double ?? 0.0
                    HotelFilterVM.shared.leftRangePrice = HotelFilterVM.shared.minimumPrice
                    HotelFilterVM.shared.rightRangePrice = HotelFilterVM.shared.maximumPrice
                    HotelFilterVM.shared.defaultLeftRangePrice = HotelFilterVM.shared.minimumPrice
                    HotelFilterVM.shared.defaultRightRangePrice = HotelFilterVM.shared.maximumPrice
                    
                    completionBlock(true, [], hotelsInfo, done ?? false)
                }
                else {
                    completionBlock(false, [], [], false)
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error, [], false)
            })
        }) { error in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue], [], false)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [], false)
            }
        }
    }
}
