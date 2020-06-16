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
    func responseFromIteneraryData(success:Bool,error:Error?)
    func getPaymentsMethodsSuccess()
    func getPaymentMethodsFails(errors: ErrorCodes)
    func removeCouponCodeSuccessful(_ appliedCouponData: FlightItineraryData)
    func removeCouponCodeFailed()
    func reconfirmationResponse(_ success:Bool)
    
    func willMakePayment()
    func makePaymentSuccess(options: JSONDictionary, shouldGoForRazorPay: Bool)
    func makePaymentFail()
    
    func getPaymentResonseSuccess(bookingIds: [String], cid: [String])
    func getPaymentResonseFail()
}

class FlightPaymentVM{
    // Save applied coupon data
    var appliedCouponData: FlightItineraryData = FlightItineraryData()
    var itinerary:FlightItinerary{
        return appliedCouponData.itinerary
    }
    var addonsMaster = AddonsMaster()
    var taxesResult = [String:String]()
    var taxAndFeesData = [(name:String,value:Int)]()
    var addonsData = [(name:String,value:Int)]()
    var discountData = [(name:String,value:Int)]()
    var passengers = [ATContact]()
    var parmsForItinerary:JSONDictionary = [:]
    var grossTotalPayableAmount : Double = 0.0 // without wallet amount
    var paymentDetails: PaymentModal? //Payment methods
    var delegate:FlightPaymentVMDelegate?
    var gstDetail = GSTINModel()
    var isGSTOn = false
    var isd = ""
    var mobile = ""
    var email = ""
    var afCount = 0
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
        self.addonsDataDisplay()
        self.discountDataDisplay()
        self.getNumberOfSection()
    }
    
    private func addonsDataDisplay(){
        addonsData.removeAll()
        var taxesDetails : [String:Int] = [String:Int]()
        var addonsDataDict = [taxStruct]()
        guard let addons = self.itinerary.details.fare.addons else {return}
        taxesDetails = addons.details
        for (_, value) in taxesDetails.enumerated() {
            let newObj = taxStruct.init(name: taxesResult[value.key] ?? "", taxVal: value.value)
            addonsDataDict.append(newObj)
        }
        let newDict = Dictionary(grouping: addonsDataDict) { $0.name }
        for ( key , _ ) in newDict {
            let dataArray = newDict[key]
            var newTaxVal = 0
            for i in 0..<dataArray!.count{
                newTaxVal += (dataArray?[i].taxVal ?? 0)
            }
            let newArr = (key,newTaxVal)
            taxAndFeesData.append(newArr)
            
        }
    }
    
    private func discountDataDisplay(){
        discountData.removeAll()
        var taxesDetails : [String:Int] = [String:Int]()
        var addonsDataDict = [taxStruct]()
        guard let discount = self.itinerary.details.fare.discount else {return}
        taxesDetails = discount.details
        for (_, value) in taxesDetails.enumerated() {
            let newObj = taxStruct.init(name: taxesResult[value.key] ?? "", taxVal: value.value)
            addonsDataDict.append(newObj)
        }
        let newDict = Dictionary(grouping: addonsDataDict) { $0.name }
        for ( key , _ ) in newDict {
            let dataArray = newDict[key]
            var newTaxVal = 0
            for i in 0..<dataArray!.count{
                newTaxVal += (dataArray?[i].taxVal ?? 0)
            }
            let newArr = (key,newTaxVal)
            discountData.append(newArr)
            
        }
    }
    
    func createParamForItineraryApi(){
        self.parmsForItinerary[APIKeys.mobile.rawValue] = self.mobile
        self.parmsForItinerary[APIKeys.isd.rawValue] = self.isd
        self.parmsForItinerary[APIKeys.email.rawValue] = self.email
        self.parmsForItinerary[APIKeys.it_id.rawValue] = self.itinerary.id
        self.afCount = 0
        for i in 0..<self.passengers.count{
            self.parmsForItinerary["t[\(i)][\(APIKeys.firstName.rawValue)]"] = self.passengers[i].firstName
            self.parmsForItinerary["t[\(i)][\(APIKeys.lastName.rawValue)]"] = self.passengers[i].lastName
            let type = self.passengers[i].passengerType
            self.parmsForItinerary["t[\(i)][\(APIKeys.pax_type.rawValue)]"] = type.rawValue
            self.parmsForItinerary["t[\(i)][\(APIKeys.salutation.rawValue)]"] = passengers[i].salutation
            if type == .Adult{
                self.parmsForItinerary["t[\(i)][\(APIKeys.mobile.rawValue)]"] = ""
                self.parmsForItinerary["t[\(i)][\(APIKeys.isd.rawValue)]"] = ""
                self.parmsForItinerary["t[\(i)][\(APIKeys.email.rawValue)]"] = ""
            }
            if self.itinerary.isInternational{
                self.parmsForItinerary["t[\(i)][\(APIKeys.dob.rawValue)]"] = self.passengers[i].dob
                self.parmsForItinerary["t[\(i)][\(APIKeys.passportNumber.rawValue)]"] = self.passengers[i].passportNumber
                self.parmsForItinerary["t[\(i)][\(APIKeys.passportExpiryDate.rawValue)]"] = self.passengers[i].passportExpiryDate
                self.parmsForItinerary["t[\(i)][\(APIKeys.passportCountry.rawValue)]"] = self.passengers[i].countryCode
            }else{
                if type == .infant || type == .child{
                    self.parmsForItinerary["t[\(i)][\(APIKeys.dob.rawValue)]"] = self.passengers[i].dob
                }
            }
            let id = (Int(passengers[i].id) != nil) ? self.passengers[i].id : self.generatePaasengerId(index: self.passengers[i].numberInRoom, type: type)
            self.parmsForItinerary["t[\(i)][\(APIKeys.paxId.rawValue)]"] = id
            self.parmsForItinerary["t[\(i)][upid]"] = id
            self.checkForMeal(id: id, passenger: passengers[i])
            self.checkForFrequentFlyer(id: id, passenger: passengers[i])
        }
        if self.isGSTOn{
            self.parmsForItinerary["gst[number]"] = self.gstDetail.GSTInNo
            self.parmsForItinerary["gst[company_name]"] = self.gstDetail.companyName
            self.parmsForItinerary["gst[address_line1]"] = self.gstDetail.billingName
        }

    }
    
    private func generatePaasengerId(index:Int, type:PassengersType)-> String{
        switch type{
        case .Adult:
            return "NT_a\(index - 1)"
        case .child:
            return "NT_c\(index - 1)"
        case .infant:
            return "NT_i\(index - 1)"
        }
    }
    
    private func checkForMeal(id:String, passenger:ATContact){
        let meals = passenger.mealPreference.filter{!($0.preferenceCode.isEmpty)}
        for meal in meals{
            for ffk in meal.ffk{
                self.parmsForItinerary["apf[\(self.afCount)]"] = "\(meal.lfk)|\(ffk)|\(id)|preference|meal|\(meal.preferenceCode)|null"
                self.afCount += 1
            }
        }
    }
    private func checkForFrequentFlyer(id:String, passenger:ATContact){
        let ffs = passenger.frequentFlyer.filter{!($0.number.isEmpty)}
        for ff in ffs{
            let code = ff.airlineCode.uppercased()
            for legs in self.addonsMaster.legs.values{
                for flight in legs.flight{
                    if flight.frequenFlyer[code] != nil{
                        self.parmsForItinerary["apf[\(self.afCount)]"] = "\(legs.legId)|\(flight.flightId)|\(id)|ff|\(code)|\(ff.number)|null"
                        self.afCount += 1
                    }
                }
            }
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
    
    /// To get Itenerary Data from API
    func getItineraryData(){
         self.taxesDataDisplay()
         self.delegate?.fetchingItineraryData()
         self.createParamForItineraryApi()
         APICaller.shared.getItineraryData(params: self.parmsForItinerary, itId: self.itinerary.id) { (success, error, itinerary) in
             if success, let iteneraryData = itinerary{
                 self.appliedCouponData = iteneraryData
                 self.taxesDataDisplay()
             }
             self.delegate?.responseFromIteneraryData(success: success, error: nil)
         }
         
     }
     
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
