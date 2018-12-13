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
    
    static let fbUrl = "fb2150155951662059"
    static let googleUrl = "com.googleusercontent.apps.175392921069-agcdbrcffqcbhl1cbeatvjafd35335gm"
    static let linkedIn_Client_Id = "81zznun7zyml11"
    static let linkedIn_ClientSecret = "B4ELw2GOTv5tcnPA"
    static let linkedIn_States = "linkedin\(Int(NSDate().timeIntervalSince1970))"
    static let linkedIn_Permissions = ["r_basicprofile", "r_emailaddress"]
    static let linkedIn_redirectUri = "http://beta.aertrip.com/api/v1/linkedin/linksocial"
    
}
