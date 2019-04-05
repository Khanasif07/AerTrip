//
//  HotelDetailsAmenitiesVM.swift
//  AERTRIP
//
//  Created by Admin on 19/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
//About the Property ,  Internet and Business Services , Food and drinks , Things to Do , Services

enum AmenitiesPriorities: Int{
    case AboutTheProperty = 0 , InternetAndBusinessServices , FoodAndDrinks , ThingsToDo , Services
}

class HotelDetailsAmenitiesVM: NSObject {
    
    internal var hotelDetails: HotelDetails?
    var sections: [String] = []
    var rowsData = [[String]]()
    
    internal func getAmenitiesSections() {
        if let amenitiesGroupDetails = self.hotelDetails?.amenitiesGroups {
            for amenities in amenitiesGroupDetails{
                self.sections.append(amenities.key)
                if let value = amenities.value as? [String] {
                    self.rowsData.append(value)
                }
            }
        }
    }
    
}
