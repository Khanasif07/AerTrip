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
    let addresses : [Address]
    var billingAddress : Address
    var gst : String
    var aadhar : String
    var refundMode : String
    var billingName : String

    
    init(json : JSON = JSON()){
        
        pan = json["pan_number"].stringValue
        aadhar = json["aadhar_number"].stringValue
        billingName = json["billing_name"].stringValue
        billingAddress = Address(json:json["billing_address"])
        addresses = json["addresses"].map { Address(json:$0.1) }
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
        
        var addressStr = ""
        
        if !billingAddress.line1.isEmpty{
            addressStr.append(billingAddress.line1 + ", ")
        }
        
        if !billingAddress.line2.isEmpty {
            addressStr.append(billingAddress.line2 + ", ")
        }
        
        if !billingAddress.line3.isEmpty{
            addressStr.append(billingAddress.line3 + ", ")
        }
        
        if !billingAddress.city.isEmpty{
            addressStr.append(billingAddress.city + ", ")
        }
        
        if !billingAddress.postalCode.isEmpty{
            addressStr.append(billingAddress.postalCode + ", ")
        }
        
        if !billingAddress.state.isEmpty{
            addressStr.append(billingAddress.state + ", ")
        }
        
        if !billingAddress.countryName.isEmpty{
            addressStr.append(billingAddress.countryName)
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
