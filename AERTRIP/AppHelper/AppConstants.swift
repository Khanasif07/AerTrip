//
//  AppConstants.swift
//
//
//  Created by Pramod Kumar on 28/07/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//

import Foundation

enum AppConstants {
    static let isReleasingToClient: Bool = false
    
    static let kCurrency = ""
    
    static let kAppName = "Aertrip"
    static let kGoogleClientID = ""
    static let kGoogleUrlScheme = ""
    static let kGoogleApiKey = ""
    static let kFacebookAppID = ""
    static let kMe = "Me"
    
    static let kOtpLength = 6
    static let kMinTextFieldCharLength = 2
    static let kMaxTextFieldCharLength = 32
    static let kMinPassLength = 6
    static let kMaxPassLength = 32
    static let kMinPhoneLength: Int = 7
    static let kMaxPhoneLength: Int = 15
    static let kOtpTimeOutSeconds = 60
    static let kMaxDescriptionLength = 250
    
    static let fbUrl = "fb1080161318756977"
    static let googleUrl = "com.googleusercontent.apps.175392921069-agcdbrcffqcbhl1cbeatvjafd35335gm"
    static let linkedIn_Client_Id = "81zznun7zyml11"
    static let linkedIn_ClientSecret = "B4ELw2GOTv5tcnPA"
    static let linkedIn_States = "linkedin\(Int(NSDate().timeIntervalSince1970))"
    static let linkedIn_Permissions = ["r_basicprofile", "r_emailaddress"]
    static let linkedIn_redirectUri = "http://beta.aertrip.com/api/v1/linkedin/linksocial"
    static let privacyPolicy = "https://beta.aertrip.com/privacy"
    static let termsOfUse = "https://beta.aertrip.com/terms"
    static let fareRules = "https://beta.aertrip.com/terms"
    static let walletAmountUrl = "https://beta.aertrip.com/wallet"
    
    static let kSearchTextLimit = 3
    static let kNameTextLimit = 30
    static let kAnimationDuration = 0.4
    static let kFirstLastNameTextLimit = 30 // On Guest detail VC
    static let kEmailIdTextLimit = 40
    static let kPassportNoLimit = 30
    static let kMaximumGroupNameCount = 30
    static let kIndianIsdCode = "+91"
    static let kEllipses = "..."
    static let kMaxTextLimit = 256 // max limit for special request and preferred hotels
    
    static var isStatusBarBlured = true
    
    static let kGoogleAPIKey = "AIzaSyD_W5hNOfKdR3xbEEkbX1rI2sJ3nDv1E64" // "AIzaSyBR5AMB7FJUqlRBZv93B4aVhY-Xt13weaU"
    static let kRuppeeSymbol = "\u{20B9} "
    static let kCopyrightSymbol = "\u{00A9}"
    
    // razor pay key
    static let kRazorpayPublicKey = "rzp_test_QJYU8TtB6deJgb"
    
    // CellIdentifier
    
    static let ktableViewHeaderViewIdentifier = "ViewProfileDetailTableViewSectionView"
}
