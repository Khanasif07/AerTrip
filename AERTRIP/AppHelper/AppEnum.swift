//
//  AppEnum.swift
//
//
//  Created by Pramod Kumar on 24/09/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

enum ATNotification {
    case profileChanged
    case profileSavedOnServer
    case userLoggedInSuccess(JSON)
    case userAsGuest
    case GRNSessionExpired
    case accountPaymentRegister
    case myBookingFilterApplied
    case myBookingFilterCleared
    case myBookingSearching
    case myBookingCasesRequestStatusChanged
    case profileDetailUpdated
    case preferenceUpdated
    case travellerDeleted
    
    
}

extension Notification.Name {
    static let logOut = Notification.Name("logOut")
    static let dataChanged = Notification.Name("dataChanged")
    static let sessionExpired = Notification.Name("sessionExpired")
    static let bulkEnquirySent = Notification.Name("bulkEnquirySent")
    static let bookingFilterApplied = Notification.Name("bookingFilterApplied")
    static let checkoutSessionExpired = Notification.Name("checkoutSessionExpired")
    static let accountDetailFetched = Notification.Name("accountDetailFetched")
    static let bookingDetailFetched = Notification.Name("bookingDetailFetched")
    static let statusBarTouched = Notification.Name("statusBarTouched")

}

// MARK: - Applicaion Response Code From Server

// MARK: -

enum AppErrorCodeFor: Int {
    case success = 200
    case authenticationFailed = 402
    case noInternet = 600
    case parsing = 601
    case NotLoggedIn = -1
    case emailRequired = 1
    case invalidEmailFormat = 2
    case passwordIsRequired = 3
    case MultipleUserAccountsWithThisEmailId = 4
    case NoUserAccountWithThisEmailId = 5
    case userTypeNotMatched = 6
    case InvalidPassword = 7
    case userNotFound = 8
    case linkHasBeenExpired = 9
    case LinkAlreadyUsedToCreateAUser = 10
    case userIdRequired = 11
    case accountMasterIdRequired = 12
    case userTypeIdRequired = 13
    case userGroupIdRequired = 14
    case userTypeCodeRequired = 15
    case userMemberIdRequired = 16
    case membershipNumberRequired = 17
    case hashKeyIsRequired = 18
    case passengerIdRequired = 19
    case contactSourceIdRequired = 20
    case billingNameRequired = 21
    case billingAddressIdRequired = 22
    case creditTypeRequired = 23
    case defaultCountryRequired = 24
    case preferredCurrencyRequired = 25
    case refundModeRequired = 26
    case userAlreadyRegisterdWithThisEmailId = 27
    case emailActiveAsSocialUser = 28
    case userWithNoPasswordAndNotInSocial = 29
    case userAlreadyLoggedIn = 30
    case capchaAtemptsLimitOver = 31
    case guestLoginIsNotPermittedForThisUser = 32
    case somethingWentWrongPleaseTryAgain = 33
    case forMobileAppOnly = 34
    case failedToRegisterEmailChangeRequest = 35
    case TokenHasBeenExpired = 36
    case userAlreadyCreatedUsingThisLink = 37
    case failedToCreateAccountMaster = 38
    case failedToCreateUser = 39
    case passwordIsWeak = 40
    case newPasswordIsRequired = 41
    case unableToSetNewPassword = 42
    case tokenIsRequired = 43
    case invalidToken = 44
    case passowrdHasAlreadyBeenResetUsingThisLink = 45
    case failedToResetPassword = 46
    case modeIsRequired = 58
    //    case failedToRegisterEmailChangeRequest = 59
    case thePreviousEnquiryForThisEmailIdWasREJECTEDBYCSR = 88
    case failedToUpdateStatusOfCorpEnquiry = 89
    case SomethingWentWrong = 90
    case failedToSendRegistrationEmail = 91
    case youHaveExceededMaximumAttemptsToResetPassword = 106
    case noUserAccountWithThisEmailId = 117
    case user_Not_Found = 116
    case user_type_not_matched = 115
    
