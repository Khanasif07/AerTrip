//
//  PassengerSelectionVM.swift
//  Aertrip
//
//  Created by Apple  on 05.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation

protocol PassengerSelectionVMDelegate:NSObjectProtocol {
    func startFechingConfirmationData()
    func startFechingAddnsMasterData()
    func startFechingGSTValidationData()
    func startFechingLoginData()
    func getResponseFromConfirmation(_ success:Bool, error:Error?)
    func getResponseFromAddnsMaster(_ success:Bool, error:Error?)
    func getResponseFromGSTValidation(_ success:Bool, error:Error?)
    func getResponseFromLogin(_ success:Bool, error:Error?)
}

var logoUrl = "http://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/"

class PassengerSelectionVM  {
    //Common varialbles....
    var bookingTitle:NSAttributedString?
    var bookingObject: BookFlightObject?
    var flightSearchType: FlightSearchType = RETURN_JOURNEY
    var journeyType: JourneyType = .international
    var taxesResult = [String:String]()
    var sid = ""
    var selectedJourneyFK = [String]()
    var journeyTitle:NSAttributedString?
    var journeyDate:String?
    var id = ""
    var addonsMaster = AddonsMaster()
    //Varialbles for domestic and oneway
    var journey:[Journey]?
    //Varialbles for international return and multicity
    var intAirportDetailsResult : [String : IntAirportDetailsWS]!
    var intAirlineDetailsResult : [String : IntAirlineMasterWS]!
    var intJourney: [IntJourney]!
    var intFlights : [IntFlightDetail]?
    var isSwitchOn = false
    var isLogin:Bool{
        return (UserInfo.loggedInUser != nil)
    }
    var selectedGST = GSTINModel()
    var passengerList = [Passenger]()
    var email = ""
    var mobile = ""
    var isdCode = "+91"
    var manimumContactLimit = 10
    var maximumContactLimit = 10
    var itineraryData = FlightItineraryData()
    var delegate:PassengerSelectionVMDelegate?
    
    var freeServiceType:FreeServiveType?{
        if self.itineraryData.itinerary.freeMeal && self.itineraryData.itinerary.freeMealSeat{
            return .both
        }else if self.itineraryData.itinerary.freeMeal{
            return .meal
        }else if self.itineraryData.itinerary.freeMealSeat{
            return .seat
        }else{
            return nil
        }
    }
    
    var totalPassengerCount:Int{
        if let bookingObj = self.bookingObject{
            return bookingObj.flightAdultCount + bookingObj.flightChildrenCount + bookingObj.flightInfantCount
        }else{
            return 0
        }
    }
    
    func setupGuestArray() {
        GuestDetailsVM.shared.guests.removeAll()
        var temp: [ATContact] = []
        guard let bookingObj = self.bookingObject else {return}
        for i in 0..<bookingObj.flightAdultCount{
            var guest = ATContact()
            guest.passengerType = PassengersType.Adult
            guest.frequentFlyer = self.getFrequentFlyer()
            guest.mealPreference = self.getMealPreference()
            guest.numberInRoom = (i + 1)
//            guest.id = "\(i + 1)"
            guest.age = 0
            temp.append(guest)
        }
        for i in 0..<bookingObj.flightChildrenCount{
            var guest = ATContact()
//            let idx = bookingObj.flightChildrenCount + i + 1
            guest.passengerType = PassengersType.child
            guest.frequentFlyer = self.getFrequentFlyer()
            guest.mealPreference = self.getMealPreference()
            guest.numberInRoom = (i + 1)
//            guest.id = "\(idx)"
            guest.age = 0
            temp.append(guest)
        }
        for i in 0..<bookingObj.flightInfantCount{
            var guest = ATContact()
//            let idx = bookingObj.flightAdultCount + bookingObj.flightChildrenCount + i + 1
            guest.passengerType = PassengersType.infant
            guest.frequentFlyer = self.getFrequentFlyer()
            guest.mealPreference = []//self.getMealPreference()
            guest.numberInRoom = (i + 1)
//            guest.id = "\(idx)"
            guest.age = 0
            temp.append(guest)
        }
        GuestDetailsVM.shared.guests.append(temp)
        GuestDetailsVM.shared.canShowSalutationError = false
    }
    
