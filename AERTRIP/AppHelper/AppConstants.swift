//
//  AppConstants.swift
//  
//
//  Created by Pramod Kumar on 28/07/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//

import Foundation

enum AppConstants {
    
    static let kCurrency = ""

    static let kAppName                     = "AERTRIP"
    static let kGoogleClientID              = ""
    static let kGoogleUrlScheme             = ""
    static let kGoogleApiKey                = ""
    static let kFacebookAppID               = ""
    
    static let kOtpLength                   =         6
    static let kMinTextFieldCharLength               =         2
    static let kMaxTextFieldCharLength               =         32
    static let kMinPassLength              =         6
    static let kMaxPassLength              =         32
    static let kMinPhoneLength             =         7
    static let kMaxPhoneLength             =         15
    static let kOtpTimeOutSeconds          =         60
    static let kMaxDescriptionLength       =         250
    
    static let fbUrl = "fb329235157662435"
    static let googleUrl = "com.googleusercontent.apps.13350074803-jnf88no6vp1qpo3np3bveti5nqrdm51i"
    static let linkedIn_Client_Id = "78nutigh7qtc48"
    static let linkedIn_ClientSecret = "zIDH0nPzW7YT4bit"
    static let linkedIn_States = "linkedin\(Int(NSDate().timeIntervalSince1970))"
    static let linkedIn_Permissions = ["r_basicprofile", "r_emailaddress"]
    static let linkedIn_redirectUri = "https://com.aertrip.linkedin.oauth/oauth"
    
}
