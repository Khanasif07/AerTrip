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
    
    func willFetchRecheckRatesData()
    func fetchRecheckRatesDataSuccess(recheckedData: ItineraryData)
    
    func willMakePayment()
    func makePaymentSuccess(options: JSONDictionary, shouldGoForRazorPay: Bool)
    func makePaymentFail()
    
    func willGetPaymentResonse()
    func getPaymentResonseSuccess(bookingIds: [String])
    func getPaymentResonseFail()
}

class FinalCheckoutVM: NSObject {
    
    
    weak var delegate: FinalCheckoutVMDelegate?
    var itineraryData: ItineraryData?
    var itinaryPriceDetail: ItenaryModel?
    var paymentDetails: PaymentModal?
    var hotelFormData: HotelFormPreviosSearchData = HotelFormPreviosSearchData()
    var grossTotalPayableAmount : Double = 0.0 // without wallet amount
    
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


//Mark:- Payment APIs
extension FinalCheckoutVM {
    
    func fetchRecheckRatesData() {
        let params: JSONDictionary = [APIKeys.it_id.rawValue: itineraryData?.it_id ?? ""]
        printDebug(params)
        
        self.delegate?.willFetchRecheckRatesData()
        APICaller.shared.fetchRecheckRatesData(params: params) { [weak self] success, errors, itData in
            guard let sSelf = self else { return }
            if success, let data = itData {
                sSelf.delegate?.fetchRecheckRatesDataSuccess(recheckedData: data)
            } else {
                printDebug(errors)
            }
        }
    }
    
    func makePayment(forAmount: Double, useWallet: Bool) {

        var params: [String : Any] = [ APIKeys.it_id.rawValue : self.itineraryData?.it_id ?? ""]
        params[APIKeys.total_amount.rawValue] = forAmount
        params[APIKeys.currency_code.rawValue] = self.itineraryData?.booking_currency ?? ""
        params[APIKeys.use_points.rawValue] = 0
        params[APIKeys.use_wallet.rawValue] = useWallet ? 1 : 0
        params[APIKeys.wallet_id.rawValue] = ""
        
        var paymentMethod = ""
        if (useWallet && forAmount <= 0) {
            paymentMethod = self.paymentDetails?.paymentModes.wallet.id ?? ""
        }
        else {
            paymentMethod = self.paymentDetails?.paymentModes.razorPay.id ?? ""
        }
        params[APIKeys.part_payment_amount.rawValue] = 0
        params[APIKeys.payment_method_id.rawValue] = paymentMethod
        params[APIKeys.ret.rawValue] = "json"
        
        self.delegate?.willMakePayment()
        APICaller.shared.makePaymentAPI(params: params) { [weak self](success, errors, options)  in
            guard let sSelf = self else { return }
            if success {
                sSelf.delegate?.makePaymentSuccess(options: options, shouldGoForRazorPay: !(useWallet && forAmount <= 0))
            } else {
                sSelf.delegate?.makePaymentFail()
                //AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
            }
        }
    }
    
    func getPaymentResonse(forData: JSONDictionary, isRazorPayUsed: Bool) {
        
        var params: JSONDictionary = [:]
        
        if isRazorPayUsed {
            params[APIKeys.id.rawValue] = self.itineraryData?.it_id ?? ""
            params[APIKeys.pid.rawValue] = forData[APIKeys.razorpay_payment_id.rawValue] as? String ?? ""
            params[APIKeys.oid.rawValue] = forData[APIKeys.razorpay_order_id.rawValue] as? String ?? ""
            params[APIKeys.sig.rawValue] = forData[APIKeys.razorpay_signature.rawValue] as? String ?? ""
        }
        else {
            //add the params in case of fully wallet payment
            params = forData
        }
        
        self.delegate?.willGetPaymentResonse()
        APICaller.shared.paymentResponseAPI(params: params) { [weak self](success, errors, bookingIds)  in
            guard let sSelf = self else { return }
            if success {
                sSelf.delegate?.getPaymentResonseSuccess(bookingIds: bookingIds)
            } else {
                sSelf.delegate?.getPaymentResonseFail()
                //AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
            }
        }
    }
}
