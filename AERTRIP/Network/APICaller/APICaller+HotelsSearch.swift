//
//  APICaller+HotelsSearch.swift
//  AERTRIP
//
//  Created by Admin on 23/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    // MARK: - Api for login user
    
    // MARK: -
    
    func getSearchedDestinationHotels(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ hotels: JSONDictionary) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.searchDestinationHotels, parameters: params, success: { [weak self] json in
            
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let arr = jsonData[APIKeys.data.rawValue].arrayObject as? [JSONDictionary] {
                    let (hotels, types) = SearchedDestination.models(jsonArr: arr)
                    
                    var dict: JSONDictionary = JSONDictionary()
                    
                    for type in types {
                        dict[type] = hotels.filter { $0.dest_type == type }
                    }
                    
                    completionBlock(true, [], dict)
                }
                else {
                    completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [:])
                }
                
            }, failure: { errors in
                completionBlock(false, errors, [:])
            })
        }) { error in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue], [:])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [:])
            }
        }
    }
    
    func getPopularHotels(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ hotels: [SearchedDestination]) -> Void) {
//        let frameworkBundle = Bundle(for: PKCountryPicker.self)
//        guard let jsonPath = frameworkBundle.path(forResource: "popular", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
//            return completionBlock(false, [], [])
//        }
//
//        do {
//            if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? JSONDictionary {
//
//                if let arr = jsonObjects[APIKeys.data.rawValue] as? [JSONDictionary] {
//                    let (hotels, _) =  SearchedDestination.models(jsonArr: arr)
//
//                    completionBlock(true, [], hotels)
//                }
//                else {
//                    completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [])
//                }
//            }
//        }
//        catch {
//            completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [])
//        }
        AppNetworking.GET(endPoint: APIEndPoint.searchDestinationHotels, parameters: params, success: { [weak self] json in
            
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let arr = jsonData[APIKeys.data.rawValue].arrayObject as? [JSONDictionary] {
                    let (hotels, _) = SearchedDestination.models(jsonArr: arr)
                    completionBlock(true, [], hotels)
                }
                else {
                    completionBlock(false, [], [])
                }
                
            }, failure: { errors in
                completionBlock(false, errors, [])
            })
        }) { _ in
            completionBlock(false, [], [])
        }
    }
    
    func getHotelsNearByMe(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ hotels: SearchedDestination?) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.hotelsNearByMeLocations, parameters: params, success: { [weak self] json in
            
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let arr = jsonData[APIKeys.data.rawValue].arrayObject as? [JSONDictionary] {
                    let (hotels, _) = SearchedDestination.models(jsonArr: arr)
                    completionBlock(true, [], hotels.first)
                }
                else {
                    completionBlock(false, [], nil)
                }
                
            }, failure: { errors in
                completionBlock(false, errors, nil)
            })
        }) { _ in
            completionBlock(false, [], nil)
        }
    }
    
    func getHotelsListOnPreference(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ sid: String, _ vCodes: [String],_ hotelSearchRequst : HotelSearchRequestModel?) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.hotelListOnPreferenceL, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let reponse = jsonData[APIKeys.data.rawValue].arrayObject, let first = reponse.first as? JSONDictionary, let sid = first["sid"] as? String, let vCodes = first["vcodes"] as? [String] {
                    let hotelSearchRequst = HotelSearchRequestModel(json: jsonData[APIKeys.data.rawValue].arrayValue.first ?? "")
                    completionBlock(true, [], sid, vCodes,hotelSearchRequst)
                }
                else {
                    completionBlock(false, [], "", [""],nil)
                }
            }, failure: { errors in
                completionBlock(false, errors, "", [""],nil)
            })
        }) { _ in
            completionBlock(false, [], "", [""],nil)
        }
    }
    
    func getHotelsListOnPreferenceResult(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ hotels: [HotelsSearched], _ done: Bool) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.hotelListOnPreferenceResult, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject, let hotels = response["results"] as? [JSONDictionary] {
                    let hotelsInfo = HotelsSearched.models(jsonArr: hotels)
                    let done = response["done"] as? Bool
                    let filters = response["filters"] as? JSONDictionary
                    HotelFilterVM.shared.minimumPrice = filters?["min_price"] as? Double ?? 0.0
                    HotelFilterVM.shared.maximumPrice = filters?["max_price"] as? Double ?? 0.0
                    completionBlock(true, [], hotelsInfo,done ?? false)
                }
                else {
                    completionBlock(false, [], [],false)
                }
            }, failure: { _ in
                completionBlock(false, [], [],false)
            })
        }) { _ in
            completionBlock(false, [], [],false)
        }
    }
    
    func bulkBookingEnquiryApi(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ enquiryId: String)->Void) {
        AppNetworking.POST(endPoint: APIEndPoint.hotelBulkBooking, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            printDebug(json)
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject, let enquiryId = response["enquiry_id"] as? String {
                    
                    completionBlock(true, [], enquiryId)
                } else {
                    completionBlock(true, [], "")
                }
            }, failure:  { (errors) in
                completionBlock(false, errors, "")
            })
        }) { (error) in
            completionBlock(false, [], "")
        }
    }
}
