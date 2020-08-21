//
//  SwiftObjCBridgingController.swift
//  AERTRIP
//
//  Created by Rishabh on 21/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol SwiftObjCBridgingControllerDelegate: NSObject {
    func onFetchingFlightFormData()
}

class SwiftObjCBridgingController: NSObject {
    
    @objc static let shared = SwiftObjCBridgingController()
        
    @objc var onFetchingFlightFormData: (() -> ())?
    
    func sendFlightFormData(_ jsonDict: JSONDictionary) {
        onFetchingFlightFormData?()
    }
}

