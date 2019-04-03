//
//  FinalCheckOutVC+Razorpay.swift
//  AERTRIP
//
//  Created by Admin on 03/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Razorpay

extension FinalCheckOutVC: RazorpayPaymentCompletionProtocolWithData {
    
    func initializePayment(withOptions options: JSONDictionary) {
        razorpay.open(options)
    }
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        printDebug("code: \(code) \ndescription \(str) \nresponse \(response) ")
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        printDebug("payment_id: \(payment_id) \nresponse \(response) ")
    }
}
