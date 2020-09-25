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
    static var decimalSymbol:String{return Locale.current.decimalSeparator ?? "."}
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
    static let tripsUrl = "https://aertrip.com/trips"

    static let kSearchTextLimit = 3
    static let kNameTextLimit = 30
    static let kAnimationDuration = 0.4
    static let kCloseAnimationDuration = 0.2
    static let kFirstLastNameTextLimit = 30 // On Guest detail VC
    static let kEmailIdTextLimit = 40
    static let kPassportNoLimit = 30
    static let kMaximumGroupNameCount = 30
    static let kIndianIsdCode = "+91"
    static let kEllipses = "..."
    static let kMaxTextLimit = 256 // max limit for special request and preferred hotels
    
    static var isStatusBarBlured = true
    static let AddOnRequestTextLimit = 60
    static let AbortRequestTextLimit = 500

    static let OnlineDepositeAmountLimit: Double = 1050000 //10,50,000 in online (bcoz of Convenience fee)
    static let OfflineDepositeAmountLimit: Double = 999999999 //99,99,99,999

    
    static let profileViewBackgroundNameIntialsFont = AppFonts.Regular.withSize(40.0)
    
    static let kGoogleAPIKey = "AIzaSyD_W5hNOfKdR3xbEEkbX1rI2sJ3nDv1E64" // "AIzaSyBR5AMB7FJUqlRBZv93B4aVhY-Xt13weaU"
    static let kRuppeeSymbol = "\u{20B9} "
    static let kCopyrightSymbol = "\u{00A9}"
    
    // razor pay key
    static let kRazorpayPublicKey = "rzp_test_QJYU8TtB6deJgb"
    
    // CellIdentifier
    
    static let ktableViewHeaderViewIdentifier = "ViewProfileDetailTableViewSectionView"
    
    
    static let dummyTextPdfLink = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
    static let kPending = "pending"
    static let kBooked = "(Booked)"
    static let PNR = "PNR"
    
    static let kfareInfoNotes: [String] = ["Some fares may be non-refundable and non-amendable.",
                                   "Cancellation / Rescheduling Charges are indicative and can change without prior notice. Aertrip does not guarantee or warrant this information.",
                                   "They may be subject to currency fluctuations.",
                                   "They need to be reconfirmed prior to any amendments or cancellation.",
                                   "Total Rescheduling Charges also include Fare Difference (if applicable)",
                                   "Airlines stop accepting cancellation/rescheduling requests 3 - 75 hours before departure of the flight, depending on the airline.",
                                   "For confirming cancellation/change fee, please call us at our customer care."
    ]
    
    static let kfareInfoDisclamer: [String] = ["Airlines stop accepting cancellation/rescheduling requests 3 - 75 hours before departure of the flight, depending on the airline, fare basis and booking fare policy.",
                                       "In case of restricted fares, no amendments/cancellation may be allowed.",
                                       "In case of combo fares or round-trip special fares, cancellation or change of only onward journey is not allowed. Cancellation or change of future sectors is allowed only if previous sectors are flown.",
                                       "Airline Cancellation/Rescheduling Charges needs to be reconfirmed prior to any amendments or cancellation.","Cancellation/Rescheduling Charges are indicative, subject to currency fluctuations and can change without prior notice. Aertrip does not guarantee or warrant this information."]
    
    static let AdultPax = "ADT"
    static let kChildPax = "CHD"
    static let kInfantPax = "INF"
    static let kQuestionMark = "?"
    static let kIndianCountryCode = "IN"
    static let staticRoomTags: [String] = ["Sea view","Lake view","Deluxe","Suite","Parking","Lounge"]
    static let kBreakfast = "Breakfast"
    static let kRefundable = "Refundable"
    static let kAsteriskSymbol = "*"
    static let kmR = "Mr"
    static let kmS = "Ms"
    static let kmAST = "Mast"
    static let kmISS = "Miss"
    static let kmRS = "Mrs"
    static let kMaleSalutaion = ["Mr","Mast"]
    static let kFemaleSalutaion = ["Ms","Miss","Mrs"]
    
    static let kAppStoreLink = "https://itunes.apple.com/app/id\(1369238862)?action=write-review"

    
    static let airlineMasterBaseUrl = "http://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/"
    
    
    // color for aap theme gradient color
    static let appthemeGradientColors: [UIColor] = [AppColors.shadowBlue, AppColors.themeGreen] //AppColors.themeGreen
    // color for aap disable gradient color
    static let appthemeDisableGradientColors: [UIColor] = [AppColors.themeGray20, AppColors.themeGray20]

}



