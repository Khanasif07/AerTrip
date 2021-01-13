//
//  UpdateAccountDetailsVM.swift
//  AERTRIP
//
//  Created by Appinventiv  on 12/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation

public enum AccountUpdationType : String{
    case billingName = "Billing Name"
    case gSTIN = "GSTIN Number"
    case aadhar = "Aadhar Number"
    case pan = "PAN Number"
    case billingAddress = "Billing Address"
    case defaultRefundMode = "Default Refund Mode"
}

protocol UpdateAccountDetailsVMDelegates:NSObjectProtocol {
    func updateAccountDetailsSuccess()
    func updateAccountDetailsFailure(errorCode: ErrorCodes)
}

class UpdateAccountDetailsVM{
    
    var updationType: AccountUpdationType = .pan
    weak var delegate: UpdateAccountDetailsVMDelegates?
    
    
    
    func isValidDetails(with txt:String)-> (success: Bool, msg:String){
        
        var msg = ""
        switch self.updationType{
        case .aadhar:
            if txt.isEmpty{
               msg = "Please enter a valid Aadhar number"
            }
        case .billingAddress:
            if txt.isEmpty{
               msg = "Please select a billing address"
            }
        case .gSTIN:
            if txt.isEmpty || !(txt.checkValidity(.gst)){
               msg = "Please enter a valid GSTIN number"
            }
        case  .billingName:
            if txt.isEmpty{
               msg = "Please enter a valid billing name"
            }
        case .pan://!self.panCard.checkValidity(.PanCard)
            if txt.isEmpty || !txt.checkValidity(.PanCard){
               msg = "Please enter a PAN number"
            }
        case .defaultRefundMode:
            if txt.isEmpty{
               msg = "Please enter select Default Refund Mode"
            }
        }
        if !msg.isEmpty{
            return (false, msg)
        }else{
            return (true, "")
        }
        
    }
    
    func updateAccountDetails(_ paramsText: String){
        var param:JSONDictionary = [:]
        switch self.updationType{
        case .aadhar:
            param["action"] = "aadhar_number"
            param["aadhar_number"] = paramsText
        case .billingAddress:
            param["action"] = "billing_address"
            param["billing_address"] = paramsText
        case .gSTIN:
            param["action"] = "gst"
            param["gst"] = paramsText
        case  .billingName:
            param["action"] = "billing_name"
            param["billing_name"] = paramsText
        case .pan:
            param["action"] = "pan_number"
            param["pan_number"] = paramsText
        default: return
        }
        APICaller.shared.updateAccountDetails(params: param) {[weak self] (success, error) in
            guard let self = self else {return}
            if success{
                self.delegate?.updateAccountDetailsSuccess()
            }else{
                self.delegate?.updateAccountDetailsFailure(errorCode: error)
            }
        }
    }
    
    
    func updateRefundModes(_ paramsText: String){
        let param:JSONDictionary = ["mode": paramsText]
        
        APICaller.shared.updateUserRefundMode(params: param) {[weak self] (success, error) in
            guard let self = self else {return}
            if success{
                self.delegate?.updateAccountDetailsSuccess()
            }else{
                self.delegate?.updateAccountDetailsFailure(errorCode: error)
            }
        }
    }
    
    
}
