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
    
    case Male = "1",Female = "2" ,Other = "3", None
    
    init(stringValue: String) {
        
        switch stringValue.lowercased() {
            
        case "male":
            self = .Male
            
        case "female":
            self = .Female
            
        default:
            self = .Other
        }
    }
    
    var indexOfGender : String {
        
        switch self {
            
        case .Male :
            return "1"
        case .Female :
            return "2"
        case .Other :
            return "3"
        case .None:
            return "0"
        }
    }
    
    var stringValueOfGender : String {
        
        switch self {
            
        case .Male :
            return "Male"
        case .Female :
            return "Female"
        case .Other :
            return "Other"
            
        case .None:
            return ""
        }
    }
    
    static let  allOption : [Gender] = [.Male,.Female,.Other,.None]
    
}

struct UserModel {
    
    var email      : String
    var password   : String
    var first_name : String
    var last_name  : String
    var mobile     : String
    var gender     : Gender = .None
    var isd        : String
    var country    : String
    var salutation : String
    
    
    init() {
        
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        
        self.email     = json["email"].stringValue
        self.password   = json["password"].stringValue
        self.first_name  = json["first_name"].stringValue
        self.last_name  = json["last_name"].stringValue
        self.mobile    = json["mobile"].stringValue
        self.isd      = json["isd"].stringValue
        self.country   = json["country"].stringValue
        self.salutation = json["salutation"].stringValue
        self.country   = json["country"].stringValue
        
        if let gender   = json["gender"].string {
            
            if let getGender = Gender.init(rawValue: gender) {
                
                self.gender = getGender
            }
        }
    }
}

