//
//  AppEnum.swift
//  
//
//  Created by Pramod Kumar on 24/09/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    static let logOut = Notification.Name("logOut")
    static let dataChanged = Notification.Name("dataChanged")
    static let sessionExpired = Notification.Name("sessionExpired")
    
}

//MARK:- Applicaion Response Code From Server
//MARK:-
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
    
    var message: String {
        
        switch self {
        case .success:
            return ""
            
        case .authenticationFailed:
            return ""
            
        case .NotLoggedIn:
            return "Not Logged In"
            
        case .emailRequired:
            return "email required"
            
        case .invalidEmailFormat:
            return "invalid email format"
            
        case .passwordIsRequired:
            return "password is required"
            
        case .MultipleUserAccountsWithThisEmailId:
            return "Multiple user accounts with this email id"
            
        case .NoUserAccountWithThisEmailId:
            return "No user account with this email id"
            
        case .userTypeNotMatched:
            return "user type not matched"
            
        case .InvalidPassword:
            return "Invalid Password"
            
        case .userNotFound:
            return "user not found"
            
        case .linkHasBeenExpired:
            return "Link has been expired"
            
        case .LinkAlreadyUsedToCreateAUser:
            return "Link already used to create a user"
            
        case .userIdRequired:
            return "user id required"
            
        case .accountMasterIdRequired:
            return "Account master id required"
            
        case .userTypeIdRequired:
            return "user type id required"
            
        case .userGroupIdRequired:
            return "user group id required"
            
        case .userTypeCodeRequired:
            return "user type code required"
            
        case .userMemberIdRequired:
            return "user member id required"
            
        case .membershipNumberRequired:
            return "membership number required"
            
        case .hashKeyIsRequired:
            return "Hash key is required"
            
        case .passengerIdRequired:
            return "passenger id required"
            
        case .contactSourceIdRequired:
            return "contact source id required"
            
        case .billingNameRequired:
            return "billing name required"
            
        case .billingAddressIdRequired:
            return "billing address id required"
            
        case .creditTypeRequired:
            return "credit type required"
            
        case .defaultCountryRequired:
            return "default country required"
            
        case .preferredCurrencyRequired:
            return "preferred currency required"
            
        case .refundModeRequired:
            return "refund mode required"
            
        case .userAlreadyRegisterdWithThisEmailId:
            return "user already registerd with this email id"
            
        case .emailActiveAsSocialUser:
            return "email active as social user"
            
        case .userWithNoPasswordAndNotInSocial:
            return "user with no password and not in social"
            
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
            return "Failed to create Account master"
            
        case .failedToCreateUser:
            return "Failed to create user"
            
        case .passwordIsWeak:
            return "Password is weak. Please set a stronger password."
            
        case .newPasswordIsRequired:
            return "new password is required"
            
        case .unableToSetNewPassword:
            return "Unable to set new password"
            
        case .tokenIsRequired:
            return "Token is required"
            
        case .invalidToken:
            return "Invalid token"
            
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
            return "You have exceeded maximum attempts to Reset Password for the day. Please try again tomorrow."
            
        default:
            return ""
        }
    }
}

//AppErrorCodeFor(rawValue: 1212)?.message
