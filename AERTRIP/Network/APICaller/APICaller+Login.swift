//
//  APICaller.swift
//  
//
//  Created by Pramod Kumar on 11/05/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    
    //MARK: - Used to validate the user for giving the acces to application
    func callLoginAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ message: String)->Void ) {
        AppNetworking.PUT(endPoint: APIEndPoint.login, parameters: params, loader: loader, success: { [weak self](data) in
            guard let sSelf = self else {return}
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, jsonData[""].stringValue)
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription)
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription)
        }
    }
}
