//
//  TripModel.swift
//  AERTRIP
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

struct TripModel {
    var id: String = ""
    var title: String = ""
    var imagePath: String = ""
    var image: UIImage?
    
    init() {
        let json = JSON()
        self.init(json:json)
    }
    
    init(json:JSON) {
        self.id = json[APIKeys.id.rawValue].stringValue
    }
}
