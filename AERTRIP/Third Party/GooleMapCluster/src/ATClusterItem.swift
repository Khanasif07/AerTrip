//
//  POIItem.swift
//  ClusteringDemo
//
//  Created by Appinventiv on 03/11/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import Foundation

/// Point of Interest Item which implements the GMUClusterItem protocol.
class ATClusterItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var hotelDetails: HotelSearched?
    
    init(position: CLLocationCoordinate2D, hotel: HotelSearched) {
        self.position = position
        self.hotelDetails = hotel
    }
}
