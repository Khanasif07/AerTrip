//
//  AppKeys.swift
//  
//
//  Created by Pramod Kumar on 15/05/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

typealias ErrorCodes = [Int]

enum APIKeys: String {
    
    //MARK:- Common Used
    case key
    case value
    case success
    case errors
    case status
    
    //MARK:- Login Module
    //MARK:-
    case isLoggedIn
    case data
    case loginid     = "loginid"
    case password    = "password"
    case isGuestUser = "isGuestUser"
    case id          = "id"
    case userName    = "username"
    case firstName   = "first_name"
    case lastName    = "last_name"
    case authKey     = "authKey"
    case email       = "email"
    case picture     = "picture"
    case gender      = "gender"
    case service = "service"
    case dob     = "dob"
    case permissions    = "permissions"
    case login = "login"
    case ref   = "ref"
    case isd   = "isd"
    case country    = "country"
    case salutation = "salutation"
    case facebook   = "facebook"
    case google     = "google"
    case linkedin   = "linkedin"
    case token
    case paxId = "pax_id"
    
}


