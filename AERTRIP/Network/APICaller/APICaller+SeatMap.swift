//
//  APICaller+SeatMap.swift
//  AERTRIP
//
//  Created by Rishabh on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    
    //MARK: - Api for Active user
    //MARK: -
    func callSeatMapAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.GET(endPoint: "https://aertrip.com/api/v1/flights/seat-map-list?sid=171798ca90e61f34e3848a6dc950f1db&fk%5B%5D=b09d6f4f6a6fd858f4e0f276eeea65e4~b388011e6906387f2ed22de7b54270ef&it_id=5ecbc7769e795e65252a26a1", parameters: params, loader: loader, success: { [weak self] (data) in
            guard let self = self else {return}
            
            self.handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, [])
                
            }, failure: { (error) in
                
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                
            }
        }
    }
}
