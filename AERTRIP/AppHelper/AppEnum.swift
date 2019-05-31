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
    case userLoggedInSuccess
    case userAsGuest
    case GRNSessionExpired
    case accountPaymentRegister
}

extension Notification.Name {
    static let logOut = Notification.Name("logOut")
    static let dataChanged = Notification.Name("dataChanged")
    static let sessionExpired = Notification.Name("sessionExpired")
    static let bulkEnquirySent = Notification.Name("bulkEnquirySent")
    static let bookingFilterApplied =  Notification.Name("bookingFilterApplied")
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
            
        case .NotLoggedIn:
            return "Not Logged In"
            
        case .emailRequired:
            return "Email ID is required"
            
        case .invalidEmailFormat:
            return "Kindly provide a valid email ID"
            
        case .passwordIsRequired:
            return "password is required"
            
        case .MultipleUserAccountsWithThisEmailId:
            return "Multiple user accounts with this email id"
            
        case .NoUserAccountWithThisEmailId:
            return "The email ID and / or password you have entered is incorrect."
            
        case .userTypeNotMatched:
            return "The email ID and / or password you have entered is incorrect."
            
        case .InvalidPassword:
            return "The email ID and / or password you have entered is incorrect."
            
        case .userNotFound:
            return "The email ID and / or password you have entered is incorrect."
            
        case .linkHasBeenExpired:
            return "Link has been expired"
            
        case .LinkAlreadyUsedToCreateAUser:
            return "Link already used to create a user"
            
        case .userIdRequired:
            return "User not found"
            
        case .accountMasterIdRequired:
            return "Invalid user data"
            
        case .userTypeIdRequired:
            return "Invalid user data"
            
        case .userGroupIdRequired:
            return "Invalid user data"
            
        case .userTypeCodeRequired:
            return "Invalid user data"
            
        case .userMemberIdRequired:
            return "Invalid user data"
            
        case .membershipNumberRequired:
            return "Invalid user data"
            
        case .hashKeyIsRequired:
            return "Please provide valid hash key"
            
        case .passengerIdRequired:
            return "Invalid user data"
            
        case .contactSourceIdRequired:
            return "Invalid user data"
            
        case .billingNameRequired:
            return "Invalid user data"
            
        case .billingAddressIdRequired:
            return "Invalid user data"
            
        case .creditTypeRequired:
            return "Invalid user data"
            
        case .defaultCountryRequired:
            return "Invalid user data"
            
        case .preferredCurrencyRequired:
            return "Invalid user data"
            
        case .refundModeRequired:
            return "Invalid user data"
            
        case .userAlreadyRegisterdWithThisEmailId:
            return "User already registered with this email address"
            
        case .emailActiveAsSocialUser:
            return "User already registered with this email address"
            
        case .userWithNoPasswordAndNotInSocial:
            return "User already registered with this email address"
            
        case .userAlreadyLoggedIn:
            return "user already logged in"
            
        case .capchaAtemptsLimitOver:
            return "capcha atempts limit over"
            
        case .guestLoginIsNotPermittedForThisUser:
            return "guest login is not permitted for this user"
            
        case .somethingWentWrongPleaseTryAgain:
            return "something went wrong. please try again"
            
        case .forMobileAppOnly:
            return "For Mobile App only"
            
        case .failedToRegisterEmailChangeRequest:
            return "Failed to register Email Change Request"
            
        case .TokenHasBeenExpired:
            return "Token has been expired"
            
        case .userAlreadyCreatedUsingThisLink:
            return "User already created using this link"
            
        case .failedToCreateAccountMaster:
            return "Failed to create user"
            
        case .failedToCreateUser:
            return "Failed to create user"
            
        case .passwordIsWeak:
            return "Password is weak. Please set a stronger password."
            
        case .newPasswordIsRequired:
            return "Please provide a valid new password"
            
        case .unableToSetNewPassword:
            return "Unable to set new password"
            
        case .tokenIsRequired:
            return "Please provide valid token"
            
        case .invalidToken:
            return "Please provide valid token"
            
        case .passowrdHasAlreadyBeenResetUsingThisLink:
            return "Passowrd has already been reset using this link"
            
        case .failedToResetPassword:
            return "Failed to reset password"
            
        case .modeIsRequired:
            return "mode is required"
            
        case .thePreviousEnquiryForThisEmailIdWasREJECTEDBYCSR:
            return "The previous enquiry for this email id was REJECTED BY CSR"
            
        case .failedToUpdateStatusOfCorpEnquiry:
            return "Failed to update status of Corp Enquiry"
            
        case .SomethingWentWrong:
            return "Something went wrong. Please try again after some time"
            
        case .failedToSendRegistrationEmail:
            return "Failed to send registration email"
            
        case .youHaveExceededMaximumAttemptsToResetPassword:
            return "You have exceeded maximum attempts to Reset Password for the day. Please try again tomorrow.            "
            
        case .user_Not_Found, .user_type_not_matched:
            return "The email ID provided is incorrect"
        default:
            return ""
        }
    }
}

// AppErrorCodeFor(rawValue: 1212)?.message

// Navigation
public enum ATTransitionMode: Int {
    case present, dismiss, push, pop
}

enum AppPlaceholderImage {
    static let user: UIImage = #imageLiteral(resourceName: "userPlaceholder")
    static let profile: UIImage = #imageLiteral(resourceName: "profilePlaceholder")
    static let hotelCard: UIImage = #imageLiteral(resourceName: "hotelCardPlaceHolder")
    static let frequentFlyer: UIImage = #imageLiteral(resourceName: "userPlaceholder")
}

// Images

enum AppImage {
    static let linkedInLogoImage: UIImage = #imageLiteral(resourceName: "linkedInIcon")
    static let facebookLogoImage: UIImage = #imageLiteral(resourceName: "facebook")
    static let googleLogoImage: UIImage = #imageLiteral(resourceName: "google")
}

enum ATAmenity: String, CaseIterable {
    case AirConditioner = "1"
    case BusinessCenter = "2"
    case Coffee_Shop = "3"
    case Gym = "4"
    case Internet = "5"
    case Pool = "6"
    case RestaurantBar = "7"
    case RoomService = "8"
    case Spa = "9"
    case Wifi = "10"
    
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
            return LocalizedString.NoMeal.localized
            
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
            return LocalizedString.Refundable.localized
            
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

enum PassengersType : String {
    case Adult = "ADT"
    case child = "CHD"
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
            return LocalizedString.Internet.localized
            
        }
    }
    
    var icon: UIImage {
        switch self {
        case .flight:
            return #imageLiteral(resourceName: "flight_blue_icon")
            
        case .hotel:
            return #imageLiteral(resourceName: "hotel_green_icon")
            
        case .other:
            return #imageLiteral(resourceName: "others")
        }
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
        switch (rawValue.lowercased()){

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
    var rawValue: String{
        switch (self){
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
        case .word: return #imageLiteral(resourceName: "ic_file_others")
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
