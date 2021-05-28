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
    static let user: UIImage = AppImages.userPlaceholder
    static let profile: UIImage = AppImages.profilePlaceholder
    static let hotelCard: UIImage = AppImages.hotelCardPlaceHolder
    static let frequentFlyer: UIImage = AppImages.userPlaceholder
    static let `default`: UIImage = AppImages.userPlaceholder
}

// Images

enum AppImage {
    static let linkedInLogoImage: UIImage = AppImages.linkedInLogoImage
    static let facebookLogoImage: UIImage = AppImages.facebookLogoImage
    static let googleLogoImage: UIImage = AppImages.googleLogoImage
    static let netBanking = AppImages.netBanking
    static let visa = AppImages.visa
    static let appleLogoImage: UIImage = AppImages.appleLogoImage
    static let mobikwik = AppImages.mobikwik
    static let freecharge = AppImages.freecharge
    static let payzapp = AppImages.payzapp
    static let airtelmoney = AppImages.airtelmoney
    static let jiomoney = AppImages.jiomoney
    static let olamoney = AppImages.olamoney
    static let phonepe = AppImages.phonepe
    static let phonepeswitch = AppImages.phonepe
    static let paypal = AppImages.paypal
    static let amazonpay = AppImages.amazonpay
    static let none = AppImages.none

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
            return AppImages.wifi
            
        case .RoomService:
            return AppImages.RoomService
            
        case .Internet:
            return AppImages.Internet
            
        case .AirConditioner:
            return AppImages.AirConditioner
            
        case .RestaurantBar:
            return AppImages.RestaurantBar
            
        case .Gym:
            return AppImages.Gym
            
        case .BusinessCenter:
            return AppImages.BusinessCenter
            
        case .Pool:
            return AppImages.Pool
            
        case .Spa:
            return AppImages.Spa
            
        case .Coffee_Shop:
            return AppImages.Coffee_Shop
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
            return AppImages.flight_blue_icon
            
        case .hotel:
            return AppImages.hotel_green_icon
            
        case .other:
            return AppImages.others_hotels //#imageLiteral(resourceName: "others")
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
        case .pdf: return AppImages.ic_file_pdf
        case .text: return AppImages.ic_file_text
        case .word: return AppImages.ic_file_word
        case .powerPoint: return AppImages.ic_file_powerpoint
        case .excel: return AppImages.ic_file_excel
        case .zip: return AppImages.ic_file_zip
        case .image: return AppImages.ic_file_images
        case .code: return AppImages.ic_file_others
        default: return AppImages.ic_file_others
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
        case .clearSky: return AppImages.ic_clearsky
        case .fewClouds: return AppImages.ic_fewclouds
        case .scatteredClouds: return AppImages.ic_scatterclouds
        case .brokenClouds: return AppImages.ic_brokenclouds
        case .showerRain: return AppImages.ic_showrain
        case .thunderStorm: return AppImages.ic_thunderstorm
        case .rain:  return AppImages.ic_rain
        case .snow:  return AppImages.ic_snow
        case .mist:  return AppImages.ic_mist
        }
    }
}


@objc class AppImages  : NSObject{

