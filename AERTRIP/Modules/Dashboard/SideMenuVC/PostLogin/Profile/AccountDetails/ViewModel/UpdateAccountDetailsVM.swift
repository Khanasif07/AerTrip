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
    
    enum PaymentMode  {
        case wallet
        case asPerMode
        
    }
    
    var updationType: AccountUpdationType = .pan
    var updateValue:String = ""
    var updatedId:String = ""
    weak var delegate: UpdateAccountDetailsVMDelegates?
    
    var details = UserAccountDetail()
    
    let paymentOptions = [LocalizedString.Wallet.localized, LocalizedString.Chosen_Mode_Of_Payment.localized]

    
    func setSelectedMode(selectedVal : String) {
        
        if selectedVal.lowercased() == LocalizedString.Wallet.localized.lowercased() {
            updateValue = "wallet"
            updatedId = "1"
            self.updateValue = LocalizedString.Wallet.localized
        } else {
            updateValue = "as_transaction"
            updatedId = "2"
            self.updateValue = LocalizedString.Chosen_Mode_Of_Payment.localized
        }
        
    }
    
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
                
                switch self.updationType{

                case .pan:
                    self.details.pan = paramsText
                
                case .aadhar:
                    self.details.aadhar = paramsText
                    
                case .gSTIN:
                    self.details.gst = paramsText
                    
                case .billingName:
                    self.details.billingName = paramsText
                    
                    
                default:
                    break
                    
                }
    
                self.delegate?.updateAccountDetailsSuccess()
            }else{
                self.delegate?.updateAccountDetailsFailure(errorCode: error)
            }
        }
    }
    
    
    func updateRefundModes(){
        let param:JSONDictionary = ["mode": updatedId]
        
        APICaller.shared.updateUserRefundMode(params: param) {[weak self] (success, error) in
            guard let self = self else {return}
            if success{
                self.details.refundMode = self.updateValue
                self.delegate?.updateAccountDetailsSuccess()
            }else{
                self.delegate?.updateAccountDetailsFailure(errorCode: error)
            }
        }
    }
    
    
}
