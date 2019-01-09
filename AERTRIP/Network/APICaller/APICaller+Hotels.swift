//
//  APICaller+Hotels.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 02/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    
    //MARK: - Api for login user
    //MARK: -
    func getHotelPreferenceList(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ city: [CityHotels], _ stars: [Int])->Void ) {
        
        AppNetworking.GET(endPoint: APIEndPoint.hotelPreferenceList, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    let array =  CityHotels.models(json: jsonData[APIKeys.data.rawValue][APIKeys.hotels.rawValue])
                    var stars: [Int] = []
                    if let arr = jsonData[APIKeys.data.rawValue][APIKeys.stars.rawValue].arrayObject {
                        stars = arr.map({ (item) -> Int in
                            "\(item)".toInt ?? 0
                        })
                    }
                    if stars.contains(0) {
                        stars.remove(at: stars.firstIndex(of: 0)!)
                    }
                    completionBlock(true, [], array, stars)
                }
                else {
                    completionBlock(false, [], [], [])
                }
                
            }, failure: { (errors) in
                completionBlock(false, errors, [], [])
            })
        }) { (error) in
            completionBlock(false, [], [], [])
        }
    }
    
    func getHotelsByStarPreference(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ city: [CityHotels])->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.hotelStarPreference, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    completionBlock(true, [], [])
                }
                else {
                    completionBlock(false, [], [])
                }
                
            }, failure: { (errors) in
                completionBlock(false, errors, [])
            })
        }) { (error) in
            completionBlock(false, [], [])
        }
    }
    
    func callSearchHotelsAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ hotels: [HotelsModel])->Void ) {
        
        AppNetworking.GET(endPoint: APIEndPoint.searchHotels, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    let array =  HotelsModel.models(json: jsonData[APIKeys.data.rawValue])
                    completionBlock(true, [], array)
                }
                else {
                    completionBlock(false, [], [])
                }
                
            }, failure: { (errors) in
                completionBlock(false, errors, [])
            })
            
        }) { (error) in
            completionBlock(false, [], [])
        }
    }
    
    func callUpdateFavouriteAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ successMessage: String)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.favourite, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                completionBlock(sucess, [], jsonData[APIKeys.data.rawValue][APIKeys.msg.rawValue].stringValue)
                
            }, failure: { (errors) in
                completionBlock(false, errors, "")
            })
        }) { (error) in
            completionBlock(false, [], "")
        }
    }
}