    var message: String {
        switch self {
        case .success:
            return ""
            
        case .authenticationFailed:
            return ""
            
        case .noInternet:
            return LocalizedString.NoInternet.localized
            
        case .parsing:
            return LocalizedString.ParsingError.localized
            
        case .NotLoggedIn:
            return LocalizedString.notLoggedIn.localized
            
        case .emailRequired:
            return LocalizedString.emailRequired.localized
            
        case .invalidEmailFormat:
            return LocalizedString.invalidEmail.localized
            
        case .passwordIsRequired:
            return LocalizedString.passwordRequired.localized
            
        case .MultipleUserAccountsWithThisEmailId:
            return LocalizedString.multipleAccountWithEmail.localized
            
        case .NoUserAccountWithThisEmailId:
            return LocalizedString.incorrectEmailPassword.localized
            
        case .userTypeNotMatched:
            return LocalizedString.incorrectEmailPassword.localized
            
        case .InvalidPassword:
            return LocalizedString.incorrectEmailPassword.localized
            
        case .userNotFound:
            return LocalizedString.incorrectEmailPassword.localized
            
        case .linkHasBeenExpired:
            return LocalizedString.linkExpired.localized
            
        case .LinkAlreadyUsedToCreateAUser:
            return LocalizedString.linkUsedToCreateUser.localized
            
        case .userIdRequired:
            return LocalizedString.userNotFound.localized
            
        case .accountMasterIdRequired:
            return LocalizedString.invalidUserData.localized
            
        case .userTypeIdRequired:
            return LocalizedString.invalidUserData.localized
            
        case .userGroupIdRequired:
            return LocalizedString.invalidUserData.localized
            
        case .userTypeCodeRequired:
            return LocalizedString.invalidUserData.localized
            
        case .userMemberIdRequired:
            return LocalizedString.invalidUserData.localized
            
        case .membershipNumberRequired:
            return LocalizedString.invalidUserData.localized
            
        case .hashKeyIsRequired:
            return LocalizedString.provideValidHashKey.localized
            
        case .passengerIdRequired:
            return LocalizedString.invalidUserData.localized
            
        case .contactSourceIdRequired:
            return LocalizedString.invalidUserData.localized
            
        case .billingNameRequired:
            return LocalizedString.invalidUserData.localized
            
        case .billingAddressIdRequired:
            return LocalizedString.invalidUserData.localized
            
        case .creditTypeRequired:
            return LocalizedString.invalidUserData.localized
            
        case .defaultCountryRequired:
            return LocalizedString.invalidUserData.localized
            
        case .preferredCurrencyRequired:
            return LocalizedString.invalidUserData.localized
            
        case .refundModeRequired:
            return LocalizedString.invalidUserData.localized
            
        case .userAlreadyRegisterdWithThisEmailId:
            return LocalizedString.userAlreadyRegistered.localized
            
        case .emailActiveAsSocialUser:
            return LocalizedString.userAlreadyRegistered.localized
            
        case .userWithNoPasswordAndNotInSocial:
            return LocalizedString.userAlreadyRegistered.localized
            
        case .userAlreadyLoggedIn:
            return LocalizedString.userAlreadyLoggedIn.localized
            
        case .capchaAtemptsLimitOver:
            return LocalizedString.capchaLimitOver.localized
            
        case .guestLoginIsNotPermittedForThisUser:
            return LocalizedString.guestLoginNotPermitted.localized
            
        case .somethingWentWrongPleaseTryAgain:
            return LocalizedString.somethingWentWrongTryAgain.localized
            
        case .forMobileAppOnly:
            return LocalizedString.mobileAppOnly.localized
            
        case .failedToRegisterEmailChangeRequest:
            return LocalizedString.failedToRegisterEmailChangeRequest.localized
            
        case .TokenHasBeenExpired:
            return LocalizedString.tokenExpired.localized
            
        case .userAlreadyCreatedUsingThisLink:
            return LocalizedString.userAlreadyCreatedLink.localized
            
        case .failedToCreateAccountMaster:
            return LocalizedString.failedToCreateUser.localized
            
        case .failedToCreateUser:
            return LocalizedString.failedToCreateUser.localized
            
        case .passwordIsWeak:
            return LocalizedString.weakPassword.localized
            
        case .newPasswordIsRequired:
            return LocalizedString.provideNewPassword.localized
            
        case .unableToSetNewPassword:
            return LocalizedString.unableToSetNewPassword.localized
            
        case .tokenIsRequired:
            return LocalizedString.provideValidToken.localized
            
        case .invalidToken:
            return LocalizedString.provideValidToken.localized
            
        case .passowrdHasAlreadyBeenResetUsingThisLink:
            return LocalizedString.passwordAlreadyReset.localized
            
        case .failedToResetPassword:
            return LocalizedString.failedToResetPassword.localized
            
        case .modeIsRequired:
            return LocalizedString.modeRequired.localized
            
        case .thePreviousEnquiryForThisEmailIdWasREJECTEDBYCSR:
            return LocalizedString.enquiryRejectedByCSR.localized
            
        case .failedToUpdateStatusOfCorpEnquiry:
            return LocalizedString.failedtoUpdateStatusOfCorpEnquiry.localized
            
        case .SomethingWentWrong:
            return LocalizedString.somethingWentWrongTryAfterSomeTime.localized
            
        case .failedToSendRegistrationEmail:
            return LocalizedString.failedToSendEmail.localized
            
        case .youHaveExceededMaximumAttemptsToResetPassword:
            return LocalizedString.exceededMaximumAttemptsToResetPassword.localized
            
        case .user_Not_Found, .user_type_not_matched:
            return LocalizedString.incorrectEmailId.localized
            
        default:
            return ""
        }
    }
}

