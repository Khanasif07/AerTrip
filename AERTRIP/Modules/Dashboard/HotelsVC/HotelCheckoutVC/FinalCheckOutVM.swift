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
    func makePaymentFail(errors: ErrorCodes)
    
    func willGetPaymentResonse()
    func getPaymentResonseSuccess(bookingIds: [String] , cid: [String])
    func getPaymentResonseFail()
    
    func willGetBookingReceipt()
    func getBookingReceiptSuccess(detail: HotelReceiptModel)
    func getBookingReceiptFail()
    
    
    func getCurrencyResponse(success: Bool)
}

class FinalCheckoutVM: NSObject {
    
    weak var delegate: FinalCheckoutVMDelegate?
    var itineraryData: ItineraryData?
    var itinaryPriceDetail: ItenaryModel?
    var paymentDetails: PaymentModal?
    var originLat: String = ""
    var originLong: String = ""
    var hotelFormData: HotelFormPreviosSearchData = HotelFormPreviosSearchData()
    var grossTotalPayableAmount : Double = 0.0 // without wallet amount
    var bookingIds: [String] = [], cId: [String] = []
    var isApplyingCoupon = false
    var paymentMethodApiCount = 1
    var sId: String = ""

    
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
        //forAmount used to decide that razor pay will use or not
        var params: [String : Any] = [ APIKeys.it_id.rawValue : self.itineraryData?.it_id ?? ""]
        params[APIKeys.total_amount.rawValue] = grossTotalPayableAmount
        params[APIKeys.currency_code.rawValue] = UserInfo.preferredCurrencyDetails?.currencyCode ?? (self.itineraryData?.booking_currency ?? "")
        params[APIKeys.use_points.rawValue] = 0
        if UserInfo.loggedInUser != nil {
            params[APIKeys.use_wallet.rawValue] = useWallet ? 1 : 0
            params[APIKeys.wallet_id.rawValue] = useWallet ? (self.paymentDetails?.paymentModes.wallet.id ?? "") : ""
        } else {
            params[APIKeys.use_wallet.rawValue] = 0
            printDebug("No wallet id required.")
        }
        
        
        var paymentMethod = ""
        if (useWallet && forAmount <= 0) {
            paymentMethod = self.paymentDetails?.paymentModes.wallet.id ?? ""
        }
        else {
            paymentMethod = self.paymentDetails?.paymentModes.razorPay.id ?? ""
            params[APIKeys.ret.rawValue] = "json"
        }
        params[APIKeys.part_payment_amount.rawValue] = 0
        params[APIKeys.payment_method_id.rawValue] = paymentMethod
        
        self.delegate?.willMakePayment()
        APICaller.shared.makePaymentAPI(params: params) { [weak self](success, errors, options)  in
            guard let sSelf = self else { return }
            if success {
                sSelf.delegate?.makePaymentSuccess(options: options, shouldGoForRazorPay: !(useWallet && forAmount <= 0))
            } else {
                sSelf.delegate?.makePaymentFail(errors: errors)
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
        APICaller.shared.paymentResponseAPI(params: params) { [weak self](success, errors, bookingIds , cid)  in
            guard let sSelf = self else { return }
            if success {
                sSelf.delegate?.getPaymentResonseSuccess(bookingIds: bookingIds, cid: cid)
            } else {
                sSelf.delegate?.getPaymentResonseFail()
                //AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
            }
        }
    }
    
    func getBookingReceipt(bookingIds: [String], itId: String) {
        
        let params: JSONDictionary = [APIKeys.booking_id.rawValue: bookingIds.first ?? "", APIKeys.it_id.rawValue: itId]

        self.delegate?.willGetBookingReceipt()
        APICaller.shared.bookingReceiptAPI(params: params) { [weak self](success, errors, receiptData)  in
            guard let sSelf = self else { return }
            if success {
                let hotelReceiptData = receiptData ?? HotelReceiptModel()
                sSelf.delegate?.getBookingReceiptSuccess(detail: hotelReceiptData)
                sSelf.getUserAccountData()
            } else {
                sSelf.delegate?.getBookingReceiptFail()
            }
        }
    }
    
    //Golu Chnages 
    func getCouponsDetailsApi(completion: @escaping((_ success:Bool, _ couponData: [HCCouponModel], _ error:ErrorCodes)->())) {

        let params: [String : Any] = [APIKeys.it_id.rawValue : self.itineraryData?.it_id ?? "" , APIKeys.product.rawValue : CouponFor.hotels.rawValue]
        APICaller.shared.getCouponDetailsApi(params: params, loader: true ) { (success, errors, couponsDetails) in
            completion(success, couponsDetails, errors)
            
        }
    }
    
    //To update Account details after booking.
    private func getUserAccountData(){
        if UserInfo.loggedInUserId != nil{
//            APICaller.shared.getAccountDetailsAPI(params: [:]) {(success, accLad, accVchrs, outLad, periodic, errors) in
//                printDebug("Account updated.")
//            }
            
            APICaller.shared.getAccountSummaryAPI(params: [:], completionBlock: { ( success, errors) in
                printDebug("Account updated.")
            })
        }
    }
    
    
    func updateCurrency(){
        APICaller.shared.getCurrencies {[weak self] (success, _) in
            guard let self = self else {return}
            self.delegate?.getCurrencyResponse(success: success)
            self.fetchRecheckRatesData()
        }
    }
    
    
}

///Log Firebase Events
extension FinalCheckoutVM{
    
    func logEvent(with event: FirebaseEventLogs.EventsTypeName){
        FirebaseEventLogs.shared.logHoltelFinalCheckOutEvent(with: event)
    }
}
