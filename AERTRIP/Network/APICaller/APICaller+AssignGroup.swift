//
//  APICaller+AssignGroup.swift
//  AERTRIP
//
//  Created by apple on 14/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    func callAssignGroupAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.POST(endPoint: APIEndPoint.assignGroup, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(json, success: { _, _ in
                
                completionBlock(true, [])
                
            }, failure: { errors in
                completionBlock(false, errors)
            })
            
        }) { error in
            print(error)
        }
    }
}