// Navigation
public enum ATTransitionMode: Int {
    case present, dismiss, push, pop
}

enum AppPlaceholderImage {
    static let user: UIImage = #imageLiteral(resourceName: "userPlaceholder")
    static let profile: UIImage = #imageLiteral(resourceName: "profilePlaceholder")
    static let hotelCard: UIImage = #imageLiteral(resourceName: "hotelCardPlaceHolder")
    static let frequentFlyer: UIImage = #imageLiteral(resourceName: "userPlaceholder")
    static let `default`: UIImage = #imageLiteral(resourceName: "userPlaceholder")
}

// Images

enum AppImage {
    static let linkedInLogoImage: UIImage = #imageLiteral(resourceName: "linkedInIcon")
    static let facebookLogoImage: UIImage = #imageLiteral(resourceName: "facebook")
    static let googleLogoImage: UIImage = #imageLiteral(resourceName: "google")
    static let netBanking = #imageLiteral(resourceName: "netBanking")
    static let visa = #imageLiteral(resourceName: "visa")
    static let appleLogoImage: UIImage = #imageLiteral(resourceName: "Apple Logo")
    static let mobikwik = #imageLiteral(resourceName: "paymentMobikwik.png")

}

enum ATAmenity: String, CaseIterable {
    case Wifi = "10"
    case RoomService = "8"
    case Internet = "5"
    case AirConditioner = "1"
    case RestaurantBar = "7"
    case Gym = "4"
    case BusinessCenter = "2"
    case Pool = "6"
    case Spa = "9"
    case Coffee_Shop = "3"
    
    
    var title: String {
        switch self {
        case .Wifi:
            return LocalizedString.Wifi.localized
            
        case .RoomService:
            return LocalizedString.RoomService.localized
            
        case .Internet:
            return LocalizedString.Internet.localized
            
        case .AirConditioner:
            return LocalizedString.AirConditioner.localized
            
        case .RestaurantBar:
            return LocalizedString.RestaurantBar.localized
            
        case .Gym:
            return LocalizedString.Gym.localized
            
        case .BusinessCenter:
            return LocalizedString.BusinessCenter.localized
            
        case .Pool:
            return LocalizedString.Pool.localized
            
        case .Spa:
            return LocalizedString.Spa.localized
            
        case .Coffee_Shop:
            return LocalizedString.Coffee_Shop.localized
        }
    }
    
    var icon: UIImage {
        switch self {
        case .Wifi:
            return #imageLiteral(resourceName: "ame-wi-fi")
            
        case .RoomService:
            return #imageLiteral(resourceName: "ame-room-service")
            
        case .Internet:
            return #imageLiteral(resourceName: "ame-internet")
            
        case .AirConditioner:
            return #imageLiteral(resourceName: "ame-air-conditioner")
            
        case .RestaurantBar:
            return #imageLiteral(resourceName: "ame-restaurant-bar")
            
        case .Gym:
            return #imageLiteral(resourceName: "ame-gym")
            
        case .BusinessCenter:
            return #imageLiteral(resourceName: "ame-business-center")
            
        case .Pool:
            return #imageLiteral(resourceName: "ame-pool")
            
        case .Spa:
            return #imageLiteral(resourceName: "ame-spa")
            
        case .Coffee_Shop:
            return #imageLiteral(resourceName: "ame-coffee-shop")
        }
    }
    
    
}

