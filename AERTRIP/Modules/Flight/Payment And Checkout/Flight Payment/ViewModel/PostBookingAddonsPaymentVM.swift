//
//  PostBookingAddonsPaymentVM.swift
//  AERTRIP
//
//  Created by Apple  on 18.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class PostBookingAddonsPaymentVM{
    // Save applied coupon data
    var appliedCouponData: FlightItineraryData = FlightItineraryData()
    var itinerary:FlightItinerary{
        return appliedCouponData.itinerary
    }
    var addonsMaster = AddonsMaster()
    var taxesResult = [String:String]()
    var taxAndFeesData = [(name:String,value:Int)]()
//    var parmsForItinerary:JSONDictionary = [:]
    var grossTotalPayableAmount : Double = 0.0 // without wallet amount
    var paymentDetails: PaymentModal? //Payment methods
    var delegate:FlightPaymentVMDelegate?
    var gstDetail = GSTINModel()
    var bookingObject:BookFlightObject?
    var isGSTOn = false
    var isd = ""
    var mobile = ""
    var email = ""
    //Setup for section header and cell
    var sectionTableCell = [[CellType]]()
    var sectionHeader = [sectionType]()
    
    enum CellType{
        case WalletCell, TermsConditionCell,FareDetailsCell,EmptyCell,DiscountCell,WalletAmountCell,FareBreakupCell,TotalPayableNowCell
    }
    enum sectionType{
        case CouponsAndWallet,Addons,TotalPaybleAndTC
    }
    
    func taxesDataDisplay(){
        taxAndFeesData.removeAll()
        var taxesDetails : [String:Int] = [String:Int]()
        var taxAndFeesDataDict = [taxStruct]()
        taxesDetails = self.itinerary.details.fare.taxes.details
        for (_, value) in taxesDetails.enumerated() {
            let newObj = taxStruct.init(name: taxesResult[value.key] ?? "", taxVal: value.value)
            taxAndFeesDataDict.append(newObj)
        }
        let newDict = Dictionary(grouping: taxAndFeesDataDict) { $0.name }
        for ( key , _ ) in newDict {
            let dataArray = newDict[key]
            var newTaxVal = 0
            for i in 0..<dataArray!.count{
                newTaxVal += (dataArray?[i].taxVal ?? 0)
            }
            let newArr = (key,newTaxVal)
            taxAndFeesData.append(newArr)
            
        }
        self.getNumberOfSection()
    }
    
    private func getNumberOfSection(){
        self.sectionHeader = []
        self.sectionTableCell = []
        var firstSectionData = [CellType]()
        firstSectionData.append(contentsOf: [.EmptyCell,.WalletCell,.EmptyCell,.FareBreakupCell])
        self.sectionTableCell.append(firstSectionData)
        self.sectionHeader.append(.CouponsAndWallet)
        //For Taxes and other fee
        var secondSectionCell = [CellType]()
        for _ in self.taxAndFeesData{
            secondSectionCell.append(.DiscountCell)
        }
        self.sectionTableCell.append(secondSectionCell)
        self.sectionHeader.append(.Addons)
       //Totalpayble and TC
        self.sectionTableCell.append([.WalletAmountCell,.WalletAmountCell,.TotalPayableNowCell,.TermsConditionCell])
        self.sectionHeader.append(.TotalPaybleAndTC)
        
    }
    
}
//MARK:- API Call
extension PostBookingAddonsPaymentVM{
    
     func webServiceGetPaymentMethods() {
         let params: JSONDictionary = [APIKeys.it_id.rawValue:  self.itinerary.id]
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
        let params: [String : Any] = [ APIKeys.it_id.rawValue : self.itinerary.id ]
        APICaller.shared.removeFlightCouponApi(params: params, loader: true) { [weak self] (success, errors, appliedCouponData) in
            guard let sSelf = self else { return }
            if success {
                if let appliedCouponDetails = appliedCouponData {
                    sSelf.delegate?.removeCouponCodeSuccessful(appliedCouponDetails)
                }
            } else {
                sSelf.delegate?.removeCouponCodeFailed()
            }
        }
    }
    
    
    func reconfirmationAPI() {
        let params: [String : Any] = [ APIKeys.it_id.rawValue : self.itinerary.id ]
        APICaller.shared.flightReconfirmationApi(params: params, loader: true) { [weak self] (success, errors, appliedCouponData) in
            guard let self = self else { return }
            if success {
//                printDebug(appliedCouponData)
                if let appliedCouponDetails = appliedCouponData {
                    self.appliedCouponData.itinerary = appliedCouponDetails.itinerary
                }
            }
            self.delegate?.reconfirmationResponse(success)
        }
    }
    
    func makePayment(forAmount: Double, useWallet: Bool) {
        //forAmount used to decide that razor pay will use or not
        var params: [String : Any] = [ APIKeys.it_id.rawValue : self.itinerary.id]
        params[APIKeys.total_amount.rawValue] = grossTotalPayableAmount
        params[APIKeys.currency_code.rawValue] = "INR"//self.itineraryData?.booking_currency ?? ""
        params[APIKeys.use_points.rawValue] = self.itinerary.userPoints
        if UserInfo.loggedInUser != nil {
            params[APIKeys.use_wallet.rawValue] = useWallet ? 1 : 0
            params[APIKeys.wallet_id.rawValue] = useWallet ? (self.paymentDetails?.paymentModes.wallet.id ?? "") : ""
        } else {
            params[APIKeys.use_wallet.rawValue] = 0
            params[APIKeys.wallet_id.rawValue] = ""
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
            guard let self = self else { return }
            if success {
                self.delegate?.makePaymentSuccess(options: options, shouldGoForRazorPay: !(useWallet && forAmount <= 0))
            } else {
                self.delegate?.makePaymentFail()
                //AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
            }
        }
    }
    
    func getPaymentResonse(forData: JSONDictionary, isRazorPayUsed: Bool) {
        
        var params: JSONDictionary = [:]
        
        if isRazorPayUsed {
            params[APIKeys.id.rawValue] = self.itinerary.id
            params[APIKeys.pid.rawValue] = forData[APIKeys.razorpay_payment_id.rawValue] as? String ?? ""
            params[APIKeys.oid.rawValue] = forData[APIKeys.razorpay_order_id.rawValue] as? String ?? ""
            params[APIKeys.sig.rawValue] = forData[APIKeys.razorpay_signature.rawValue] as? String ?? ""
        }
        else {
            //add the params in case of fully wallet payment
            params = forData
        }
        
//        self.delegate?.willGetPaymentResonse()
        APICaller.shared.paymentResponseAPI(params: params) { [weak self](success, errors, bookingIds , cid)  in
            guard let self = self else { return }
            if success {
                self.delegate?.getPaymentResonseSuccess(bookingIds: bookingIds, cid: cid)
            } else {
                self.delegate?.getPaymentResonseFail()
                //AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
            }
        }
    }
    
}
