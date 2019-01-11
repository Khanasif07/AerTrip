//
//  UserModel.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 10/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


enum Gender : String {
    
    case male = "1",female = "2" ,other = "3", none
    
    init(stringValue: String) {
        
        switch stringValue.lowercased() {
            
        case "male":
            self = .male
            
        case "female":
            self = .female
            
        default:
            self = .other
        }
    }
    
    var indexOfGender : String {
        
        switch self {
            
        case .male :
            return "1"
        case .female :
            return "2"
        case .other :
            return "3"
        case .none:
            return "0"
        }
    }
    
    var stringValueOfGender : String {
        
        switch self {
            
        case .male :
            return "Male"
        case .female :
            return "Female"
        case .other :
            return "Other"
            
        case .none:
            return ""
        }
    }
    
    static let  allOption : [Gender] = [.male,.female,.other,.none]
    
}

struct SocialUserModel {
    
    var isLoggedIn : Bool
    var id         : String
    var email      : String
    var password   : String
    var firstName  : String
    var lastName   : String
    var mobile     : String
    var gender     : Gender = .none
    var isd        : String
    var country    : String
    var countryCode: String
    var salutation : String
    var picture    : String
    var service    : String
    var dob        : String
    var userName   : String
    var authKey    : String
    var billingName: String
    var creditType : String
    var paxId      : Int
    var points     : Int
    var maxNumberCount : Int
    var minNumberCount  : Int
    var preferredCurrency: String
    let hotels     : HotelsModel
    let accountData: AccountModel
    let generalPref: GeneralPrefrenceModel
    
     init() {
        
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        
        self.id          = json["id"].stringValue
        self.email       = json["email"].stringValue
        self.password    = json["password"].stringValue
        self.firstName   = json["first_name"].stringValue
        self.lastName     = json["last_name"].stringValue
        self.mobile      = json["mobile"].stringValue
        self.isd        = json["isd"].stringValue
        self.country     = json["country"].stringValue
        self.salutation   = json["salutation"].stringValue
        self.country     = json["country"].stringValue
        self.picture     = json["profile_image"].stringValue
        self.service     = json["service"].stringValue
        self.dob       = json["dob"].stringValue
        self.userName    = json["profile_name"].stringValue
        self.authKey    = json["authKey"].stringValue
        self.paxId      = json["pax_id"].intValue
        self.maxNumberCount = json["Max NSN"].intValue
        self.minNumberCount  = json["Min NSN"].intValue
        
        self.isLoggedIn = json["isLoggedIn"].boolValue
        self.billingName    = json["billing_name"].stringValue
        self.creditType      = json["credit_type"].stringValue
        self.points = json["points"].intValue
        self.preferredCurrency    = json["preferred_currency"].stringValue
        self.hotels = HotelsModel(json: json["hotels"])
        self.accountData = AccountModel(json: json["account_data"])
        self.generalPref = GeneralPrefrenceModel(json: json[APIKeys.generalPref.rawValue])
        self.countryCode = json["countryCode"].stringValue
        
        if let gender   = json["gender"].string {
            
            if let getGender = Gender.init(rawValue: gender) {
                
                self.gender = getGender
            }
        }
    }
}




