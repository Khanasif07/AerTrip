//
//  FirebaseAnalyticsController.swift
//  AERTRIP
//
//  Created by Rishabh on 03/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class FirebaseAnalyticsController {
    
    static let shared = FirebaseAnalyticsController()
    
    func logEvent(name: String, params: JSONDictionary? = nil) {
        Analytics.logEvent(name, parameters: params)
    }
    
}
