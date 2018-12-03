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
    case apiKey                =       "asas"
    case baseUrlPath           =       "http://bananidev.appskeeper.com/api/v1/"

    //MARK: - Account URLs -
    case login                  =       "Account/Login"
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
