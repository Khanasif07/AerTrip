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
}

class SelectTripVM {
    
    //MARK:- Properties
    //MARK:- Public
    var selectedIndexPath: IndexPath?
    var delegate: SelectTripVMDelegate?
    
    var allTrips: [TripModel] = []
    
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
}
