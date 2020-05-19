//
//  Amenties.swift
//  Aertrip
//
//  Created by  hrishikesh on 07/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import Foundation


struct Amenity {
    var name : String
    var image : String
    var isSelected : Bool = false
}

struct AmenityCollection {
    var name: String
    var items: [Amenity]
    var collapsed: Bool
    var isSelected : Bool
    
    init(name: String, items: [Amenity], collapsed: Bool = true , selected : Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
        self.isSelected = selected
    }
}



