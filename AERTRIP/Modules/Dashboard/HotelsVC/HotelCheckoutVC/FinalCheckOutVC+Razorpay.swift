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
        let razorpay: Razorpay = Razorpay.initWithKey(AppConstants.kRazorpayPublicKey, andDelegateWithData: self)
        //razorpay.open(options)
        razorpay.open(options, display: self)
    }
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        AppToast.default.showToastMessage(message: "Sorry! payment was faild.\nPlease try again.")
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        //payment success by razorpay
        if let res = response as? JSONDictionary {
            self.viewModel.getPaymentResonse(forData: res, isRazorPayUsed: true)
        }
    }
}

//#4    0x000000019be1fde4 in vImageConvert_AnyToAny ()
//#5    0x00000001979e8628 in vImageConverter_convert_internal ()
//#12    0x0000000197a34868 in CGSImageDataLock ()
//#17    0x000000010166083c in gmscore::vector::MutableTextureAtlas::UseCGContext(CGRect (CGContext*) block_pointer) ()
//#24    0x00000001015e94cc in -[GMSEntityRendererView draw] ()
 
