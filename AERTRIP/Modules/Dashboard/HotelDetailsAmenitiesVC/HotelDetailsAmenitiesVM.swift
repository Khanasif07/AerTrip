//
//  HotelDetailsAmenitiesVM.swift
//  AERTRIP
//
//  Created by Admin on 19/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation


class HotelDetailsAmenitiesVM: NSObject {
    
    internal var hotelDetails: HotelDetails?
    var sections: [String] = []
//    var rowData: [Any] = []
    var rowsData = [[String]]()
    
    internal func getAmenitiesSections() {
        if let amenitiesGroupDetails = self.hotelDetails?.amenitiesGroups {
            for amenities in amenitiesGroupDetails{
                self.sections.append(amenities.key)
                if let value = amenities.value as? [String] {
                    self.rowsData.append(value)
                }
//                self.rowData.append(amenities.value)
            }
        }
    }
}
