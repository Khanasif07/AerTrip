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
    case baseUrlPath  = "https://beta.aertrip.com/api/v1/"

    //MARK: - Account URLs -
    case isActiveUser       = "users/is-active-user"
    case login              = "users/login"
    case logout             = "users/logout/"
    case socialLogin        = "social/app-social-login"
    case register           = "users/register"
    case emailAvailability  = "users/email-availability"
    case forgotPassword     = "users/reset-password"
    case updateUserDetail   = "users/initial-details"
    case updateUserPassword = "users/update-password"
    case verifyRegistration = "users/verify-registration"
    case resetPassword         = "users/validate-password-reset-token"
    case getTravellerDetail = "users/traveller-detail"

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