    func setupLoginData(){
        self.journeyType = (self.bookingObject?.isDomestic ?? true) ? .domestic : .international
        if let userInfo = UserInfo.loggedInUser{
            self.email = userInfo.email
            self.mobile = userInfo.mobile
            self.isdCode = (userInfo.isd.isEmpty) ? "+91" : userInfo.isd
        }
        
    }
    
    func webserviceForGetCountryList() {
        APICaller.shared.callGetCountriesListApi { success, countries, errorCode in
            if success {
                GuestDetailsVM.shared.countries = countries
            } else {
                debugPrint(errorCode)
            }
        }
    }
    
    func checkValidationForNextScreen(){
        if self.isSwitchOn{
            if self.isLogin{
                self.validateGST()
            }else{
                self.login()
            }
        }else{
            if self.isLogin{
                self.delegate?.getResponseFromGSTValidation(true, error: nil)
            }else{
                self.login()
            }
            
        }
    }
    
    func fetchAddonsData(){
        
        let param = [APIKeys.it_id.rawValue:self.id]
        self.delegate?.startFechingAddnsMasterData()
        APICaller.shared.getAddonsMaster(params: param) {[weak self] (success, errorCode, addonsMaster) in
            guard let self = self else {return}
            self.delegate?.getResponseFromAddnsMaster(success, error: nil)
            if success{
                self.addonsMaster = addonsMaster
                self.setupGuestArray()
            }else{
                debugPrint(errorCode)
            }
        }
        
    }
    
    func fetchConfirmationData(){
        var param:JSONDictionary = ["sid": sid]
        
        if journeyType == .international{
            if self.intJourney == nil{
                param["old_farepr[]"] = self.journey?.first?.farepr ?? 0
                param["fk[]"] = self.journey?.first?.fk ?? ""
            }else{
                param["old_farepr[]"] = self.intJourney?.first?.farepr ?? 0
                param["fk[]"] = self.intJourney?.first?.fk ?? ""
                param["combo"] = true
            }
        }else{
            guard let journey = journey else{return}
            for i in 0..<journey.count{
                param["old_farepr[\(i)]"] = journey[i].farepr
                param["fk[\(i)]"] = journey[i].fk
            }
        }
        self.delegate?.startFechingConfirmationData()
        APICaller.shared.getConfirmation(params: param) {[weak self](success, errorCode, itineraryData) in
            guard let self = self else{return}
            if success{
                if let itinerary = itineraryData{
                    self.itineraryData = itinerary
                    self.id = self.itineraryData.itinerary.id
                    self.sid = self.itineraryData.itinerary.sid
                    GuestDetailsVM.shared.travellerList = self.itineraryData.itinerary.travellerMaster
                    if let artpt = self.itineraryData.itinerary.details.apdet{
                        self.intAirportDetailsResult = artpt
                    }
                    self.setupGST()
                }
            }else{
                debugPrint(errorCode)
            }
            self.delegate?.getResponseFromConfirmation(success, error: nil)
            if success{
                self.fetchAddonsData()
            }
        }
    }
    
    private func validateGST(){
        self.delegate?.startFechingGSTValidationData()
        let param = ["number":self.selectedGST.GSTInNo]
        APICaller.shared.validateGSTIN(params: param) { (success, error, data) in
            self.delegate?.getResponseFromGSTValidation(success, error: nil)
        }
    }

