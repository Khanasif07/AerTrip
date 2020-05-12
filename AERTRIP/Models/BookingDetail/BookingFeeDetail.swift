//
//  BookingFeeDetail.swift
//  AERTRIP
//
//  Created by Admin on 13/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct BookingFeeDetail {
    
    struct Charges {
        var adult: Int?
        var child: Int?
        var infant: Int?
        
        init(json: JSONDictionary) {
            if let obj = json["ADT"] {
                self.adult = "\(obj)".toInt
            }
            
            if let obj = json["CHD"] {
                self.child = "\(obj)".toInt
            }
            
            if let obj = json["INF"] {
                self.infant = "\(obj)".toInt
            }
        }
    }
    
    
    
    
    var aerlineCanCharges: AerlineCharge?
    var aertripCanCharges: Charges?
    
    var aerlineResCharges: AerlineCharge?
    var aertripResCharges: Charges?
    var legId: [String] = []
    var rfd:Bool = false
    var rsc:Bool = false
    
    
    init(json: JSONDictionary) {

        if let can = json["cp"] as? JSONDictionary {
            if let obj = can["SPCFEE"] as? JSONDictionary {
                self.aerlineCanCharges = AerlineCharge(json: obj)
            }
            if let obj = can["SUCFEE"] as? JSONDictionary {
                self.aertripCanCharges = Charges(json: obj)
            }
        }
        
        if let res = json["rscp"] as? JSONDictionary {
            if let obj = res["SPRFEE"] as? JSONDictionary {
                self.aerlineResCharges = AerlineCharge(json: obj)
            }
            if let obj = res["SURFEE"] as? JSONDictionary {
                self.aertripResCharges = Charges(json: obj)
            }
        }
        
        if let legId = json["leg_id"] as? [String] {
            self.legId = legId
        }
        
        if let obj = json["rfd"] as? Bool{
            self.rfd = obj
        }
        
        if let obj = json["rsc"] as? Bool{
            self.rsc = obj
        }
    }
}

struct AerlineCharge {
    var adult: [FEE]?
    var child: [FEE]?
    var infant: [FEE]?
    
    init(json: JSONDictionary) {
        if let obj = json["ADT"] as? [JSONDictionary] {
            self.adult = FEE.getModels(json: obj)
        }
        
        if let obj = json["CHD"] as? [JSONDictionary] {
            self.child = FEE.getModels(json: obj)
        }
        
        if let obj = json["INF"] as? [JSONDictionary] {
            self.infant = FEE.getModels(json: obj)
        }
    }
}

struct FEE {
    var from: Date?
    var to: Date?
    var value: Int?
    
    init(json: JSONDictionary) {
        if let obj = json["from"] {
            self.from = "\(obj)".toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        if let obj = json["to"] {
            self.to = "\(obj)".toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        if let obj = json["value"] {
            self.value = "\(obj)".toInt
        }
    }
    
    static func getModels(json: [JSONDictionary]) -> [FEE] {
        return json.map { FEE(json: $0) }
    }
}
