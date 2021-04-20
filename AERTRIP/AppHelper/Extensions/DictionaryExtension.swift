//
//  DictionaryExtension.swift
//  AERTRIP
//
//  Created by apple on 02/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
  
}

public extension LazyMapCollection  {
    func toArray() -> [Element]{
        return Array(self)
    }
}


extension Dictionary where Key == String, Value:Any {

    func getString() -> String {
        
        var valueString = ""
        self.forEach { (key,value) in
            valueString.append("\(key) : \(value), ")
        }
        
        if valueString.hasSuffix(", "){
            valueString.removeLast()
            valueString.removeLast()
        }
                
        return valueString
    }

}
