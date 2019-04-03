//
//  HCCouponAppliedModel.swift
//  AERTRIP
//
//  Created by Admin on 01/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct HCCouponAppliedModel {
    
    var isCouponApplied: Bool = false // is_coupon_applied
    var couponCode: String = ""       // coupon_code
    var discountsBreakup: DiscountBreakUp?   //discounts_breakup
    var itinerary: ItineraryData?        ///itinerary
    var vCode: String = ""
    
    //vcode
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSON) {
        self.isCouponApplied = json[APIKeys.is_coupon_applied.rawValue].boolValue
        self.couponCode = json[APIKeys.coupon_code.rawValue].stringValue.removeNull
        if let discountBreakUp = json[APIKeys.discounts_breakup.rawValue].dictionaryObject {
            self.discountsBreakup = DiscountBreakUp.getDiscountBreakUps(json: discountBreakUp)
        }
//        self.discountsBreakup = DiscountBreakUp.getDiscountBreakUps(json: json[APIKeys.discounts_breakup.rawValue].dictionaryObject ?? DiscountBreakUp())
        self.itinerary = ItineraryData.init(json: json[APIKeys.itinerary.rawValue])
        self.vCode = json[APIKeys.vcode.rawValue].stringValue.removeNull
    }
    
    static func getHCCouponAppliedModel(json: JSON) -> HCCouponAppliedModel {
        let hcCouponAppliedModel = HCCouponAppliedModel(json: json)
        return hcCouponAppliedModel
    }
}
