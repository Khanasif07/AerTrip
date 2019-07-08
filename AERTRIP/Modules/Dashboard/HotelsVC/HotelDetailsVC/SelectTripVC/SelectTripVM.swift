//
//  SelectTripVM.swift
//  AERTRIP
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SelectTripVMDelegate: class {
    func willFetchAllTrips()
    func fetchAllTripsSuccess()
    func fetchAllTripsFail()
    
    func willMoveAndUpdateTripAPI()
    func moveAndUpdateTripAPISuccess()
    func moveAndUpdateTripAPIFail()
}

class SelectTripVM {
    
    //MARK:- Properties
    //MARK:- Public
    var selectedIndexPath: IndexPath?
    var delegate: SelectTripVMDelegate?
    var tripDetails: TripDetails?
    
    var allTrips: [TripModel] = []
    
    var eventId: String = ""
    
    var isFromBooking: Bool = false
    
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Private

    
    //MARK:- Public
    func fetchAllTrips() {
        self.delegate?.willFetchAllTrips()
        
        APICaller.shared.getAllTripsAPI { (success, errors, trips, defaultTrip) in
            self.allTrips = trips
            self.delegate?.fetchAllTripsSuccess()
        }
    }
    
    func moveAndUpdateTripAPI(selectedTrip: TripModel) {
        var param: JSONDictionary = ["is_delete": 1]
        param["trip_id"] = tripDetails?.trip_id ?? ""
        param["event_id[]"] = tripDetails?.event_id ?? ""
        param["move_id[]"] = selectedTrip.id
        
        self.delegate?.willMoveAndUpdateTripAPI()
        APICaller.shared.tripsEventMoveAPI(params: param) { [weak self](success, errors, eventId) in
            guard let sSelf = self else {return}
            if success, let id = eventId {
                sSelf.eventId = id
                sSelf.tripDetails?.trip_id = selectedTrip.id
                sSelf.saveMovedTrip()
            }
            else {
                sSelf.delegate?.moveAndUpdateTripAPIFail()
            }
        }
    }
    
    private func saveMovedTrip() {
        
        var param: JSONDictionary = ["event_id": self.eventId]
        param["trip_id"] = tripDetails?.trip_id ?? ""
        param["booking_id"] = tripDetails?.booking_id ?? ""
        
        APICaller.shared.tripsUpdateBookingAPI(params: param) { [weak self](success, errors) in
            guard let sSelf = self else {return}
            if success {
                sSelf.tripDetails?.event_id = sSelf.eventId
                sSelf.delegate?.moveAndUpdateTripAPISuccess()
            }
            else {
                sSelf.delegate?.moveAndUpdateTripAPIFail()
            }
        }
    }
}
