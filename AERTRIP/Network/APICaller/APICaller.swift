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
    internal typealias failureClosure = ((_ error : NSError) -> Void)
    
    static let shared = APICaller()
    
    private init() {}
    
    //Common handler/parser for all webservices response
    func handleResponse(_ response: JSON, success: complitionClosure, failure: failureClosure) {
        
        if response["error_code"].intValue == AppErrorCodeFor.success {
            //Success Handling
            success(true, response)
        }
        else if response["error_code"].intValue == AppErrorCodeFor.authenticationFailed {
            //logout the user forcely and send user to home screen.
            
            //delete all logged in user data
            //logout the user
        }
        else if !response["error_code"].stringValue.isEmpty {
            //Handling for other cases
            let errorstr = response["errorstr"].string ?? response["error_string"].stringValue
            //let err = NSError(domain: errorstr, code: status, userInfo: [:])
            let err = NSError(domain: errorstr, code: response["error_code"].intValue, userInfo: [:])
            failure(err)
        }
    }
}
