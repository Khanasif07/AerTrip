
//
//  PassengerDetailsVM.swift
//  Aertrip
//
//  Created by Apple  on 07.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation

class PassengerDetailsVM {
    var passengerList = [Passenger]()
    var journeyType:JourneyType = .domestic
    var indexPath = IndexPath()
    var currentIndex = 0{
        didSet{
            self.indexPath = IndexPath(row: 0, section: currentIndex)
        }
    }
    
    
}
