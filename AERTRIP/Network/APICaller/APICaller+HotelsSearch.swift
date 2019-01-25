//
//  APICaller+HotelsSearch.swift
//  AERTRIP
//
//  Created by Admin on 23/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    
    //MARK: - Api for login user
    //MARK: -
    func getSearchedDestinationHotels(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ hotels: JSONDictionary)->Void ) {
        
        AppNetworking.GET(endPoint: APIEndPoint.searchDestinationHotels, parameters: params, success: { [weak self] (json) in
            
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess, let arr = jsonData[APIKeys.data.rawValue].arrayObject as? [JSONDictionary] {
                    let (hotels, types) =  SearchedDestination.models(jsonArr: arr)
                    
                    var dict: JSONDictionary = JSONDictionary()
                    
                    for type in types {
                        dict[type] = hotels.filter() {$0.dest_type == type}
                    }
                    
                    completionBlock(true, [], dict)
                }
                else {
                    completionBlock(false, [], [:])
                }
                
            }, failure: { (errors) in
                completionBlock(false, errors, [:])
            })
        }) { (error) in
            completionBlock(false, [], [:])
        }
    }
    
    
    func getPopularHotels(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ hotels: [SearchedDestination])->Void ) {
        
        let frameworkBundle = Bundle(for: PKCountryPicker.self)
        guard let jsonPath = frameworkBundle.path(forResource: "popular", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            return completionBlock(false, [], [])
        }
        
        do {
            if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? JSONDictionary {
                
                if let arr = jsonObjects[APIKeys.data.rawValue] as? [JSONDictionary] {
                    let (hotels, types) =  SearchedDestination.models(jsonArr: arr)
                    
                    completionBlock(true, [], hotels)
                }
                else {
                    completionBlock(false, [], [])
                }
            }
        }
        catch {
            completionBlock(false, [], [])
        }
    }
    
    func getHotelsNearByMe(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ hotels: JSONDictionary)->Void ) {
        
        AppNetworking.GET(endPoint: APIEndPoint.hotelsNearByMe, parameters: params, success: { [weak self] (json) in
            
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess, let arr = jsonData[APIKeys.data.rawValue].arrayObject as? [JSONDictionary] {
                    let (hotels, types) =  SearchedDestination.models(jsonArr: arr)
                    
                    var dict: JSONDictionary = JSONDictionary()
                    
                    for type in types {
                        dict[type] = hotels.filter() {$0.dest_type == type}
                    }
                    
                    completionBlock(true, [], dict)
                }
                else {
                    completionBlock(false, [], [:])
                }
                
            }, failure: { (errors) in
                completionBlock(false, errors, [:])
            })
        }) { (error) in
            completionBlock(false, [], [:])
        }
    }
}
