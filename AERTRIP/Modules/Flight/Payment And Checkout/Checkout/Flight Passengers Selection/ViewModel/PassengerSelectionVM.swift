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
    func getResponseFromConfirmation(_ success:Bool, error: ErrorCodes)
    func getResponseFromAddnsMaster(_ success:Bool, error:ErrorCodes)
    func getResponseFromGSTValidation(_ success:Bool, error:ErrorCodes)
    func getResponseFromLogin(_ success:Bool, error:ErrorCodes)
}

var logoUrl = AppKeys.airlineMasterBaseUrl

class PassengerSelectionVM  {
    //Common varialbles....
    var bookingTitle:NSAttributedString?
    var bookingObject: BookFlightObject?
    var flightSearchType: FlightSearchType = RETURN_JOURNEY
    var journeyType: JourneyType = .international
    var taxesResult = [String:String]()
    var sid = ""
    var journeyTitle:NSAttributedString?
    var journeyDate:String?
    var id = ""
    var addonsMaster = AddonsMaster()
    var intAirportDetailsResult : [String : IntAirportDetailsWS]!
    var intAirlineDetailsResult : [String : IntAirlineMasterWS]!
    var isSwitchOn = false
    var isLogin:Bool{
        return (UserInfo.loggedInUser != nil)
    }
    var selectedGST = GSTINModel()
    var email = ""
    var mobile = ""
    var isdCode = "+91"
    var manimumContactLimit = 10
    var maximumContactLimit = 10
    var isTravelSefetyRequired  = true
    var isContinueButtonTapped = false
    var itineraryData = FlightItineraryData()
    var newItineraryData = FlightItineraryData()
    weak var delegate:PassengerSelectionVMDelegate?
    
