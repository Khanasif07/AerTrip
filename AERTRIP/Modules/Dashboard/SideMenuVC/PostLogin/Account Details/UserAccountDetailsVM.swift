//
//  AccountDetailsVM.swift
//  AERTRIP
//
//  Created by Admin on 12/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation



struct UserAccountDetail {
    
    var pan : String
    let addresses : JSONDictionary
    var billingAddress : JSON
    var gst : String
    var aadhar : String
    var refundMode : String
    var billingName : String

    
    init(json : JSON = JSON()){
        
        
        pan = json["pan_number"].stringValue
        aadhar = json["aadhar_number"].stringValue
        billingName = json["billing_name"].stringValue
        billingAddress = json["billing_address"]
        addresses = json["addresses"].dictionaryValue
        gst = json["gst"].stringValue
        refundMode = json["refund_mode"].stringValue
        
        
//        pan_number
     //   addresses
        
//        billing_address
//        gst
        
//        aadhar_number
        
//        refund_mode
        
//        billing_name
    }
    
    
    var billingAddressString : String {
        
        let line1 = billingAddress[APIKeys.line1.rawValue].stringValue
        let line2 = billingAddress[APIKeys.line2.rawValue].stringValue
        let line3 = billingAddress[APIKeys.line3.rawValue].stringValue
        let city = billingAddress[APIKeys.city.rawValue].stringValue
        let state = billingAddress[APIKeys.state.rawValue].stringValue
        let country = billingAddress[APIKeys.country_name.rawValue].stringValue
        let postalCode = billingAddress[APIKeys.postal_code.rawValue].stringValue

        
        var addressStr = ""
        
        if !line1.isEmpty{
            addressStr.append(line1 + ", ")
        }
        
        if !line2.isEmpty {
            addressStr.append(line2 + ", ")
        }
        
        if !line3.isEmpty{
            addressStr.append(line3 + ", ")
        }
        
        if !city.isEmpty{
            addressStr.append(city + ", ")
        }
        
        if !postalCode.isEmpty{
            addressStr.append(postalCode + ", ")
        }
        
        if !state.isEmpty{
            addressStr.append(state + ", ")
        }
        
        if !country.isEmpty{
            addressStr.append(country + ", ")
        }
        
        return addressStr
    }
    
    
}


protocol GetAccountDetailsDelegate : NSObjectProtocol {
    
    func willGetDetails()
    func getAccountDetailsSuccess()
    func failedToGetAccountDetails()
    
}

class UserAccountDetailsVM {
    
    enum UserAccountDetailsOptions  {
        case pan
        case adhar
        case gstin
        case defaultRefundMode
        case billingName
        case billingAddress
    }
    
    var details = UserAccountDetail()
    
    weak var delegate : GetAccountDetailsDelegate?
    
    let accountDetailsDict = [0 : [AccountUpdationType.pan,AccountUpdationType.aadhar,AccountUpdationType.gSTIN],
                              1 : [AccountUpdationType.defaultRefundMode,AccountUpdationType.billingName,AccountUpdationType.billingAddress]
    ]
    
    
    func getProfilData() {
                
        self.delegate?.willGetDetails()
        
        APICaller.shared.getUserMeta(params: [:]) { (success, data , error) in
            
            
            if let data = data, success {
                
                self.details = data
                self.delegate?.getAccountDetailsSuccess()
                
            } else {
                
                
                self.delegate?.failedToGetAccountDetails()
            }
            
        }
        
    }
    
    
}
