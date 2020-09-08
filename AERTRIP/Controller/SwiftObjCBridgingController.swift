//
//  SwiftObjCBridgingController.swift
//  AERTRIP
//
//  Created by Rishabh on 21/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class SwiftObjCBridgingController: NSObject {
    
    @objc static let shared = SwiftObjCBridgingController()
        
    @objc var onFetchingFlightFormData: ((NSMutableDictionary) -> ())?
    @objc var onFetchingFlightFormDataForSharedUrl: ((NSMutableDictionary) -> ())?

    
    func sendFlightFormData(_ jsonDict: JSONDictionary) {
        
        let newDict = NSMutableDictionary()
        jsonDict.forEach { (key, val) in
            newDict[key] = val
        }
        
        onFetchingFlightFormData?(newDict)
    }
    
    func sendFlightFormDataForSharedUrl(_ jsonDict: NSDictionary) {
        
        let newDict = NSMutableDictionary()
        jsonDict.forEach { (key, val) in
            newDict[key] = val
        }
        
        onFetchingFlightFormDataForSharedUrl?(newDict)
    }
}

