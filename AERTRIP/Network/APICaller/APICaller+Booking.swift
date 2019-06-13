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
    
    func getBookingDetail(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes,_ bookingDetailModel: BookingDetailModel?) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.getBookingDetails, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject{
                let data = BookingDetailModel(json: response)
                    completionBlock(true, [], data)
                }
                else {
                    completionBlock(false, [],nil)
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error,nil)
            })
        }) { error in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue],nil)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue],nil)
            }
        }
    }
    
    func getBookingFees(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes,_ bookingFeeDetail: BookingFeeDetail?) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.getBookingFees, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject{
                    let data = BookingFeeDetail(json: response)
                    completionBlock(true, [], data)
                }
                else {
                    completionBlock(false, [],nil)
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error,nil)
            })
        }) { error in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue],nil)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue],nil)
            }
        }
    }
}
