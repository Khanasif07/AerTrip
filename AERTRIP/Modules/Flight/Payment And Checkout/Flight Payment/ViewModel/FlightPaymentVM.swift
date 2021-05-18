//
//  FlightPaymentVM.swift
//  AERTRIP
//
//  Created by Apple  on 03.06.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation

protocol FlightPaymentVMDelegate:NSObjectProtocol {
    func fetchingItineraryData()
    func responseFromIteneraryData(success:Bool, error: ErrorCodes)
    func willGetPaymetMenthods()
    func getPaymentsMethodsSuccess(_ isWalletChnaged: Bool)
    func getPaymentMethodsFails(error: ErrorCodes)
    func removeCouponCodeSuccessful(_ appliedCouponData: FlightItineraryData)
    func removeCouponCodeFailed(error: ErrorCodes)
    func reconfirmationResponse(_ success:Bool, error: ErrorCodes)
    
    func willMakePayment()
    func makePaymentSuccess(options: JSONDictionary, shouldGoForRazorPay: Bool)
    func makePaymentFail(error: ErrorCodes)
    
    func getPaymentResonseSuccess(bookingIds: [String], cid: [String])
    func getPaymentResponseWithPendingPayment(_ p:String, id:String)
    func getPaymentResonseFail(error: ErrorCodes)
    
    func getUpdateCurrencyResponse(success:Bool)
    
    
}

class FlightPaymentVM{
    // Save applied coupon data
    var appliedCouponData: FlightItineraryData = FlightItineraryData()
    var itinerary:FlightItinerary{
        return appliedCouponData.itinerary
    }
    var addonsMaster = AddonsMaster()
    var taxesResult = [String:String]()
    var taxAndFeesData = [(name:String,value:Double)]()
    var addonsData = [(name:String,value:Double)]()
    var discountData = [(name:String,value:Double)]()
//    var parmsForItinerary:JSONDictionary = [:]
    var grossTotalPayableAmount : Double = 0.0 // without wallet amount
    var paymentDetails: PaymentModal? //Payment methods
    weak var delegate:FlightPaymentVMDelegate?
    var gstDetail = GSTINModel()
    var bookingObject:BookFlightObject?
    var isGSTOn = false
    var isd = ""
    var mobile = ""
    var email = ""
    var isApplyingCoupon = false
    //Setup for section header and cell
    var sectionTableCell = [[CellType]]()
    var sectionHeader = [sectionType]()
    
    enum CellType{
        case CouponCell,WalletCell, TermsConditionCell,FareDetailsCell,EmptyCell,DiscountCell,WalletAmountCell,FinalAmountCell,FareBreakupCell,TotalPayableNowCell,ConvenienceCell
    }
    enum sectionType{
        case CouponsAndWallet,Taxes,Discount,Addons,TotalPaybleAndTC
    }
    
    func taxesDataDisplay(){
        taxAndFeesData.removeAll()
        var taxesDetails : [String:Double] = [String:Double]()
        var taxAndFeesDataDict = [taxStruct]()
        var sortOrderArr = [String]()
        taxesDetails = self.itinerary.details.fare.taxes.details
        for val in self.itinerary.details.fare.sortOrder.components(separatedBy: ","){
            sortOrderArr.append(taxesResult[val.removeAllWhitespaces] ?? "")
        }
        for (_, value) in taxesDetails.enumerated() {
            let newObj = taxStruct.init(name: taxesResult[value.key] ?? "", taxVal: value.value)
            taxAndFeesDataDict.append(newObj)
        }
        let newDict = Dictionary(grouping: taxAndFeesDataDict) { $0.name }
        if sortOrderArr.isEmpty{
            for ( key , _ ) in newDict {
                let dataArray = newDict[key] ?? []
                var newTaxVal: Double = 0
                for i in 0..<dataArray.count {
                    newTaxVal += (dataArray[i].taxVal)
                }
                let newArr = (key,newTaxVal)
                taxAndFeesData.append(newArr)
            }
        }else{
            for key in sortOrderArr {
                let dataArray = newDict[key] ?? []
                var newTaxVal: Double = 0
                for i in 0..<dataArray.count {
                    newTaxVal += (dataArray[i].taxVal )
                }
                let newArr = (key,newTaxVal)
                taxAndFeesData.append(newArr)
            }
        }
        
        self.addonsDataDisplay()
        self.discountDataDisplay()
        self.getNumberOfSection()
    }
    
