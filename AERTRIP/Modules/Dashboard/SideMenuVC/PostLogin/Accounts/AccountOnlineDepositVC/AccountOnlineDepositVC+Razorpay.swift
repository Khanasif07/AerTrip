//
//  AccountOnlineDepositVC+Razorpay.swift
//  AERTRIP
//
//  Created by Admin on 03/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Razorpay

extension AccountOnlineDepositVC: RazorpayPaymentCompletionProtocolWithData {
    
    func initializePayment(withOptions options: JSONDictionary) {
        let razorpay: Razorpay = Razorpay.initWithKey(AppConstants.kRazorpayPublicKey, andDelegateWithData: self)
        razorpay.open(options)
    }
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        AppToast.default.showToastMessage(message: "Sorry! payment was faild.\nPlease try again.")
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        //payment success by razorpay
        self.showPaymentSuccessMessage()
    }
}