
//
//  PassengerDetailsVM.swift
//  Aertrip
//
//  Created by Apple  on 07.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation

class PassengerDetailsVM {
    var passengerList:[ATContact]{
        GuestDetailsVM.shared.guests.first ?? []
    }
    var journeyType:JourneyType = .domestic
    var indexPath = IndexPath()
    var editinIndexPath:IndexPath?
    var searchText = ""
    var keyboardHeight: CGFloat = 0.0
    var currentIndex = 0{
        didSet{
            self.indexPath = IndexPath(row: 0, section: currentIndex)
        }
    }
    
    
}