    private func login(){
        let params:JSONDictionary = [APIKeys.loginid.rawValue : self.email.removeLeadingTrailingWhitespaces, APIKeys.password.rawValue : "" , APIKeys.isGuestUser.rawValue : "true"]
        APICaller.shared.loginForPaymentAPI(params: params) { [weak self] (success, logInId, isGuestUser, errors) in
            guard let self = self else { return }
            if success {
                if self.isSwitchOn{
                    self.validateGST()
                }else{
                    self.delegate?.getResponseFromGSTValidation(success, error: nil)
                }
            }else{
                AppToast.default.showToastMessage(message: "Something went wrong")
            }
        }
    }
    
    private func getMealPreference()-> [MealPreference]{
        let legs = self.itineraryData.itinerary.details.legsWithDetail
        var mealPreference = [MealPreference]()
        for leg in legs{
            if let addonsdata = self.addonsMaster.legs["\(leg.lfk)"],!(addonsdata.preference.meal.isEmpty){
                var meal = MealPreference()
                meal.journeyTitle = "\(leg.originIATACode) - \(leg.destinationIATACode)"
                let al = leg.flightsWithDetails.first?.al ?? ""
                meal.airlineLogo = "\(logoUrl)\(al.uppercased()).png"
                meal.preference = addonsdata.preference.meal
                meal.lfk = leg.lfk
                meal.ffk = addonsdata.flight.map{$0.flightId}
                mealPreference.append(meal)
            }
        }
        return mealPreference
    }
    
    
    private func getFrequentFlyer()-> [FrequentFlyer]{
        let totalFlight = Array(self.addonsMaster.legs.values).flatMap{$0.flight}
        var frequentFlyer = [FrequentFlyer]()
        if let aldet = self.itineraryData.itinerary.details.aldet{
            for (key, value) in aldet{
                if let flight = totalFlight.first(where: {$0.frequenFlyer[key] != nil}), flight.isfrequentFlyer{
                    var flyer = FrequentFlyer()
                    flyer.airlineName = value
                    flyer.airlineCode = key.uppercased()
                    flyer.logoUrl = "\(logoUrl)\(key.uppercased()).png"
                    frequentFlyer.append(flyer)
                }
            }
        }
        return frequentFlyer
    }
    
    private func setupGST(){
        if let gst = self.itineraryData.itinerary.travellerDetails.gstDetails, isLogin{
            self.isSwitchOn = true
            self.selectedGST.billingName = gst.gstCompanyName
            self.selectedGST.companyName = gst.gstCompanyName
            self.selectedGST.GSTInNo = gst.gstNumber
        }
    }
    
    
    func validateGuestData()->(success:Bool, msg:String){
        for contact in GuestDetailsVM.shared.guests[0]{
            if contact.firstName.isEmpty || contact.firstName.count < 3 || contact.lastName.isEmpty || contact.lastName.count < 3 || contact.salutation.isEmpty{
                return (false, "Please fill all the passenger details")
            }else if self.journeyType == .domestic{
                if contact.passengerType == .infant{
                    return (!(contact.dob.isEmpty), "Please fill all the passenger details")
                }
            }else{
                if contact.dob.isEmpty || contact.nationality.isEmpty || contact.passportNumber.isEmpty || contact.passportExpiryDate.isEmpty{
                    return (false, "Please fill all the passenger details")
                }
            }
        }
        if self.isdCode.isEmpty{
            return (false, "Please enter ISD code")
        }else if (self.mobile.isEmpty || self.mobile.count < self.manimumContactLimit || self.mobile.count > self.maximumContactLimit){
            return (false, "Please enter valid mobile number")
        }else if !(self.email.checkValidity(.Email)){
            return (false, "Not a valid email address")
        }else if self.isSwitchOn{
            if (self.selectedGST.companyName.isEmpty){
                return (false, "Please enter GSTIN company name")
            }else if (self.selectedGST.billingName.isEmpty){
                return (false, "Please enter GSTIN billing name")
            }else if !(self.selectedGST.GSTInNo.checkValidity(.gst)){
                return (false, "Not a valid GSTIN Number")
            }
        }
        return (true, "")
    }
    
}
