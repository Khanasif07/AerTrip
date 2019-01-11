//
//  APICaller+Travellers.swift
//  AERTRIP
//
//  Created by apple on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    func callTravellerListAPI(loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ travellers: [TravellerModel]) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.travellerList, success: { [weak self] json in
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(json, success: { _, jsonData in
                   let array =  TravellerModel.models(json: jsonData[APIKeys.data.rawValue])
                
              //  let array = TravellerModel.filterByGroups(json: jsonData[APIKeys.data.rawValue])
                completionBlock(true, [], array)
                
            }, failure: { errors in
                completionBlock(false, errors, [])
            })
            
        }) { _ in
        }
    }
}
