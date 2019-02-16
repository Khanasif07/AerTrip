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
    
    func getHotelDetails(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ hotels: HotelDetails?) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.hotelInfo, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject, let hotel = response["results"] as? JSONDictionary {
                    let hotelInfo = HotelDetails.hotelInfo(response: hotel)
                    completionBlock(true, [], hotelInfo)
                }
                else {
                    completionBlock(false, [], nil)
                }
            }, failure: { _ in
                completionBlock(false, [], nil )
            })
        }) { _ in
            completionBlock(false, [], nil )
        }
    }
}
