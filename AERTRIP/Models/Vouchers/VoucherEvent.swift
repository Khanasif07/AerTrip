//
//  VoucherEvent.swift
//  AERTRIP
//
//  Created by apple on 17/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct VoucherEvent {
    
    var id: String = ""
    var title: String = ""
    var date: String = ""
    var price: String = ""
    var type: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    
    var jsonDict: JSONDictionary {
        return [APIKeys.id.rawValue: self.id,
                APIKeys.title.rawValue: self.title,
                APIKeys.date.rawValue: self.date,
                APIKeys.price.rawValue: self.price,
                APIKeys.type.rawValue: self.type
        ]
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json[APIKeys.id.rawValue] {
            self.id = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.title.rawValue] {
            self.title = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.date.rawValue] {
            self.date = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.price.rawValue]  {
            self.price = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.type.rawValue] {
            self.type = "\(obj)".removeNull
        }
    }
        
        
       static  func getVoucherData(jsonDictArray: [JSONDictionary]) -> [VoucherEvent] {
            var allEventData: [VoucherEvent] = []
            for jsonDict in jsonDictArray {
                allEventData.append(VoucherEvent(json: jsonDict))
            }
            return allEventData
        }
        
    }

