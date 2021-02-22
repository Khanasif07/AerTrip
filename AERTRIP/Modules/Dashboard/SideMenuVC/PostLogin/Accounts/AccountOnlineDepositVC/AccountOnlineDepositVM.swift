//
//  AccountOnlineDepositVM.swift
//  AERTRIP
//
//  Created by apple on 26/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation


protocol AccountOnlineDepositVMDelegate: class {
    func willMakePayment()
    func makePaymentSuccess(options: JSONDictionary)
    func makePaymentFail()
    
    func willFetchPaymentResponse()
    func paymentResponseSuccess(_ with:JSON)
    func paymentResponseFail()
    
    func willUpdateConvenienceFee()
    func didUpdateConvenienceFee()
    func convenienceFeeFail()
}

class AccountOnlineDepositVM: NSObject {
    
    weak var delegate: AccountOnlineDepositVMDelegate?
    var depositItinerary: DepositItinerary?
    var timer:Timer?
    var convenienceFeeUpdateTime = 1.0
    
    var depositAmount: Double {
        if let part = depositItinerary?.partPaymentAmount, part > 0.0 {
            return part
        }
        return depositItinerary?.netAmount ?? 0.0
    }
    
    var feeAmount: Double {
        if let part = depositItinerary?.partPaymentAmount, part > 0.0 {
            var percentage = 0.0
            
            if let oldFee = depositItinerary?.razorpay?.convenienceFees, let netAmt = depositItinerary?.netAmount, netAmt > 0.0 {
                percentage = oldFee / netAmt
            }
            return part * percentage
        }
        return depositItinerary?.razorpay?.convenienceFees ?? 0.0
    }
    
    var totalPayableAmount: Double {
        return depositAmount + feeAmount
    }
    func isValidAmount() -> Bool {
        if depositAmount < 1 {
            AppToast.default.showToastMessage(message: LocalizedString.DepositAmountErrorMessage.localized)
            return false
        }else if totalPayableAmount > self.depositItinerary?.razorpay?.validation?.maxAmount ?? 0{
            let maxAmount = (self.depositItinerary?.razorpay?.validation?.maxAmount ?? 0.0).amountInDelimeterWithSymbol
            AppToast.default.showToastMessage(message: "Deposit amount must be less than \(maxAmount)")
            return false
        }
        return true
    }
    
    func makePayment() {
        //forAmount used to decide that razor pay will use or not
        var params: [String : Any] = [ APIKeys.it_id.rawValue : self.depositItinerary?.id ?? ""]
        params[APIKeys.currency_code.rawValue] = depositItinerary?.currency ?? (UserInfo.loggedInUser?.preferredCurrency ?? "")
        params[APIKeys.payment_method_id.rawValue] = depositItinerary?.razorpay?.id ?? ""

        params[APIKeys.total_amount.rawValue] = self.depositAmount

        params[APIKeys.part_payment_amount.rawValue] = 0
        params[APIKeys.use_points.rawValue] = 0
        params[APIKeys.use_wallet.rawValue] = 0
        params[APIKeys.wallet_id.rawValue] = ""
        params[APIKeys.ret.rawValue] = "json"

        self.delegate?.willMakePayment()
        APICaller.shared.makePaymentAPI(params: params) { [weak self](success, errors, options)  in
            guard let sSelf = self else { return }
            if success {
                sSelf.delegate?.makePaymentSuccess(options: options)
            } else {
                sSelf.delegate?.makePaymentFail()
            }
        }
    }
    
    
    func getPaymentResonse(forData: JSONDictionary) {
            
        var params: JSONDictionary = [:]
        params[APIKeys.id.rawValue] = self.depositItinerary?.id ?? ""
        params[APIKeys.pid.rawValue] = forData[APIKeys.razorpay_payment_id.rawValue] as? String ?? ""
        params[APIKeys.oid.rawValue] = forData[APIKeys.razorpay_order_id.rawValue] as? String ?? ""
        params[APIKeys.sig.rawValue] = forData[APIKeys.razorpay_signature.rawValue] as? String ?? ""
            
            self.delegate?.willFetchPaymentResponse()
            APICaller.shared.flightPaymentResponseAPI(params: params) { [weak self](success, errors, jsonData)  in
                guard let self = self else { return }
                if success, let json = jsonData {
                    self.delegate?.paymentResponseSuccess(json)
                } else {
                    self.delegate?.paymentResponseFail()
                }
            }
        }
    
    
    func updateConvenienceFee(amount:String){
        var params: JSONDictionary = [:]
        params[APIKeys.it_id.rawValue] = self.depositItinerary?.id ?? ""
        params[APIKeys.total_amount.rawValue] = amount
        params[APIKeys.action.rawValue] = APIKeys.convenience_fees.rawValue
        self.delegate?.willUpdateConvenienceFee()
        APICaller.shared.updateConvenienceFeeApi(params: params) {[weak self] (success, error, itinerary) in
            guard let self = self else {return}
            if success, let itinerary = itinerary{
                self.depositItinerary = itinerary
                self.delegate?.didUpdateConvenienceFee()
            }else{
                self.delegate?.convenienceFeeFail()
            }
        }
        
    }
    
}
