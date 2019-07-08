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
}

class AccountOnlineDepositVM: NSObject {
    
    weak var delegate: AccountOnlineDepositVMDelegate?
    var depositItinerary: DepositItinerary?
    
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
    
    func makePayment() {
        //forAmount used to decide that razor pay will use or not
        var params: [String : Any] = [ APIKeys.it_id.rawValue : self.depositItinerary?.id ?? ""]
        params[APIKeys.currency_code.rawValue] = UserInfo.loggedInUser?.preferredCurrency ?? ""
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
}
