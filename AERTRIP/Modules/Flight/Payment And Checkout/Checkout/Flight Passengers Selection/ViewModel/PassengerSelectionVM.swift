//
//  PassengerSelectionVM.swift
//  Aertrip
//
//  Created by Apple  on 05.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation

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
    
//    func getPasseger(){
//        passengerList = []
//        guard let bookingObj = self.bookingObject else {return}
//        for i in 0..<bookingObj.flightAdultCount{
//            var passenger = Passenger()
//            passenger.passengerType = PassengerType.adult
//            passenger.frequentFlyer = self.getFrequentFlyer()
//            passenger.mealPreference = self.getMealfreference()
//            passenger.title = "\(PassengerType.adult.rawValue) \(i+1)".capitalized
//            passengerList.append(passenger)
//        }
//        for i in 0..<bookingObj.flightChildrenCount{
//            var passenger = Passenger()
//            passenger.passengerType = PassengerType.child
//            passenger.frequentFlyer = self.getFrequentFlyer()
//            passenger.mealPreference = self.getMealfreference()
//            passenger.title = "\(PassengerType.child.rawValue) \(i+1)".capitalized
//            passengerList.append(passenger)
//        }
//        for i in 0..<bookingObj.flightInfantCount{
//            var passenger = Passenger()
//            passenger.passengerType = PassengerType.infant
//            passenger.frequentFlyer = self.getFrequentFlyer()
//            passenger.mealPreference = self.getMealfreference()
//            passenger.title = "\(PassengerType.infant.rawValue) \(i+1)".capitalized
//            passengerList.append(passenger)
//        }
//    }
    
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
