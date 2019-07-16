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

enum TripUsingFor {
    case bookingTripChange
    case hotel
    case bookingAddToTrip
}

class SelectTripVM {
    // MARK: - Properties
    
    // MARK: - Public
    
    var selectedIndexPath: IndexPath?
    var delegate: SelectTripVMDelegate?
    var tripDetails: TripDetails?
    // user for hotel Change
    var tripInfo: TripInfo?
    var usingFor: TripUsingFor = .hotel
    
    var allTrips: [TripModel] = []
    var eventId: String = ""
    var newTripId: String = ""
    
    // MARK: - Private
    
    // MARK: - Methods
    
    // MARK: - Private
    
    // MARK: - Public
    
    func fetchAllTrips() {
        delegate?.willFetchAllTrips()
        
        APICaller.shared.getAllTripsAPI { _, _, trips, _ in
            self.allTrips = trips
            self.delegate?.fetchAllTripsSuccess()
        }
    }
    
    func moveAndUpdateTripAPI(selectedTrip: TripModel) {
        var param: JSONDictionary = ["is_delete": 1]
        if let tripInfo = tripInfo, !tripInfo.bookingId.isEmpty {
            param["trip_id"] = tripInfo.tripId
            param["event_id[]"] = tripInfo.eventId
            param["move_id[]"] = selectedTrip.id
        } else {
            param["trip_id"] = tripDetails?.trip_id ?? ""
            param["event_id[]"] = tripDetails?.event_id ?? ""
            param["move_id[]"] = selectedTrip.id
        }
       
        
        delegate?.willMoveAndUpdateTripAPI()
        APICaller.shared.tripsEventMoveAPI(params: param) { [weak self] success, _, eventId,tripId in
            guard let sSelf = self else { return }
            if success, let id = eventId {
                sSelf.eventId = id
                sSelf.tripDetails?.trip_id = selectedTrip.id
                sSelf.newTripId = tripId ?? ""
                sSelf.saveMovedTrip()
            }
            else {
                sSelf.delegate?.moveAndUpdateTripAPIFail()
            }
        }
    }
    
    private func saveMovedTrip() {
        var param: JSONDictionary = ["event_id": self.eventId]
        if let tripInfo = tripInfo, !tripInfo.bookingId.isEmpty {
            param["trip_id"] = newTripId
            param["booking_id"] = tripInfo.bookingId
        } else {
            param["trip_id"] = tripDetails?.trip_id ?? ""
            param["booking_id"] = tripDetails?.booking_id ?? ""
        }
        
        APICaller.shared.tripsUpdateBookingAPI(params: param) { [weak self] success, _ in
            guard let sSelf = self else { return }
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
