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
    func getResponseFromConfirmation(_ success:Bool, error:Error?)
    func getResponseFromAddnsMaster(_ success:Bool, error:Error?)
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
    var id = ""//id to get addons data
    var addonsMaster = AddonsMaster()
    //Varialbles for domestic and oneway
    var journey:[Journey]?
    var airportDetailsResult = [String : AirportDetailsWS]()
    var airlineDetailsResult = [String : AirlineMasterWS]()
    
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
    var isdCode = ""
    var itineraryData = FlightItineraryData()
    var delegate:PassengerSelectionVMDelegate?
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
        self.fetchConfirmationData()
        self.journeyType = (self.bookingObject?.isDomestic ?? true) ? .domestic : .international
        guard let bookingObj = self.bookingObject else {return}
        for i in 0..<bookingObj.flightAdultCount{
            var guest = ATContact()
            guest.passengerType = PassengersType.Adult
            guest.frequentFlyer = self.getFrequentFlyer()
            guest.mealPreference = self.getMealfreference()
            guest.numberInRoom = (i + 1)
            guest.id = "\(i + 1)"
            guest.age = 0
            temp.append(guest)
        }
        for i in 0..<bookingObj.flightChildrenCount{
            var guest = ATContact()
            let idx = bookingObj.flightChildrenCount + i + 1
            guest.passengerType = PassengersType.child
            guest.frequentFlyer = self.getFrequentFlyer()
            guest.mealPreference = self.getMealfreference()
            guest.numberInRoom = (i + 1)
            guest.id = "\(idx)"
            guest.age = 0
            temp.append(guest)
        }
        for i in 0..<bookingObj.flightInfantCount{
            var guest = ATContact()
            let idx = bookingObj.flightAdultCount + bookingObj.flightChildrenCount + i + 1
            guest.passengerType = PassengersType.infant
            guest.frequentFlyer = self.getFrequentFlyer()
            guest.mealPreference = self.getMealfreference()
            guest.numberInRoom = (i + 1)
            guest.id = "\(idx)"
            guest.age = 0
            temp.append(guest)
        }
        GuestDetailsVM.shared.guests.append(temp)
        GuestDetailsVM.shared.canShowSalutationError = false
    }
    
    func setupLoginData(){
        if let userInfo = UserInfo.loggedInUser{
            self.email = userInfo.email
            self.mobile = userInfo.mobile
            self.isdCode = userInfo.isd
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
    
    func fetchAddonsData(){
        
        let param = [APIKeys.it_id.rawValue:self.id]
        self.delegate?.startFechingAddnsMasterData()
        APICaller.shared.getAddonsMaster(params: param) {[weak self] (success, errorCode, addonsMaster) in
            guard let self = self else {return}
            self.delegate?.getResponseFromAddnsMaster(success, error: nil)
            if success{
                self.addonsMaster = addonsMaster
            }else{
                debugPrint(errorCode)
            }
        }
        
    }
    
    func fetchConfirmationData(){
        var param:JSONDictionary = ["sid": sid]
        
        if journeyType == .international{
            if flightSearchType == SINGLE_JOURNEY{
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
            self.delegate?.getResponseFromConfirmation(success, error: nil)
            if success{
                if let itinerary = itineraryData{
                    self.itineraryData = itinerary
                    self.id = self.itineraryData.itinerary.id
                    self.sid = self.itineraryData.itinerary.sid
                    GuestDetailsVM.shared.travellerList = self.itineraryData.itinerary.travellerMaster
                    self.fetchAddonsData()
                }
            }else{
                debugPrint(errorCode)
            }
        }
    }

    private func getMealfreference()-> [MealPreference]{
        guard let intJourney = intJourney.first else {
            return []
        }
        let totalFlight = intJourney.legsWithDetail.flatMap{$0.flightsWithDetails}
       
        var mealPreference = [MealPreference]()
        for flight in totalFlight{
            var meal = MealPreference()
            meal.journeyTitle = "\(flight.fr) - \(flight.to)"
            meal.airlineLogo = "\(logoUrl)\(flight.al.uppercased()).png"
            mealPreference.append(meal)
        }
        return mealPreference
    }
    
    
    private func getFrequentFlyer()-> [FrequentFlyer]{
        guard let intJourney = intJourney.first else {
            return []
        }
        let totalFlight = intJourney.legsWithDetail.flatMap{$0.flightsWithDetails}.map{$0.al}
        let setFlightAl = Array(Set(totalFlight))
       
        var frequentFlyer = [FrequentFlyer]()
        for al in setFlightAl{
            var flyer = FrequentFlyer()
            flyer.airlineName = self.intAirlineDetailsResult[al]?.name ?? ""
            flyer.logoUrl = "\(logoUrl)\(al.uppercased()).png"
            frequentFlyer.append(flyer)
        }
        return frequentFlyer
    }
    
}
