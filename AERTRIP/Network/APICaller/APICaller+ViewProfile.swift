//
//  APICaller+ViewProfile.swift
//  AERTRIP
//
//  Created by apple on 19/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    //MARK: - Api for travel detail
    
    func getTravelDetail(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ data: TravelDetailModel?, _ errorCodes: ErrorCodes)->Void ) {
        
        
        AppNetworking.GET(endPoint: .getTravellerDetail, parameters: params, loader: loader, success: { [weak self] (data) in
            
            
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                
                let data = TravelDetailModel(json: jsonData[APIKeys.data.rawValue])
                completionBlock(true, data, [])
                
            }, failure: { (errors) in
                completionBlock(false, nil, errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, nil, [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, nil, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
}
