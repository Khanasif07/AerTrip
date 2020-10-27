//
//  PostBookingAddonsPaymentVM.swift
//  AERTRIP
//
//  Created by Apple  on 18.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol  PostBookingAddonsPaymentVMDelegate:NSObjectProtocol {
    func willMakePayment()
    func makePaymentSuccess(options: JSONDictionary, shouldGoForRazorPay: Bool)
    func makePaymentFail(error:ErrorCodes)
    func getPaymentResonseSuccess(bookingIds: [String], cid: [String])
    func getPaymentResonseFail(error:ErrorCodes)
    
}


class PostBookingAddonsPaymentVM{

    var addonsDetails = AddonsQuotationsModel()
    var seatData = [CustomAddonsModel]()
    var mealData = [CustomAddonsModel]()
    var baggageData = [CustomAddonsModel]()
    var otherData = [CustomAddonsModel]()
    var grossTotalPayableAmount : Double = 0.0 // without wallet amount
//    var paymentDetails: PaymentMode? //Payment methods
    var bookingIds = [String]()
    weak var delegate:PostBookingAddonsPaymentVMDelegate?
    var sectionTableCell = [[CellType]]()
    var sectionHeader = [sectionType]()
    
    enum CellType{
        case WalletCell, TermsConditionCell,FareDetailsCell,EmptyCell,DiscountCell,WalletAmountCell,FareBreakupCell,TotalPayableNowCell
    }
    enum sectionType{
        case CouponsAndWallet, Seat, Meal, Baggage, Other, TotalPaybleAndTC
    }
    
    func taxesDataDisplay(){
        self.setSectionDataForAddons()
        self.getNumberOfSection()
    }
    
    private func getNumberOfSection(){
        
        self.sectionHeader = []
        self.sectionTableCell = []
        var firstSectionData = [CellType]()
        firstSectionData.append(.EmptyCell)
        if (UserInfo.loggedInUser != nil && self.addonsDetails.walletBalance > 0){
            firstSectionData.append(contentsOf: [.WalletCell,.EmptyCell])
        }
        firstSectionData.append(.FareBreakupCell)
//        firstSectionData.append(contentsOf: [.EmptyCell,.WalletCell,.EmptyCell,.FareBreakupCell])
        self.sectionTableCell.append(firstSectionData)
        self.sectionHeader.append(.CouponsAndWallet)

        //Seat data
        if !self.seatData.isEmpty{
            var sectionCell = [CellType]()
            for _ in self.seatData{
                sectionCell.append(.DiscountCell)
            }
            self.sectionTableCell.append(sectionCell)
            self.sectionHeader.append(.Seat)
        }
        
        //Meal data
        if !self.mealData.isEmpty{
            var sectionCell = [CellType]()
            for _ in self.mealData{
                sectionCell.append(.DiscountCell)
            }
            self.sectionTableCell.append(sectionCell)
            self.sectionHeader.append(.Meal)
        }
        
        //Baggage data
        if !self.baggageData.isEmpty{
            var sectionCell = [CellType]()
            for _ in self.baggageData{
                sectionCell.append(.DiscountCell)
            }
            self.sectionTableCell.append(sectionCell)
            self.sectionHeader.append(.Baggage)
        }
        
        //Other data
        if !self.otherData.isEmpty{
            var sectionCell = [CellType]()
            for _ in self.otherData{
                sectionCell.append(.DiscountCell)
            }
            self.sectionTableCell.append(sectionCell)
            self.sectionHeader.append(.Other)
        }
        
        //Totalpayble and TC
        self.sectionTableCell.append([.WalletAmountCell,.WalletAmountCell,.TotalPayableNowCell,.TermsConditionCell])
        self.sectionHeader.append(.TotalPaybleAndTC)
        
    }
    
    func setSectionDataForAddons(){
        seatData = []
        mealData = []
        baggageData = []
        otherData = []
        for leg in self.addonsDetails.details.leg{
            for flight in leg.flights{
                for pax in flight.pax{
                    if !pax.addon.seat.name.isEmpty{
                        seatData.append(CustomAddonsModel(legId: "\(leg.legID)", flight:flight, pax:pax, addonsType: .seat))
                    }
                    if !pax.addon.meal.name.isEmpty{
                        seatData.append(CustomAddonsModel(legId: "\(leg.legID)", flight:flight, pax:pax, addonsType: .meal))
                    }
                    if !pax.addon.baggage.name.isEmpty{
                        seatData.append(CustomAddonsModel(legId: "\(leg.legID)", flight:flight, pax:pax, addonsType: .baggage))
                    }
                    if !pax.addon.other.name.isEmpty{
                        seatData.append(CustomAddonsModel(legId: "\(leg.legID)", flight:flight, pax:pax, addonsType: .other))
                    }
                }
            }
        }
    }
    
    
    
}
//MARK:- API Call
extension PostBookingAddonsPaymentVM{
    
    func makePayment(forAmount: Double, useWallet: Bool) {
        //forAmount used to decide that razor pay will use or not
        var params: [String : Any] = [ APIKeys.it_id.rawValue : self.addonsDetails.id]
        params[APIKeys.total_amount.rawValue] = grossTotalPayableAmount
        params[APIKeys.currency_code.rawValue] = "INR"//self.itineraryData?.booking_currency ?? ""
        params[APIKeys.use_points.rawValue] = self.addonsDetails.userPoints
        if UserInfo.loggedInUser != nil {
            params[APIKeys.use_wallet.rawValue] = useWallet ? 1 : 0
            params[APIKeys.wallet_id.rawValue] = useWallet ? (self.addonsDetails.paymentModes.wallet.id) : ""
        } else {
            params[APIKeys.use_wallet.rawValue] = 0
            params[APIKeys.wallet_id.rawValue] = ""
            printDebug("No wallet id required.")
        }
        
        
        var paymentMethod = ""
        if (useWallet && forAmount <= 0) {
            paymentMethod = self.addonsDetails.paymentModes.wallet.id
        }
        else {
            paymentMethod = self.addonsDetails.paymentModes.razorPay.id
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
                self.delegate?.makePaymentFail(error: errors)
                //AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
            }
        }
    }
    
    func getPaymentResonse(forData: JSONDictionary, isRazorPayUsed: Bool) {
        
        var params: JSONDictionary = [:]
        
        if isRazorPayUsed {
            params[APIKeys.id.rawValue] = self.addonsDetails.id
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
                self.delegate?.getPaymentResonseFail(error: errors)
                //AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
            }
        }
    }
    
}
