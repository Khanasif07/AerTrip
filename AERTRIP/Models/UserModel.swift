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

struct UserModel {
    
    var id         : String
    var email      : String
    var password   : String
    var firstName  : String
    var lastName   : String
    var mobile     : String
    var gender     : Gender = .none
    var isd        : String
    var country    : String
    var salutation : String
    var picture    : String
    var service    : String
    var dob        : String
    var userName   : String
    
     init() {
        
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        
        self.id         = json["id"].stringValue
        self.email       = json["email"].stringValue
        self.password     = json["password"].stringValue
        self.firstName    = json["first_name"].stringValue
        self.lastName     = json["last_name"].stringValue
        self.mobile      = json["mobile"].stringValue
        self.isd        = json["isd"].stringValue
        self.country     = json["country"].stringValue
        self.salutation   = json["salutation"].stringValue
        self.country     = json["country"].stringValue
        self.picture     = json["picture"].stringValue
        self.service     = json["service"].stringValue
        self.dob       = json["dob"].stringValue
        self.userName    = json["user_name"].stringValue
        
        if let gender   = json["gender"].string {
            
            if let getGender = Gender.init(rawValue: gender) {
                
                self.gender = getGender
            }
        }
    }
}

