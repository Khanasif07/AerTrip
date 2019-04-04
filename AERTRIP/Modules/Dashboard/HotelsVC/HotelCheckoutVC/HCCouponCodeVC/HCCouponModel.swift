//
//  HCCouponModel.swift
//  AERTRIP
//
//  Created by Admin on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//
//    product_type : "hotel"

import Foundation

struct HCCouponModel {
    
    var isCouponApplied: Bool = false
    var couponCode: String = ""
    var couponTitle: String = ""
    var description: String = ""
    var discountBreakUp: DiscountBreakUp?
    
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.is_applied.rawValue: self.isCouponApplied,
                APIKeys.coupon_code.rawValue: self.couponCode,
                APIKeys.coupon_title.rawValue: self.couponTitle,
                APIKeys.description.rawValue: self.description,
                APIKeys.discounts_breakup.rawValue: self.discountBreakUp ?? DiscountBreakUp()]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.is_applied.rawValue] as? Bool {
            self.isCouponApplied = obj
        }
        if let obj = json[APIKeys.coupon_code.rawValue] {
            self.couponCode = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.coupon_title.rawValue] {
            self.couponTitle = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.description.rawValue] {
            self.description = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.discounts_breakup.rawValue] as? JSONDictionary {
            self.discountBreakUp = DiscountBreakUp.getDiscountBreakUps(json: obj)
        }
    }
    
    static func getHCCouponData(jsonArr: [JSONDictionary]) -> [HCCouponModel] {
        var arr = [HCCouponModel]()
        for json in jsonArr {
            let obj = HCCouponModel(json: json)
            arr.append(obj)
        }
        return (arr)
    }
}

struct DiscountBreakUp {
    var CPD: Double = 0
    var CACB: Double = 0
    var CSPCFEE: Double = 0
    var totalCashBack: Double {
        return CPD + CACB
    }
    
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.CPD.rawValue: self.CPD,
                APIKeys.CACB.rawValue: self.CACB,
                APIKeys.CSPCFEE.rawValue: self.CSPCFEE]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.CPD.rawValue] as? Double {
            self.CPD = obj < 0 ? obj*(-1) : obj
        }
        if let obj = json[APIKeys.CACB.rawValue] as? Double {
            self.CACB = obj < 0 ? obj*(-1) : obj
        }
        if let obj = json[APIKeys.CSPCFEE.rawValue] as? Double {
            self.CSPCFEE = obj < 0 ? obj*(-1) : obj
        }
    }
    
    static func getDiscountBreakUps(json: JSONDictionary ) -> DiscountBreakUp {
        let obj = DiscountBreakUp(json: json)
        return obj
    }
}