enum ATMeal: Int, CaseIterable {
    case NoMeal = 1
    case Breakfast = 2
    case HalfBoard = 3
    case FullBoard = 5
    case Others = 6
    
    var title: String {
        switch self {
        case .NoMeal:
            return LocalizedString.RoomOnly.localized
            
        case .Breakfast:
            return LocalizedString.Breakfast.localized
            
        case .HalfBoard:
            return LocalizedString.HalfBoard.localized
            
        case .FullBoard:
            return LocalizedString.FullBoard.localized
            
        case .Others:
            return LocalizedString.Others.localized
        }
    }
}

enum ATCancellationPolicy: Int, CaseIterable {
    case Refundable = 1
    case PartRefundable = 2
    case NonRefundable = 3
    
    var title: String {
        switch self {
        case .Refundable:
            return LocalizedString.FreeCancellation.localized
            
        case .PartRefundable:
            return LocalizedString.PartRefundable.localized
            
        case .NonRefundable:
            return LocalizedString.NonRefundable.localized
        }
    }
}

enum ATOthers: Int, CaseIterable {
    case FreeWifi = 1
    case TransferInclusive = 2
    
    var title: String {
        switch self {
        case .FreeWifi:
            return LocalizedString.FreeWifi.localized
            
        case .TransferInclusive:
            return LocalizedString.TransferInclusive.localized
        }
    }
}

enum PassengersType: String {
    case Adult = "ADT"
    case Child = "CHD"
    case Infant = "INF"
}

enum UserCreditType: String {
    case regular = "R"
    case statement = "S"
    case billwise = "B"
    case topup = "T"
}

enum ProductType: Int, CaseIterable {
    case flight = 1
    case hotel = 2
    case other = 3
    
    // title for  handling
    var title: String {
        switch self {
        case .flight:
            return LocalizedString.flights.localized
            
        case .hotel:
            return LocalizedString.hotels.localized
            
        case .other:
            return LocalizedString.Others.localized
        }
    }
    
    var icon: UIImage {
        switch self {
        case .flight:
            return #imageLiteral(resourceName: "flight_blue_icon")
            
        case .hotel:
            return #imageLiteral(resourceName: "hotel_green_icon")
            
        case .other:
            return #imageLiteral(resourceName: "others_hotels") //#imageLiteral(resourceName: "others")
        }
    }
    
    static func getTypeFrom(_ str:String)-> ProductType{
        let newStr = str.lowercased()
        switch newStr{
        case "flight": return .flight
        case "hotel": return .hotel
        default: return .other
        }
    }
}

enum ATVoucherType: String {
    case sales
    case salesAddon = "sales_addon"
    case saleReturn = "sales_return_jv"
    case saleReschedule = "reschedule_sales_return_jv"
    case none
    
    init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "sales": self = .sales
        case "sales_addon": self = .salesAddon
        case "sales_return_jv": self = .saleReturn
        case "reschedule_sales_return_jv": self = .saleReschedule
        default:
            self = .none
        }
    }
    
    var value: String {
        return self.rawValue
    }
}

enum ATFileType: RawRepresentable {
    case pdf(extension: String)
    case text(extension: String)
    case word(extension: String)
    case powerPoint(extension: String)
    case excel(extension: String)
    case zip(extension: String)
    case image(extension: String)
    case code(extension: String)
    case other(extension: String)
    
    init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "pdf", "epub":
            self = .pdf(extension: rawValue)
            
        case "txt", "rtf":
            self = .text(extension: rawValue)
            
        case "doc", "docx", "dot", "dotx", "pages", "odt", "ott", "wps", "wpd", "sxw", "hwp":
            self = .word(extension: rawValue)
            
        case "ppt", "pptx", "pps", "ppsx", "pot", "key", "odp", "otp", "sti", "sxi":
            self = .powerPoint(extension: rawValue)
            
