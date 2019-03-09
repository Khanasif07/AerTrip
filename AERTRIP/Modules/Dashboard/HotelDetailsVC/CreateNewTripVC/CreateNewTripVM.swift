//
//  CreateNewTripVM.swift
//  AERTRIP
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol CreateNewTripVMDelegate: class {
    func willSaveTrip()
    func saveTripSuccess(trip: TripModel)
    func saveTripFail()
}

class CreateNewTripVM {
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: CreateNewTripVMDelegate?
    
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Private
    
    
    //MARK:- Public
    func save(trip: TripModel) {
        self.delegate?.willSaveTrip()
        
        self.delegate?.saveTripSuccess(trip: trip)
    }
}
