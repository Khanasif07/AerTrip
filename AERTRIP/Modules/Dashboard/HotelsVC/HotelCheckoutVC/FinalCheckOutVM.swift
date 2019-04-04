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
    func makePaymentSuccess(options: JSONDictionary)
    func makePaymentFail()
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
    
    func makePayment() {

        var params: [String : Any] = [ APIKeys.it_id.rawValue : self.itineraryData?.it_id ?? ""]
        params[APIKeys.total_amount.rawValue] = self.itineraryData?.payment_amount ?? 0
        params[APIKeys.currency_code.rawValue] = self.itineraryData?.booking_currency ?? ""
        params[APIKeys.use_points.rawValue] = 0
        params[APIKeys.use_wallet.rawValue] = 0
        params[APIKeys.wallet_id.rawValue] = ""
        params[APIKeys.part_payment_amount.rawValue] = 0
        params[APIKeys.payment_method_id.rawValue] = ""
        params[APIKeys.ret.rawValue] = "json"
        
        self.delegate?.willMakePayment()
        APICaller.shared.makePaymentAPI(params: params) { [weak self](success, errors) in
            guard let sSelf = self else { return }
            if success {
                sSelf.delegate?.makePaymentSuccess(options: ["":""])
            } else {
                sSelf.delegate?.makePaymentFail()
                //AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
            }
        }
    }
}
