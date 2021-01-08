//
//  FlightDetailsVM.swift
//  AERTRIP
//
//  Created by Apple  on 07.07.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol FlightDetailsVMDelegate : NSObjectProtocol{
    func willGetAddToTrip()
    func getResponseForAddToTrip(success:Bool, alreadyAdded: Bool)
}

class FlightDetailsVM{
    
    var sid = ""
    var journey: [Journey]?
    var intJourney:[IntJourney]?
    var journeyType = JourneyType.international
    var itineraryData = FlightItineraryData()
    var selectedTrip:TripModel?
    weak var delegate:FlightDetailsVMDelegate?
    func fetchConfirmationData(_ completion: @escaping((_ isSuccess:Bool, _ errorCode: ErrorCodes)->())){
        var param:JSONDictionary = ["sid": sid]
        
        if journeyType == .international{
            if self.intJourney == nil{
                param["old_farepr[]"] = self.journey?.first?.farepr ?? 0
                param["fk[]"] = self.journey?.first?.fk ?? ""
            }else{
                param["old_farepr[]"] = self.intJourney?.first?.farepr ?? 0
                param["fk[0]"] = self.intJourney?.first?.fk ?? ""
                param["combo"] = true
            }
        }else{
            guard let journey = journey else{return}
            for i in 0..<journey.count{
                param["old_farepr[\(i)]"] = journey[i].farepr
                param["fk[\(i)]"] = journey[i].fk
            }
        }
        APICaller.shared.getConfirmation(params: param) {[weak self](success, errorCode, itineraryData) in
            guard let self = self else{return}

            if let itinerary = itineraryData{
                self.itineraryData = itinerary
            }
            completion(success, errorCode)
        }
    }

    
    func getAddToTripParamForInternation()-> JSONDictionary?{
        guard let journey  = self.intJourney?.first, let trip = self.selectedTrip else { return nil }
        var param = JSONDictionary()
        let flights = journey.legsWithDetail.flatMap{$0.flightsWithDetails}
        param["trip_id"] = trip.id
        for (index, flight) in flights.enumerated(){
            param["eventDetails[\(index)][airline_code]"] = flight.al
            param["eventDetails[\(index)][depart_airport]"] = flight.fr
            param["eventDetails[\(index)][arrival_airport]"] = flight.to
            param["eventDetails[\(index)][flight_number]"] = flight.fn
            param["eventDetails[\(index)][depart_terminal]"] = flight.dtm
            param["eventDetails[\(index)][arrival_terminal]"] = flight.atm
            param["eventDetails[\(index)][cabin_class]"] = flight.cc
            param["eventDetails[\(index)][depart_dt]"] = flight.dd
            param["eventDetails[\(index)][depart_time]"] = flight.dt
            param["eventDetails[\(index)][arrival_dt]"] = flight.ad
            param["eventDetails[\(index)][arrival_time]"] = flight.at
            param["eventDetails[\(index)][equipment]"] = flight.eq
        }
        param["timezone"] = "Automatic"
        return param
    }
    func getAddToTripParamForDomestic()-> JSONDictionary?{
        guard let journeys = self.journey, let trip = self.selectedTrip else { return nil }
        var param = JSONDictionary()
        let legs = journeys.flatMap{$0.leg}
        let flights = legs.flatMap{$0.flights}
        param["trip_id"] = trip.id
        for (index, flight) in flights.enumerated(){
            param["eventDetails[\(index)][airline_code]"] = flight.al
            param["eventDetails[\(index)][depart_airport]"] = flight.fr
            param["eventDetails[\(index)][arrival_airport]"] = flight.to
            param["eventDetails[\(index)][flight_number]"] = flight.fn
            param["eventDetails[\(index)][depart_terminal]"] = flight.dtm
            param["eventDetails[\(index)][arrival_terminal]"] = flight.atm
            param["eventDetails[\(index)][cabin_class]"] = flight.cc
            param["eventDetails[\(index)][depart_dt]"] = flight.dd
            param["eventDetails[\(index)][depart_time]"] = flight.dt
            param["eventDetails[\(index)][arrival_dt]"] = flight.ad
            param["eventDetails[\(index)][arrival_time]"] = flight.at
            param["eventDetails[\(index)][equipment]"] = flight.eq
        }
        param["timezone"] = "Automatic"
        return param
    }
    
    func addToTrip(){
        self.delegate?.willGetAddToTrip()
        var param:JSONDictionary = [:]
        if let intParam = self.getAddToTripParamForInternation(){
            param = intParam
        }else if let domParam = self.getAddToTripParamForDomestic(){
            param = domParam
        }else{
            self.delegate?.getResponseForAddToTrip(success: false, alreadyAdded: false)
            return
        }
        APICaller.shared.addToTripFlight(params: param) {[weak self] (success, error, alreadyAdded) in
            guard let self = self else {return}
            if success{
                self.delegate?.getResponseForAddToTrip(success: success, alreadyAdded: alreadyAdded)
            }else{
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .hotelsSearch)
            }
        }
        
    }
    
}
