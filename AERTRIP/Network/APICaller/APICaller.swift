//
//  APICaller.swift
//  
//
//  Created by Pramod Kumar on 11/05/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

class APICaller {
    
    //webservice complition clouser, will call for success and failure both
    internal typealias complitionClosure = ((_ success : Bool, _ JSON : JSON) -> Void)
    internal typealias failureClosure = ((_ errors: [Int]) -> Void)
    
    static let shared = APICaller()
    
    private init() {}
    
    //Common handler/parser for all webservices response
    func handleResponse(_ response: JSON, success: complitionClosure, failure: failureClosure) {
        
        if response[APIKeys.success.rawValue].boolValue {
            //Success Handling
            success(response[APIKeys.success.rawValue].boolValue, response)
        }
        else {
            failure(response[APIKeys.errors.rawValue].arrayObject as? ErrorCodes ?? [])
        }
    }
}
