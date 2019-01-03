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
    func getHotelPreferenceList(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ city: [CityHotels])->Void ) {
        
        AppNetworking.GET(endPoint: APIEndPoint.hotelPreferenceList, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                
              let array =  CityHotels.models(json: jsonData[APIKeys.data.rawValue][APIKeys.hotels.rawValue])
                
                completionBlock(true, [], array)
                
            }, failure: { (errors) in
                completionBlock(false, errors, [])
            })
            
        }) { (error) in
        }
    }
}