    private func addonsDataDisplay(){
        addonsData.removeAll()
        var taxesDetails : [String:Double] = [String:Double]()
        var addonsDataDict = [taxStruct]()
        guard let addons = self.itinerary.details.fare.addons else {return}
        taxesDetails = addons.details
        for (_, value) in taxesDetails.enumerated() {
            let newObj = taxStruct.init(name: taxesResult[value.key] ?? "", taxVal: value.value)
            addonsDataDict.append(newObj)
        }
        let newDict = Dictionary(grouping: addonsDataDict) { $0.name }
        for ( key , _ ) in newDict {
            let dataArray = newDict[key] ?? []
            var newTaxVal: Double = 0
            for i in 0..<dataArray.count{
                newTaxVal += (dataArray[i].taxVal )
            }
            let newArr = (key,newTaxVal)
            addonsData.append(newArr)
            
        }
    }
    
    private func discountDataDisplay(){
        discountData.removeAll()
        var taxesDetails : [String:Double] = [String:Double]()
        var addonsDataDict = [taxStruct]()
        guard let discount = self.itinerary.details.fare.discount else {return}
        taxesDetails = discount.details
        for (_, value) in taxesDetails.enumerated() {
            let newObj = taxStruct.init(name: taxesResult[value.key] ?? "", taxVal: value.value)
            addonsDataDict.append(newObj)
        }
        let newDict = Dictionary(grouping: addonsDataDict) { $0.name }
        for ( key , _ ) in newDict {
            let dataArray = newDict[key] ?? []
            var newTaxVal: Double = 0
            for i in 0..<dataArray.count{
                newTaxVal += (dataArray[i].taxVal )
            }
            let newArr = (key,newTaxVal)
            discountData.append(newArr)
            
        }
    }
    
    private func getNumberOfSection(){
        self.sectionHeader = []
        self.sectionTableCell = []
        var firstSectionData = [CellType]()
        firstSectionData.append(contentsOf: [.EmptyCell, .CouponCell,.EmptyCell,.WalletCell,.EmptyCell,.FareBreakupCell])
        self.sectionTableCell.append(firstSectionData)
        self.sectionHeader.append(.CouponsAndWallet)
        //For Taxes and other fee
        var secondSectionCell = [CellType]()
        for _ in self.taxAndFeesData{
            secondSectionCell.append(.DiscountCell)
        }
        self.sectionTableCell.append(secondSectionCell)
        self.sectionHeader.append(.Taxes)
        //Discount Cell
        if !self.discountData.isEmpty{
            var thirdSection = [CellType]()
            for _ in self.discountData{
                thirdSection.append(.DiscountCell)
            }
            self.sectionTableCell.append(thirdSection)
            self.sectionHeader.append(.Discount)
        }
        //Addons Cell
        if !self.addonsData.isEmpty{
            var fourthSection = [CellType]()
            for _ in self.addonsData{
                fourthSection.append(.DiscountCell)
            }
            self.sectionTableCell.append(fourthSection)
            self.sectionHeader.append(.Addons)
        }
       //Totalpayble and TC
        self.sectionTableCell.append([.WalletAmountCell,.WalletAmountCell,.TotalPayableNowCell,.ConvenienceCell,.FinalAmountCell,.TermsConditionCell])
        self.sectionHeader.append(.TotalPaybleAndTC)
        
    }
    
}
//MARK:- API Call
extension FlightPaymentVM{
    
