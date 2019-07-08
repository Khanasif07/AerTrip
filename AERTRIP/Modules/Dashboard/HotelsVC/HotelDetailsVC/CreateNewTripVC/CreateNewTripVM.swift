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
    func add(trip: TripModel) {
        self.delegate?.willSaveTrip()
        
        APICaller.shared.addNewTripAPI(params: [APIKeys.name.rawValue: trip.name]) { [weak self](success, error, trip) in
            
            guard let sSelf = self else {return}
            if success, let trp = trip {
                sSelf.delegate?.saveTripSuccess(trip: trp)
            }
        }
    }
}