        case "xls", "xlsx", "xlsm", "xlt", "xlr", "csv", "xlsb", "numbers", "ods", "ots", "wks", "sxc":
            self = .excel(extension: rawValue)
            
        case "rar", "zip", "zipx", "7z":
            self = .zip(extension: rawValue)
            
        case "jpg", "jpeg", "png", "bmp", "gif", "tif", "tiff", "webp":
            self = .image(extension: rawValue)
            
        case "html", "xml", "xps", "chm":
            self = .code(extension: rawValue)
            
        default:
            self = .other(extension: rawValue)
        }
    }
    
    var rawValue: String {
        switch self {
        case .pdf(let ext): return ext
        case .text(let ext): return ext
        case .word(let ext): return ext
        case .powerPoint(let ext): return ext
        case .excel(let ext): return ext
        case .zip(let ext): return ext
        case .image(let ext): return ext
        case .code(let ext): return ext
        case .other(let ext): return ext
        }
    }
    
    var icon: UIImage {
        switch self {
        case .pdf: return #imageLiteral(resourceName: "ic_file_pdf")
        case .text: return #imageLiteral(resourceName: "ic_file_text")
        case .word: return #imageLiteral(resourceName: "ic_file_word")
        case .powerPoint: return #imageLiteral(resourceName: "ic_file_powerpoint")
        case .excel: return #imageLiteral(resourceName: "ic_file_excel")
        case .zip: return #imageLiteral(resourceName: "ic_file_zip")
        case .image: return #imageLiteral(resourceName: "ic_file_images")
        case .code: return #imageLiteral(resourceName: "ic_file_others")
        default: return #imageLiteral(resourceName: "ic_file_others")
        }
    }
}

extension String {
    var fileIcon: UIImage? {
        if let last = self.components(separatedBy: "/").last {
            if let type = last.components(separatedBy: ".").last {
                return (ATFileType(rawValue: type.lowercased()) ?? ATFileType.other(extension: type)).icon
            }
        }
        return ATFileType.other(extension: self).icon
    }
}

extension URL {
    var fileIcon: UIImage? {
        return self.lastPathComponent.fileIcon
    }
}

// App Enum for Weather type icon

// enum WeatherType: String {
//    case none = "ic_none"
//    case clearSky = "ic_clearsky"
//    case fewClouds = "ic_fewclouds"
//    case scatteredClouds = "ic_scatteredclouds"
//    case brokenClouds = "ic_brokenclouds"
//    case showerRain = "ic_showerrain"
//    case rain = "ic_rain"
//    case thunderStorm = "ic_thunderstorm"
//    case snow = "ic_snow"
//    case mist = "ic_mist"
//
//    init?(rawValue: String) {
//        let final = "ic_\(rawValue.removeAllWhitespaces.lowercased())"
//        switch final {
//        case "ic_clearsky": self = .clearSky
//        case "ic_fewclouds": self = .fewClouds
//        case "ic_scatteredclouds": self = .scatteredClouds
//        case "ic_brokenclouds": self = .brokenClouds
//        case "ic_showerrain": self = .showerRain
//        case "ic_rain": self = .rain
//        case "ic_thunderstorm": self = .thunderStorm
//        case "ic_snow": self = .snow
//        case "ic_mist": self = .mist
//        default: self = .none
//        }
//    }
//
//    var iconImage: UIImage {
//        return #imageLiteral(resourceName: self.rawValue)
//    }
// }

enum ResolutionStatus: RawRepresentable {
    case paymentPending
    case actionRequired
    case successfull
    case inProgress
    case aborted
    case closed
    case confirmationPending
    case open
    case canceled
    case none(title: String)
    case resolved
    case inProcess
    case terminated
    case onHold
    
    /*
     In Progress: Orange
     In Process: Orange
     Action Required: Red
     Payment Pending: Red
     Successful: Green
     Terminated: Grey
     Aborted: Grey
     On Hold: Black
     */
    init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "payment pending": self = .paymentPending
        case "action required": self = .actionRequired
        case "in progress": self = .inProgress
        case "successful": self = .successfull
        case "aborted": self = .aborted
        case "closed": self = .closed
        case "confirmation pending": self = .confirmationPending
        case "open": self = .open
        case "cancelled": self = .canceled //earlier it was "Canceled"
        case "resolved": self = .resolved
        case "in process": self = .inProcess
        case "terminated": self = .terminated
        case "on hold": self = .onHold
            
