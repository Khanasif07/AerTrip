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
    
    var aerlineCanCharges: Charges?
    var aertripCanCharges: Charges?
    
    var aerlineResCharges: Charges?
    var aertripResCharges: Charges?
    
    init(json: JSONDictionary) {

        if let can = json["cancellation_charges"] as? JSONDictionary {
            if let obj = can["SPCFEE"] as? JSONDictionary {
                self.aerlineCanCharges = Charges(json: obj)
            }
            if let obj = can["SUCFEE"] as? JSONDictionary {
                self.aertripCanCharges = Charges(json: obj)
            }
        }
        
        if let res = json["rescheduling_charges"] as? JSONDictionary {
            if let obj = res["SPRFEE"] as? JSONDictionary {
                self.aerlineResCharges = Charges(json: obj)
            }
            if let obj = res["SURFEE"] as? JSONDictionary {
                self.aertripResCharges = Charges(json: obj)
            }
        }
    }
}
