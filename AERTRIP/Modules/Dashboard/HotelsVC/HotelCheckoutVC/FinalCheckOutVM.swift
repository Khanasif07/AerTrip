//
//  FinalCheckOutVM.swift
//  AERTRIP
//
//  Created by apple on 26/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation


protocol FinalCheckoutVMDelegate: class {
    func willCallGetPayementMethods()
    func getPaymentsMethodsSuccess()
    func getPaymentMethodsFails(errors: ErrorCodes)
    
    
    func removeCouponCodeSuccessful(_ appliedCouponData: HCCouponAppliedModel)
    func removeCouponCodeFailed()
}

class FinalCheckoutVM: NSObject {
    
    
    weak var delegate: FinalCheckoutVMDelegate?
    var itineraryData: ItineraryData?
    var itinaryPriceDetail: ItenaryModel?
    var paymentDetails: PaymentModal?
    
    func webServiceGetPaymentMethods() {
        let params: JSONDictionary = [APIKeys.it_id.rawValue:  self.itineraryData?.it_id ?? ""]
        printDebug(params)
        APICaller.shared.getPaymentMethods(params: params) { [weak self] success, errors,paymentDetails in
            guard let sSelf = self else { return }
            if success {
                sSelf.paymentDetails = paymentDetails
                sSelf.delegate?.getPaymentsMethodsSuccess()
            } else {
                printDebug(errors)
                sSelf.delegate?.getPaymentMethodsFails(errors: errors)
            }
        }
    }
    
    func removeCouponCode() {
        let params: [String : Any] = [ APIKeys.it_id.rawValue : self.itineraryData?.it_id ?? "" ]
        APICaller.shared.removeCouponApi(params: params, loader: true) { [weak self] (success, errors, appliedCouponData) in
            guard let sSelf = self else { return }
            if success {
                printDebug(appliedCouponData)
                if let appliedCouponDetails = appliedCouponData {
                    sSelf.delegate?.removeCouponCodeSuccessful(appliedCouponDetails)
                }
            } else {
                printDebug(errors)
                //AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
                sSelf.delegate?.removeCouponCodeFailed()
            }
        }
    }

    
}