        default:
            self = .none(title: rawValue)
        }
    }
    
    var rawValue: String {
        switch self {
        case .paymentPending: return "Payment Pending"
        case .actionRequired: return "Action Required"
        case .inProgress: return "In Progress"
        case .successfull: return "Successful"
        case .aborted: return "Aborted"
        case .closed: return "Closed"
        case .confirmationPending: return "Confirmation Pending"
        case .open: return "Open"
        case .canceled: return "Cancelled"
        case .resolved: return "Resolved"
        case .inProcess: return "In Process"
        case .terminated: return "Terminated"
        case .onHold: return "On Hold"
        case .none(let ttl): return ttl
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .paymentPending: return AppColors.themeRed
        case .actionRequired: return AppColors.themeRed
        case .inProgress: return AppColors.themeYellow
        case .successfull: return AppColors.themeGreen
        case .aborted: return AppColors.themeGray20
        case .closed: return AppColors.themeBlack
        case .open: return AppColors.themeBlack
        case .confirmationPending: return AppColors.themeRed
        case .canceled: return AppColors.themeBlack
        case .resolved: return AppColors.themeGreen
        case .inProcess: return AppColors.themeOrange
        case .terminated: return AppColors.themeGray20
        case .onHold: return AppColors.themeBlack
            
        default:
            return  AppColors.themeBlack
        }
    }
}

// MARK: - ATWeatherType icon

enum ATWeatherType: RawRepresentable {
    case clearSky(code: String)
    case fewClouds(code: String)
    case scatteredClouds(code: String)
    case brokenClouds(code: String)
    case showerRain(code: String)
    case rain(code: String)
    case thunderStorm(code: String)
    case snow(code: String)
    case mist(code: String)
    
    init?(rawValue: String) {
        switch rawValue {
        case "800":
            self = .clearSky(code: rawValue)
            
        case "801":
            self = .fewClouds(code: rawValue)
            
        case "802":
            self = .scatteredClouds(code: rawValue)
            
        case "803", "804":
            self = .brokenClouds(code: rawValue)
            
        case "300", "301", "302", "310", "311", "312", "313", "314", "321", "520", "521", "522", "531":
            self = .showerRain(code: rawValue)
            
        case "500", "501", "502", "503", "504":
            self = .rain(code: rawValue)
            
        case "200", "201", "202", "210", "211", "212", "221", "230", "231", "232":
            self = .thunderStorm(code: rawValue)
            
        case "511", "600", "601", "602", "611", "612", "613", "614", "615", "620", "621", "622":
            self = .snow(code: rawValue)
        case "701", "711", "721", "731", "741", "751", "761", "771", "781":
            self = .mist(code: rawValue)
        default:
            self = .clearSky(code: rawValue)
        }
    }
    
    var rawValue: String {
        switch self {
        case .clearSky(let ext): return ext
        case .fewClouds(let ext): return ext
        case .scatteredClouds(let ext): return ext
        case .brokenClouds(let ext): return ext
        case .showerRain(let ext): return ext
        case .rain(let ext): return ext
        case .thunderStorm(let ext): return ext
        case .snow(let ext): return ext
        case .mist(let ext): return ext
        }
    }
    
    var icon: UIImage {
        switch self {
        case .clearSky: return #imageLiteral(resourceName: "ic_clearsky")
        case .fewClouds: return #imageLiteral(resourceName: "ic_fewclouds")
        case .scatteredClouds: return #imageLiteral(resourceName: "ic_scatterclouds")
        case .brokenClouds: return #imageLiteral(resourceName: "ic_brokenclouds")
        case .showerRain: return #imageLiteral(resourceName: "ic_showrain")
        case .thunderStorm: return #imageLiteral(resourceName: "ic_thunderstorm")
        case .rain:  return #imageLiteral(resourceName: "ic_rain")
        case .snow:  return #imageLiteral(resourceName: "ic_snow")
        case .mist:  return #imageLiteral(resourceName: "ic_mist")
        }
    }
}