    var freeServiceType:FreeServiveType?{
        guard itineraryData.itinerary.iic else { return nil }
        if self.itineraryData.itinerary.freeMealSeat{
            return .both
        }else if self.itineraryData.itinerary.freeMeal{
            return .meal
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
        AddonsDataStore.shared.resetData()
        guard self.sid != GuestDetailsVM.shared.sid else {
            self.setUpMealAndFrequentFlyerForAlreadyLoaded()
            self.setupLoginData()
            GuestDetailsVM.shared.canShowSalutationError = false
            return
        }
        HCSelectGuestsVM.shared.clearAllSelectedData()
        GuestDetailsVM.shared.sid = self.sid
        GuestDetailsVM.shared.guests.removeAll()
        var temp: [ATContact] = []
        guard let bookingObj = self.bookingObject else {return}
        for i in 0..<bookingObj.flightAdultCount{
            var guest = ATContact()
            guest.passengerType = PassengersType.Adult
            guest.frequentFlyer = self.getFrequentFlyer()
            guest.mealPreference = self.getMealPreference()
            guest.numberInRoom = (i + 1)
            guest.id = "NT_a\(i)"
            guest.apiId = "NT_a\(i)"
            guest.age = 0
            guest.nationality = "India"
            guest.countryCode = "IN"
            temp.append(guest)
        }
      
        for i in 0..<bookingObj.flightChildrenCount{
            var guest = ATContact()
//            let idx = bookingObj.flightChildrenCount + i + 1
            guest.passengerType = PassengersType.Child
            guest.frequentFlyer = self.getFrequentFlyer()
            guest.mealPreference = self.getMealPreference()
            guest.numberInRoom = (i + 1)
            guest.id = "NT_c\(i)"
            guest.apiId = "NT_c\(i)"
            guest.age = 0
            guest.nationality = "India"
            guest.countryCode = "IN"
            temp.append(guest)
        }
        for i in 0..<bookingObj.flightInfantCount{
            var guest = ATContact()
//            let idx = bookingObj.flightAdultCount + bookingObj.flightChildrenCount + i + 1
            guest.passengerType = PassengersType.Infant
            guest.frequentFlyer = self.getFrequentFlyer()
            guest.mealPreference = []//self.getMealPreference()
            guest.numberInRoom = (i + 1)
            guest.id = "NT_i\(i)"
            guest.apiId = "NT_i\(i)"
            guest.age = 0
            guest.nationality = "India"
            guest.countryCode = "IN"
            temp.append(guest)
        }
        self.setupLoginData()
        GuestDetailsVM.shared.guests.append(temp)
        GuestDetailsVM.shared.canShowSalutationError = false
    }
    
    
    func setUpMealAndFrequentFlyerForAlreadyLoaded(){
        
        if var passengers = GuestDetailsVM.shared.guests.first{
            for i in 0..<passengers.count{
                if passengers[i].passengerType != .Infant{
                    passengers[i].frequentFlyer = self.getFrequentFlyer()
                    passengers[i].mealPreference = self.getMealPreference()
                }else{
                    passengers[i].frequentFlyer = self.getFrequentFlyer()
                }
            }
            GuestDetailsVM.shared.guests[0] = passengers
        }
    }
    
    
    
    func setupLoginData(){
        self.journeyType = (self.itineraryData.itinerary.isInternational) ? .international : .domestic
        self.bookingObject?.isDomestic = (!self.itineraryData.itinerary.isInternational)
        if let userInfo = UserInfo.loggedInUser{
            self.email = userInfo.email
            self.mobile = userInfo.mobile
            self.isdCode = (userInfo.isd.isEmpty) ? "+91" : userInfo.isd
        }
        
    }
    
    func webserviceForGetCountryList() {
        APICaller.shared.callGetCountriesListApi {[weak self] success, countries, errorCode in
            guard let _ = self else {return}
            if success {
               // GuestDetailsVM.shared.countries = countries
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
                self.delegate?.getResponseFromGSTValidation(true, error: [])
            }else{
                self.login()
            }
            
        }
    }
    
    
    func setupItineraryData(){
        self.itineraryData = newItineraryData
        self.id = self.itineraryData.itinerary.id
        self.sid = self.itineraryData.itinerary.sid
        GuestDetailsVM.shared.travellerList = self.itineraryData.itinerary.travellerMaster
        if let artpt = self.itineraryData.itinerary.details.apdet{
            self.intAirportDetailsResult = artpt
        }
        self.setupGST()
        self.fetchAddonsData()
        
    }
    
    func fetchAddonsData(){
        
        let param = [APIKeys.it_id.rawValue:self.id]
        self.delegate?.startFechingAddnsMasterData()
        APICaller.shared.getAddonsMaster(params: param) {[weak self] (success, errorCode, addonsMaster) in
            guard let self = self else {return}
            self.delegate?.getResponseFromAddnsMaster(success, error: errorCode)
            if success{
                self.addonsMaster = addonsMaster
                self.setupGuestArray()
            }else{
                debugPrint(errorCode)
            }
        }
        
    }
    
    private func validateGST(){
        self.delegate?.startFechingGSTValidationData()
        let param = ["number":self.selectedGST.GSTInNo]
        APICaller.shared.validateGSTIN(params: param) {[weak self] (success, error, data) in
            self?.delegate?.getResponseFromGSTValidation(success, error: error)
        }
    }

    private func login(){
        self.delegate?.startFechingLoginData()
        let params:JSONDictionary = [APIKeys.loginid.rawValue : self.email.removeLeadingTrailingWhitespaces, APIKeys.password.rawValue : "" , APIKeys.isGuestUser.rawValue : "true"]
        APICaller.shared.loginForPaymentAPI(params: params) { [weak self] (success, logInId, isGuestUser, errors) in
            guard let self = self else { return }
            if success {
                if self.isSwitchOn{
                    self.validateGST()
                }else{
                    self.delegate?.getResponseFromGSTValidation(success, error: errors)
                }
            }else{
                AppToast.default.showToastMessage(message: "Something went wrong")
            }
            self.delegate?.getResponseFromLogin(success, error: errors)
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
            self.selectedGST.billingName = gst.gstCompanyName
            self.selectedGST.companyName = gst.gstCompanyName
            self.selectedGST.GSTInNo = gst.gstNumber
            self.isSwitchOn = !(gst.gstNumber.isEmpty)
        }
        if !self.isSwitchOn{
            self.isSwitchOn = self.itineraryData.itinerary.gstRequired
        }
        
    }
    
    
    func validateGuestData()->(success:Bool, msg:String){
        AddonsDataStore.shared.resetData()
        for contact in GuestDetailsVM.shared.guests[0]{
            if contact.firstName.removeAllWhitespaces.isEmpty || contact.firstName.count < 1  || !contact.firstName.isName || contact.lastName.removeAllWhitespaces.isEmpty || contact.lastName.count < 1 || !contact.lastName.isName || contact.salutation.isEmpty{
                return (false, LocalizedString.fillAllPassengerDetails.localized)
            }else if self.journeyType == .domestic{
                if contact.passengerType == .Infant{
                    return (!(contact.dob.isEmpty), LocalizedString.fillAllPassengerDetails.localized)
                }
            }else{
                if contact.dob.isEmpty || contact.nationality.isEmpty || contact.passportNumber.isEmpty || contact.passportExpiryDate.isEmpty{
                    return (false, LocalizedString.fillAllPassengerDetails.localized)
                }
            }
            if self.itineraryData.itinerary.isAllPaxInfoRequired && contact.passengerType == .Adult{
                if contact.isd.isEmpty{
                    return (false, LocalizedString.fillAllPassengerDetails.localized)
                }else if (contact.contact.isEmpty || self.getOnlyIntiger(contact.contact).count < self.manimumContactLimit || self.getOnlyIntiger(contact.contact).count > self.maximumContactLimit){
                    return (false, LocalizedString.fillAllPassengerDetails.localized)
                }else if !(contact.emailLabel.checkValidity(.Email)){
                    return (false, LocalizedString.fillAllPassengerDetails.localized)
                }
            }
        }
        if self.isdCode.isEmpty{
            return (false, LocalizedString.enterISD.localized)
        }else if (self.mobile.isEmpty || self.mobile.count < self.manimumContactLimit || self.mobile.count > self.maximumContactLimit){
            return (false, LocalizedString.EnterValidMobileNumber.localized)
        }else if !(self.email.checkValidity(.Email)){
            return (false, LocalizedString.EnterEmailAddressMessage.localized)
        }else if self.isSwitchOn{
            if (self.selectedGST.companyName.isEmpty){
                return (false, LocalizedString.enterGSTName.localized)
            }else if (self.selectedGST.billingName.isEmpty){
                return (false, LocalizedString.enterGSTBillName.localized)
            }else if !(self.selectedGST.GSTInNo.checkValidity(.gst)){
                return (false, LocalizedString.notValidGST.localized)
            }
        }
        return (true, "")
    }
    
    private func getOnlyIntiger(_ str: String)->String{
        let newStr = str.lowercased()
        let okayChars = Set("1234567890")
        return newStr.filter {okayChars.contains($0) }
    }
    
}

///Log events for firebase.
extension PassengerSelectionVM{
    func logEvent(with event:FirebaseEventLogs.EventsTypeName){
        FirebaseEventLogs.shared.logFlightCheckoutEvents(with: event)
    }
}
