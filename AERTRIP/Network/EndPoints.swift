//
//  EndPoints.swift
//  
//
//  Created by Pramod Kumar on 17/07/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//

import Foundation

enum APIEndPoint : String {
    
    //MARK: - Base URLs
    case apiKey       = "3a457a74be76d6c3603059b559f6addf"
    case baseUrlPath  = "https://beta.aertrip.com/api/v1/users/"

    //MARK: - Account URLs -
    case isActiveUser       = "is-active-user"
    case login              = "login"
    case logout             = "logout/"
    case socialLogin        = "app-social-login"
    case register           = "register"
    case emailAvailability  = "email-availability"
    case forgotPassword     = "reset-password"
    case updateUserDetail   = "initial-details"
    case updateUserPassword = "update-password"
    case verifyRegistration = "verify-registration"
}

//MARK: - endpoint extension for url -
extension APIEndPoint {
    
    var path: String {
        
        switch self {
        case .baseUrlPath:
            return self.rawValue
        default:
            let tmpString = "\(APIEndPoint.baseUrlPath.rawValue)\(self.rawValue)"
            return tmpString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        }
    }
}