     func webServiceGetPaymentMethods(isWalletChnaged: Bool) {
         let params: JSONDictionary = [APIKeys.it_id.rawValue:  self.itinerary.id]
         printDebug(params)
        self.delegate?.willGetPaymetMenthods()
         APICaller.shared.getPaymentMethods(params: params) { [weak self] success, errors,paymentDetails in
             guard let sSelf = self else { return }
             if success {
                 sSelf.paymentDetails = paymentDetails
                 sSelf.delegate?.getPaymentsMethodsSuccess(isWalletChnaged)
             } else {
                 printDebug(errors)
                sSelf.delegate?.getPaymentMethodsFails(error: errors)
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
                sSelf.delegate?.removeCouponCodeFailed(error: errors)
            }
        }
    }
    
    
    func reconfirmationAPI(useWallet: Bool) {
        var params: [String : Any] = [ APIKeys.it_id.rawValue : self.itinerary.id ]
        if useWallet{
            params["via_wallet"] = 1
        }else{
            params["via_wallet"] = 0
        }
        APICaller.shared.flightReconfirmationApi(params: params, loader: true) { [weak self] (success, errors, appliedCouponData) in
            guard let self = self else { return }
            if success {
//                printDebug(appliedCouponData)
                if let appliedCouponDetails = appliedCouponData {
                    self.appliedCouponData.itinerary = appliedCouponDetails.itinerary
                }
            }
            self.delegate?.reconfirmationResponse(success, error: errors)
        }
    }
    
    func makePayment(forAmount: Double, useWallet: Bool) {
        //forAmount used to decide that razor pay will use or not
        var params: [String : Any] = [ APIKeys.it_id.rawValue : self.itinerary.id]
        params[APIKeys.total_amount.rawValue] = grossTotalPayableAmount
        params[APIKeys.currency_code.rawValue] = UserInfo.preferredCurrencyDetails?.currencyCode//"INR"
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
                self.delegate?.makePaymentFail(error: errors)
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
        printDebug(params)
        APICaller.shared.flightPaymentResponseAPI(params: params) { [weak self](success, errors, jsonData)  in
            guard let self = self else { return }
            if success, let json = jsonData {
                let bIds = json[APIKeys.booking_id.rawValue].arrayValue.map{$0.stringValue}
                let cid = json[APIKeys.cid.rawValue].arrayValue.map{$0.stringValue}
                if !bIds.isEmpty || !cid.isEmpty{
                    self.delegate?.getPaymentResonseSuccess(bookingIds: bIds, cid: cid)
                }else{
                    let p = json["p"].stringValue
                    let id = json[APIKeys.id.rawValue].stringValue
                    self.delegate?.getPaymentResponseWithPendingPayment(p, id: id)
                }
            } else {
                self.delegate?.getPaymentResonseFail(error: errors)
            }
        }
    }
    
    func getItineraryDetails(with id: String, completionBlock: @escaping((_ success:Bool, _ data:FlightItinerary?, _ error: ErrorCodes)->())){
        let param = [APIKeys.it_id.rawValue: id]
        APICaller.shared.getItinerayDataForPendingPayment(params: param) {(success, error, data) in
            completionBlock(success, data, error)
        }
    }
    
    func updateConvenienceFee(){
        if self.paymentDetails != nil{
            self.paymentDetails?.paymentModes.razorPay = self.appliedCouponData.itinerary.paymentModes.razorPay
        }
    }
    
    func getCouponsDetailsApi(completion: @escaping((_ success:Bool, _ couponData: [HCCouponModel], _ error:ErrorCodes)->())) {

        let params: [String : Any] = [ APIKeys.it_id.rawValue : self.itinerary.id , APIKeys.product.rawValue : CouponFor.flights.rawValue]
        APICaller.shared.getCouponDetailsApi(params: params, loader: true ) { (success, errors, couponsDetails) in
            completion(success, couponsDetails, errors)
            
        }
    }
    
    
    func updateCurrency(useWallet: Bool){
        APICaller.shared.getCurrencies {[weak self] (success, _) in
            guard let self = self else {return}
            self.delegate?.getUpdateCurrencyResponse(success: success)
            if success{
                self.reconfirmationAPI(useWallet: useWallet)
            }
            
        }
    }
    
    
}