    static var ic_toast_cross:UIImage { #imageLiteral(resourceName: "ic_toast_cross") }
    static var black_cross:UIImage { #imageLiteral(resourceName: "black_cross") }
    static var CancelButtonWhite: UIImage { #imageLiteral(resourceName: "CancelButtonWhite") }
    static var searchBarClearButton: UIImage { #imageLiteral(resourceName: "searchBarClearButton") }
    
    static var ic_gallery_horizontal_view: UIImage { #imageLiteral(resourceName: "ic_gallery_horizontal_view") }
    static var ic_gallery_vertical_view: UIImage { #imageLiteral(resourceName: "ic_gallery_vertical_view") }
    
    static var searchBarIcon: UIImage  { #imageLiteral(resourceName: "searchBarIcon") }
    static var ic_search_mic:UIImage  { #imageLiteral(resourceName: "ic_search_mic") }
    
    static var Checkmark:UIImage  { #imageLiteral(resourceName: "Checkmark") }
    static var infoOrange:UIImage  { #imageLiteral(resourceName: "infoOrange") }
    
    static var profilePlaceholder: UIImage  { #imageLiteral(resourceName: "profilePlaceholder") }
    static var userPlaceholder: UIImage { #imageLiteral(resourceName: "userPlaceholder") }
    static var hotelCardPlaceHolder:UIImage  { #imageLiteral(resourceName: "hotelCardPlaceHolder") }
    
    static var linkedInLogoImage: UIImage  { #imageLiteral(resourceName: "linkedInIcon") }
    static var facebookLogoImage: UIImage  { #imageLiteral(resourceName: "facebook") }
    static var googleLogoImage: UIImage  { #imageLiteral(resourceName: "google") }
    
    static var netBanking: UIImage  { #imageLiteral(resourceName: "netBanking") }
    static var visa: UIImage  { #imageLiteral(resourceName: "visa") }
    static var appleLogoImage: UIImage  { #imageLiteral(resourceName: "Apple Logo") }
    static var mobikwik: UIImage  { #imageLiteral(resourceName: "paymentMobikwik.png") }
    static var freecharge: UIImage  { #imageLiteral(resourceName: "bankFreecharge") }
    static var payzapp: UIImage  { #imageLiteral(resourceName: "bankHdfcBank") }
    static var airtelmoney: UIImage  { #imageLiteral(resourceName: "bankAirtelPaymentsBank") }
    static var jiomoney: UIImage  { #imageLiteral(resourceName: "bankJiomoney") }
    static var olamoney: UIImage  { #imageLiteral(resourceName: "bankOlamoney") }
    static var phonepe: UIImage  { #imageLiteral(resourceName: "paymentPhonePay") }
    static var paypal: UIImage  { #imageLiteral(resourceName: "bankPayPal") }
    static var amazonpay: UIImage  { #imageLiteral(resourceName: "bankAmazonPay") }
    static var none: UIImage  { #imageLiteral(resourceName: "iconPaymentPlaceholder") }
    
    static var wifi:UIImage { #imageLiteral(resourceName: "ame-wi-fi") }
    static var RoomService:UIImage { #imageLiteral(resourceName: "ame-room-service") }
    static var Internet:UIImage { #imageLiteral(resourceName: "ame-internet") }
    static var AirConditioner:UIImage { #imageLiteral(resourceName: "ame-air-conditioner") }
    static var RestaurantBar:UIImage { #imageLiteral(resourceName: "ame-restaurant-bar") }
    static var Gym:UIImage{ #imageLiteral(resourceName: "ame-gym") }
    static var BusinessCenter:UIImage { #imageLiteral(resourceName: "ame-business-center") }
    static var Pool:UIImage { #imageLiteral(resourceName: "ame-pool") }
    static var Spa:UIImage { #imageLiteral(resourceName: "ame-spa") }
    static var Coffee_Shop:UIImage { #imageLiteral(resourceName: "ame-coffee-shop") }
    
    static var ic_file_pdf: UIImage{ #imageLiteral(resourceName: "ic_file_pdf") }
    static var ic_file_text: UIImage{ #imageLiteral(resourceName: "ic_file_text") }
    static var ic_file_word: UIImage{ #imageLiteral(resourceName: "ic_file_word") }
    static var ic_file_powerpoint: UIImage{ #imageLiteral(resourceName: "ic_file_powerpoint") }
    static var ic_file_excel: UIImage{ #imageLiteral(resourceName: "ic_file_excel") }
    static var ic_file_zip: UIImage{ #imageLiteral(resourceName: "ic_file_zip") }
    static var ic_file_images: UIImage{ #imageLiteral(resourceName: "ic_file_images") }
    static var ic_file_others: UIImage{ #imageLiteral(resourceName: "ic_file_others") }
    
    static var ic_clearsky: UIImage{ #imageLiteral(resourceName: "ic_clearsky") }
    static var ic_fewclouds: UIImage{ #imageLiteral(resourceName: "ic_fewclouds") }
    static var ic_scatterclouds: UIImage{ #imageLiteral(resourceName: "ic_scatterclouds") }
    static var ic_brokenclouds: UIImage{ #imageLiteral(resourceName: "ic_brokenclouds") }
    static var ic_showrain: UIImage{ #imageLiteral(resourceName: "ic_showrain") }
    static var ic_thunderstorm: UIImage{ #imageLiteral(resourceName: "ic_thunderstorm") }
    static var ic_rain: UIImage{ #imageLiteral(resourceName: "ic_rain") }
    static var ic_snow: UIImage{ #imageLiteral(resourceName: "ic_snow") }
    static var ic_mist: UIImage{ #imageLiteral(resourceName: "ic_mist") }
    
    static var whiteBlackLockIcon: UIImage { #imageLiteral(resourceName: "whiteBlackLockIcon") }
    
    static var othersAddon: UIImage { #imageLiteral(resourceName: "others") }
    static var seatsAddon: UIImage { #imageLiteral(resourceName: "seats") }
    static var baggageAddon: UIImage { #imageLiteral(resourceName: "baggage") }
    static var mealsAddon: UIImage { #imageLiteral(resourceName: "meals") }
    
    
    static var greenFilledAdd: UIImage { #imageLiteral(resourceName: "greenFilledAdd") }
    static var ic_info_incomplete: UIImage{ #imageLiteral(resourceName: "ic_info_incomplete") }
    
    static var ic_deselected_hotel_guest_adult: UIImage{ #imageLiteral(resourceName: "ic_deselected_hotel_guest_adult") }
    static var adultPassengers: UIImage{ #imageLiteral(resourceName: "adultPassengers") }//Not in use Duplicate
    static var ic_deselected_hotel_guest_child: UIImage { #imageLiteral(resourceName: "ic_deselected_hotel_guest_child") }
    static var ic_deselected_hotel_guest_infant: UIImage { #imageLiteral(resourceName: "ic_deselected_hotel_guest_infant") }
    static var ic_selected_hotel_guest_adult: UIImage { #imageLiteral(resourceName: "ic_selected_hotel_guest_adult") }
    static var ic_selected_hotel_guest_child: UIImage { #imageLiteral(resourceName: "ic_selected_hotel_guest_child") }
    static var ic_selected_hotel_guest_infant: UIImage { #imageLiteral(resourceName: "ic_selected_hotel_guest_infant") }
    static var AddPassenger: UIImage { #imageLiteral(resourceName: "AddPassenger") }
    
    static var pushpin: UIImage { #imageLiteral(resourceName: "pushpin") }
    static var pushpin_gray: UIImage { #imageLiteral(resourceName: "pushpin-gray") }
    
    static var starRatingFilled: UIImage { #imageLiteral(resourceName: "starRatingFilled") }
    static var starRatingFilledHollow: UIImage{ #imageLiteral(resourceName: "starRatingFilledHollow") }
    static var starRatingUnfill: UIImage{ #imageLiteral(resourceName: "starRatingUnfill") }
    
    static var selectedAdvisorRating: UIImage { #imageLiteral(resourceName: "selectedAdvisorRating") }
    static var deselectedAdvisorRating: UIImage { #imageLiteral(resourceName: "deselectedAdvisorRating") }
    static var CheckedGreenRadioButton: UIImage { #imageLiteral(resourceName: "CheckedGreenRadioButton") }
    static var UncheckedGreenRadioButton: UIImage { #imageLiteral(resourceName: "UncheckedGreenRadioButton") }
    
    static var ic_hotel_filter_applied: UIImage{ #imageLiteral(resourceName: "ic_hotel_filter_applied") }
    static var ic_hotel_filter: UIImage { #imageLiteral(resourceName: "ic_hotel_filter") }
    static var bookingFilterIcon: UIImage { #imageLiteral(resourceName: "bookingFilterIcon") }
    static var bookingFilterIconSelected: UIImage { #imageLiteral(resourceName: "bookingFilterIconSelected") }
    
    static var checkIcon: UIImage { #imageLiteral(resourceName: "checkIcon") }
    static var aerinSmallMic: UIImage { #imageLiteral(resourceName: "aerinSmallMic") }
    static var sendIcon: UIImage { #imageLiteral(resourceName: "sendIcon") }
    
    static var backGreen: UIImage { #imageLiteral(resourceName: "backGreen") }
    static var green_2: UIImage { #imageLiteral(resourceName: "green_2") }
    static var saveHotelsSelected: UIImage { #imageLiteral(resourceName: "saveHotelsSelected") }
    static var save_icon_green: UIImage { #imageLiteral(resourceName: "save_icon_green") }
    static var saveHotels: UIImage { #imageLiteral(resourceName: "saveHotels") }
    static var buildingImage: UIImage { #imageLiteral(resourceName: "buildingImage") }
    static var ic_fare_dipped: UIImage { #imageLiteral(resourceName: "ic_fare_dipped") }
    
    static var emptyStateCoupon: UIImage { #imageLiteral(resourceName: "emptyStateCoupon") }
    static var frequentFlyerEmpty: UIImage { #imageLiteral(resourceName: "frequentFlyerEmpty") }
    
    static var emailIcon: UIImage { #imageLiteral(resourceName: "emailIcon") }
    static var showPassword: UIImage { #imageLiteral(resourceName: "showPassword") }
    static var hidePassword: UIImage { #imageLiteral(resourceName: "hidePassword") }
    static var upwardAertripLogo: UIImage { #imageLiteral(resourceName: "upwardAertripLogo") }
    static var greenPopOverButton: UIImage { #imageLiteral(resourceName: "greenPopOverButton") }
    
    static var indianFlag: UIImage { #imageLiteral(resourceName: "ne") }
    static var ic_account_info: UIImage { #imageLiteral(resourceName: "ic_account_info") }
    static var ic_upload_slip: UIImage {  #imageLiteral(resourceName: "ic_upload_slip") }
    static var ic_next_arrow_zeroSpacing: UIImage { #imageLiteral(resourceName: "ic_next_arrow_zeroSpacing") }
    static var arrowNextScreen: UIImage { #imageLiteral(resourceName: "arrowNextScreen") } //Duplicate Image assets
    
    
    static var greenAdd: UIImage { #imageLiteral(resourceName: "greenAdd") }
    static var Back: UIImage { #imageLiteral(resourceName: "Back") }
    static var booking_Emptystate: UIImage { #imageLiteral(resourceName: "booking_Emptystate") }
    
    static var BookingDetailFlightNavIcon: UIImage { #imageLiteral(resourceName: "BookingDetailFlightNavIcon") }
    static var flightIconDetailPage: UIImage { #imageLiteral(resourceName: "flightIconDetailPage") }
    static var ic_acc_flight: UIImage {#imageLiteral(resourceName: "ic_acc_flight") }
    static var flight_blue_icon:UIImage { #imageLiteral(resourceName: "flight_blue_icon") }
    static var blueflight: UIImage { #imageLiteral(resourceName: "blueflight") }
    
    static var greenFlightIcon: UIImage {#imageLiteral(resourceName: "greenFlightIcon") }
    static var flightCancellation: UIImage {#imageLiteral(resourceName: "flightCancellation") }
    static var ic_acc_flightReScheduling: UIImage {#imageLiteral(resourceName: "ic_acc_flightReScheduling") }
    

    static var hotel_green_icon: UIImage{ return #imageLiteral(resourceName: "hotel_green_icon") }
    static var hotelAerinIcon: UIImage {#imageLiteral(resourceName: "hotelAerinIcon") }
    static var ic_acc_hotels: UIImage { #imageLiteral(resourceName: "ic_acc_hotels") }
    static var hotelCopy4: UIImage { #imageLiteral(resourceName: "hotelCopy4") }
    static var BookAnotherRoom: UIImage { #imageLiteral(resourceName: "BookAnotherRoom") }
    static var ic_acc_hotelCancellation: UIImage {#imageLiteral(resourceName: "ic_acc_hotelCancellation") }
    static var others_hotels: UIImage{ #imageLiteral(resourceName: "others_hotels") }
    
    static var greenCalenderIcon: UIImage {#imageLiteral(resourceName: "greenCalenderIcon") }
    static var addToTripgreen: UIImage { #imageLiteral(resourceName: "addToTripgreen") }
    static var AddToAppleWallet: UIImage { #imageLiteral(resourceName: "AddToAppleWallet") }
    static var bookingsDirections: UIImage {#imageLiteral(resourceName: "bookingsDirections") }
    static var bookingsCall: UIImage {#imageLiteral(resourceName: "bookingsCall") }
    static var bookingsCalendar: UIImage {#imageLiteral(resourceName: "bookingsCalendar") }
    static var shareBooking: UIImage {#imageLiteral(resourceName: "shareBooking") }
    static var bookingsHotel: UIImage {#imageLiteral(resourceName: "bookingsHotel") }
    
    static var woman: UIImage { #imageLiteral(resourceName: "woman") }
    static var man: UIImage { #imageLiteral(resourceName: "man") }
    static var girl: UIImage { #imageLiteral(resourceName: "girl") }
    static var infant: UIImage { #imageLiteral(resourceName: "infant") }
    static var boy: UIImage { #imageLiteral(resourceName: "boy") }
    static var person: UIImage { #imageLiteral(resourceName: "person") }
    
    static var ic_acc_receipt: UIImage { #imageLiteral(resourceName: "ic_acc_receipt") }
    static var ic_acc_lockAmount: UIImage {#imageLiteral(resourceName: "ic_acc_lockAmount") }
    static var ic_acc_card: UIImage {#imageLiteral(resourceName: "ic_acc_card") }
    static var ic_acc_debitNote: UIImage {#imageLiteral(resourceName: "ic_acc_debitNote") }
    static var ic_acc_creditNote: UIImage {#imageLiteral(resourceName: "ic_acc_creditNote") }
    static var ic_acc_cashback: UIImage {#imageLiteral(resourceName: "ic_acc_cashback") }
    static var ic_acc_addOns: UIImage {#imageLiteral(resourceName: "ic_acc_addOns") }
    
    static var ic_acc_journalVoucher: UIImage { #imageLiteral(resourceName: "ic_acc_journalVoucher") }
    static var linkFacebook: UIImage { #imageLiteral(resourceName: "linkFacebook") }
    static var linkGoogle: UIImage { #imageLiteral(resourceName: "linkGoogle") }
    static var flight: UIImage { #imageLiteral(resourceName: "flight") }
    static var downArrowCheckOut: UIImage { #imageLiteral(resourceName: "downArrowCheckOut") }
    static var upArrowIconCheckout: UIImage { #imageLiteral(resourceName: "upArrowIconCheckout") }
    static var AllDoneCalendar: UIImage { #imageLiteral(resourceName: "AllDoneCalendar") }
    
    static var trips: UIImage { #imageLiteral(resourceName: "trips") }
    static var fbIconWhite: UIImage { #imageLiteral(resourceName: "fbIconWhite") }
    static var twiterIcon: UIImage { #imageLiteral(resourceName: "twiterIcon") }
    static var flightIcon: UIImage { #imageLiteral(resourceName: "flightIcon") }
    static var socialInstagram: UIImage { #imageLiteral(resourceName: "socialInstagram") }
    static var hotelsCopy2: UIImage { #imageLiteral(resourceName: "hotelsCopy2") }
    static var favHotelWithShadowMarker: UIImage { #imageLiteral(resourceName: "favHotelWithShadowMarker") }
    static var clusterSmallTag: UIImage { #imageLiteral(resourceName: "clusterSmallTag") }
    static var share_file_icon: UIImage { #imageLiteral(resourceName: "share_file_icon") }
    static var send_icon: UIImage { #imageLiteral(resourceName: "send_icon") }
    static var cross_icon: UIImage { #imageLiteral(resourceName: "cross_icon") }
    static var downArrow: UIImage { #imageLiteral(resourceName: "downArrow") }
    static var HotelDetailsEmptyState: UIImage { #imageLiteral(resourceName: "HotelDetailsEmptyState") }
    static var tripAdvisorLogo: UIImage {  #imageLiteral(resourceName: "tripAdvisorLogo") }
    static var adult_icon: UIImage { #imageLiteral(resourceName: "adult_icon") }
    static var child_icon: UIImage { #imageLiteral(resourceName: "child_icon") }
    static var hotelsBlack: UIImage { #imageLiteral(resourceName: "hotelsBlack") }
    static var ic_no_traveller: UIImage { #imageLiteral(resourceName: "ic_no_traveller") }
    
    static var hotelEmpty: UIImage { #imageLiteral(resourceName: "hotelEmpty") }
    static var emptyHotelIcon: UIImage { #imageLiteral(resourceName: "emptyHotelIcon") }
    static var contactsEmpty: UIImage { #imageLiteral(resourceName: "contactsEmpty") }
    static var facebookEmpty: UIImage { #imageLiteral(resourceName: "facebookEmpty") }
    static var googleEmpty: UIImage { #imageLiteral(resourceName: "googleEmpty") }
    static var noHotelFound: UIImage { #imageLiteral(resourceName: "noHotelFound") }
    static var upcoming_emptystate: UIImage { #imageLiteral(resourceName: "upcoming_emptystate") }
    static var hotelCardNoImagePlaceHolder: UIImage { #imageLiteral(resourceName: "hotelCardNoImagePlaceHolder") }
    static var editPencel: UIImage { #imageLiteral(resourceName: "editPencel") }
    static var redMinusButton: UIImage { #imageLiteral(resourceName: "redMinusButton") }
    static var ic_delete_toast: UIImage { #imageLiteral(resourceName: "ic_delete_toast") }
    static var ic_red_dot: UIImage { #imageLiteral(resourceName: "ic_red_dot") }
    static var headPhoneIcon: UIImage { #imageLiteral(resourceName: "headPhoneIcon") }
    static var telex: UIImage { #imageLiteral(resourceName: "telex") }
    static var bookingEmailIcon: UIImage { #imageLiteral(resourceName: "bookingEmailIcon") }
    
    static var flightInfoarrow: UIImage { #imageLiteral(resourceName: "flightInfoarrow") }
    static var overnightIcon: UIImage { #imageLiteral(resourceName: "overnightIcon") }
    static var downloadingImage: UIImage { #imageLiteral(resourceName: "downloadingImage") }
    static var pdf: UIImage { #imageLiteral(resourceName: "pdf") }
    static var DownloadingPlaceHolder: UIImage { #imageLiteral(resourceName: "DownloadingPlaceHolder") }
    static var bookingsWebCheckin: UIImage { #imageLiteral(resourceName: "bookingsWebCheckin") }
    static var bookSameFlight: UIImage { #imageLiteral(resourceName: "bookSameFlight") }
    static var bookingsWebCheckinUnselected: UIImage { #imageLiteral(resourceName: "bookingsWebCheckinUnselected") }
    static var bookingsDirectionsUnselected: UIImage { #imageLiteral(resourceName: "bookingsDirectionsUnselected") }
    static var callGray: UIImage { #imageLiteral(resourceName: "callGray") }
    static var dircetionGray: UIImage { #imageLiteral(resourceName: "dircetionGray") }
    static var rightArrow: UIImage { #imageLiteral(resourceName: "rightArrow") }
    static var switch_fav_on: UIImage { #imageLiteral(resourceName: "switch_fav_on") }
    
    
    @objc static var greyColorTrack: UIImage { #imageLiteral(resourceName: "greyColorTrack") }
    @objc static var sliderHandle: UIImage { #imageLiteral(resourceName: "sliderHandle") }
    @objc static var greenBlueRangeImage: UIImage { #imageLiteral(resourceName: "greenBlueRangeImage") }
    
    
    static var arrow: UIImage{ #imageLiteral(resourceName: "arrow") }
    static var radioButtonSelect: UIImage { #imageLiteral(resourceName: "radioButtonSelect") }
    static var radioButtonUnselect: UIImage { #imageLiteral(resourceName: "radioButtonUnselect") }
    @objc static var onewayIcon: UIImage {#imageLiteral(resourceName: "oneway")}
    @objc static var returnIcon: UIImage { #imageLiteral(resourceName: "return") }
    static var onewayWhite: UIImage {#imageLiteral(resourceName: "onewayWhite")}
    static var onewayAertripColor: UIImage {#imageLiteral(resourceName: "onewayAertripColor")}
    @objc static var greenTick: UIImage { #imageLiteral(resourceName: "greenTick") }
    static var MultiAirlineItinery: UIImage { #imageLiteral(resourceName: "MultiAirlineItinery") }
    static var Green_Copy: UIImage { #imageLiteral(resourceName: "Green_Copy") }
    static var blackCheckmark: UIImage { #imageLiteral(resourceName: "blackCheckmark") }
    static var downGray: UIImage { #imageLiteral(resourceName: "downGray") }
    static var upGray: UIImage { #imageLiteral(resourceName: "upGray") }
    static var green: UIImage { #imageLiteral(resourceName: "green") }
    static var InfoButton: UIImage { #imageLiteral(resourceName: "InfoButton") }
    static var OvHotelResult: UIImage { #imageLiteral(resourceName: "OvHotelResult") }
    static var EmailPinned: UIImage { #imageLiteral(resourceName: "EmailPinned") }
    static var SharePinned: UIImage { #imageLiteral(resourceName: "SharePinned") }
    static var checkingBaggageKg: UIImage { #imageLiteral(resourceName: "checkingBaggageKg") }
    static var UpArrow: UIImage { #imageLiteral(resourceName: "UpArrow") }
    static var DownArrow: UIImage { #imageLiteral(resourceName: "DownArrow") }
    static var pinGreen: UIImage { #imageLiteral(resourceName: "pinGreen") }
    static var FilledpinGreen: UIImage { #imageLiteral(resourceName: "FilledpinGreen") }
    static var ShareGreen: UIImage { #imageLiteral(resourceName: "ShareGreen") }
    static var redchangeAirport: UIImage { #imageLiteral(resourceName: "redchangeAirport") }
    static var changeOfTerminal: UIImage { #imageLiteral(resourceName: "changeOfTerminal") }
    static var overnight: UIImage { #imageLiteral(resourceName: "overnight") }
    static var cabinBaggage: UIImage { #imageLiteral(resourceName: "cabinBaggage") }
    static var group4: UIImage { #imageLiteral(resourceName: "group4") }
    static var Group_4_1: UIImage { #imageLiteral(resourceName: "Group_4_1") }
    static var Green_Chat_bubble: UIImage { #imageLiteral(resourceName: "Green Chat bubble") }
    static var BlurCross: UIImage { #imageLiteral(resourceName: "BlurCross") }
    static var statusBarColor: UIImage { #imageLiteral(resourceName: "statusBarColor") }
    static var group: UIImage { #imageLiteral(resourceName: "group") }
    static var aerinBlackIcon: UIImage { #imageLiteral(resourceName: "aerinBlackIcon") }
    static var White_Chat_bubble: UIImage { #imageLiteral(resourceName: "White Chat bubble") }
    static var darkNights: UIImage { #imageLiteral(resourceName: "darkNights") }
    static var icon: UIImage { #imageLiteral(resourceName: "icon") }
    @objc static var unSelectOption: UIImage { #imageLiteral(resourceName: "unSelectOption") }
    @objc static var selectOption: UIImage { #imageLiteral(resourceName: "selectOption") }
    @objc static var EconomyClassGreen: UIImage { #imageLiteral(resourceName: "EconomyClassGreen") }
    @objc static var BusinessClassGreen: UIImage { #imageLiteral(resourceName: "BusinessClassGreen") }
    @objc static var PremiumEconomyClassGreen: UIImage { #imageLiteral(resourceName: "PremiumEconomyClassGreen") }
    @objc static var FirstClassGreen: UIImage { #imageLiteral(resourceName: "FirstClassGreen") }
    @objc static var EconomyClassBlack: UIImage { #imageLiteral(resourceName: "EconomyClassBlack") }
    @objc static var BusinessClassBlack: UIImage { #imageLiteral(resourceName: "BusinessClassBlack") }
    @objc static var PreEconomyClassBlack: UIImage { #imageLiteral(resourceName: "PreEconomyClassBlack") }
    @objc static var FirstClassBlack: UIImage { #imageLiteral(resourceName: "FirstClassBlack") }

    
    //    static var down: UIImage { #imageLiteral(resourceName: "DownArrow") }//icon
    

// UIImage(named:
// UIImage imageNamed:


    
    
//    #imageLiteral(resourceName: "green")
    
//    #imageLiteral(resourceName: "down")//Duplicate Image assets
//    #imageLiteral(resourceName: "up")//Duplicate Image assets
//    #imageLiteral(resourceName: "popOverMenuIcon")//Duplicate Image assets
//    #imageLiteral(resourceName: "plusButton")
    
    
}
