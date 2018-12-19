//
//  GeneralPrefrenceModel.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 19/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

struct GeneralPrefrenceModel {
    
    var sortOrder    : String
    var displayOrder : String
    var categorizeByGroup: Bool
    var labels : [String]
    
    init() {
        
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        
        self.sortOrder     = json["sort_order"].stringValue
        self.displayOrder   = json["display_order"].stringValue
        self.categorizeByGroup = json["categorize_by_group"].boolValue
        self.labels      = AppGlobals.retunsStringArray(jsonArr: json["labels"].arrayValue)
    }
    
}
