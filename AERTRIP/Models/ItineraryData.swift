//
//  ItineraryData.swift
//  AERTRIP
//
//  Created by Admin on 14/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

struct ItineraryData {
    
//    details
    var payment_amount: Int = 0
    var pg_id: Int = 0
    var payment_method_id: Int = 0
    var payment_method_sub_type_id: Int = 0
    var display_currency: String = ""
    var gateway_currency: String = ""
    var booking_currency: String = ""
    var display_currency_conversion = ""
    var gateway_currency_conversion: Int = 0
    var booking_currency_conversion: Int = 0
    var booking_name: String = ""
    var booking_description: String = ""
    var user_billing_address: String = ""
    var total_fare: Double = 0
    var convenience_fees: String = ""
    var use_wallet: String = ""
    var use_points: String = ""
    var session_id: String = ""
    var sid: String = ""
    var product_type_id: Int = 0
    var product_type: String = ""
    var product_category: String = ""
    var user_id: Int = 0
    var user_type: String = ""
    var coupon_code: String = ""
    var coupon_id: Int = 0
    var added_date: String = ""
    var status: Int = 0
    var is_combo: Int = 0
    var vcode: String = ""
    var it_id: String = ""
    
    var traveller_master: [TravellerModel] = []
    var special_requests: [SpecialRequest] = []
    var hotelDetails: HotelDetails?

    //Variables Used In HCCouponAppliedData
    var id: String = ""
    var part_payment: PartialPayment?
    var travellers: [Travellers] = []
    var payment_billing_info: PaymentBillingInfo?
    var mobile_isd: String = ""
    var mobile: String = ""
    var special: String = ""
    var other: String = ""
    var coupons: [HCCouponModel] = []
    var appliedCouponDetails: AppliedCouponDetails?
    //    var details = {  }
    //    var user_details = {  }

    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {

        payment_amount = json[APIKeys.payment_amount.rawValue].intValue
        pg_id = json[APIKeys.pg_id.rawValue].intValue
        payment_method_id = json[APIKeys.payment_method_id.rawValue].intValue
        payment_method_sub_type_id = json[APIKeys.payment_method_sub_type_id.rawValue].intValue
        display_currency = json[APIKeys.display_currency.rawValue].stringValue.removeNull
        gateway_currency = json[APIKeys.gateway_currency.rawValue].stringValue.removeNull
        booking_currency = json[APIKeys.booking_currency.rawValue].stringValue.removeNull
        display_currency_conversion = json[APIKeys.display_currency_conversion.rawValue].stringValue.removeNull
        gateway_currency_conversion = json[APIKeys.gateway_currency_conversion.rawValue].intValue
        booking_currency_conversion = json[APIKeys.booking_currency_conversion.rawValue].intValue
        booking_name = json[APIKeys.booking_name.rawValue].stringValue.removeNull
        booking_description = json[APIKeys.booking_description.rawValue].stringValue.removeNull
        user_billing_address = json[APIKeys.user_billing_address.rawValue].stringValue.removeNull
        total_fare = json[APIKeys.total_fare.rawValue].doubleValue
        convenience_fees = json[APIKeys.convenience_fees.rawValue].stringValue.removeNull
        use_wallet = json[APIKeys.use_wallet.rawValue].stringValue.removeNull
        use_points = json[APIKeys.use_points.rawValue].stringValue.removeNull
        session_id = json[APIKeys.session_id.rawValue].stringValue.removeNull
        sid = json[APIKeys.sid.rawValue].stringValue.removeNull
        product_type_id = json[APIKeys.product_type_id.rawValue].intValue
        product_type = json[APIKeys.product_type.rawValue].stringValue.removeNull
        product_category = json[APIKeys.product_category.rawValue].stringValue.removeNull
        user_id = json[APIKeys.user_id.rawValue].intValue
        user_type = json[APIKeys.user_type.rawValue].stringValue.removeNull
        coupon_code = json[APIKeys.coupon_code.rawValue].stringValue.removeNull
        coupon_id = json[APIKeys.coupon_id.rawValue].intValue
        added_date = json[APIKeys.added_date.rawValue].stringValue.removeNull
        status = json[APIKeys.status.rawValue].intValue
        is_combo = json[APIKeys.is_combo.rawValue].intValue
        vcode = json[APIKeys.vcode.rawValue].stringValue.removeNull
        it_id = json[APIKeys.it_id.rawValue].stringValue.removeNull
        traveller_master = TravellerModel.models(jsonArr: json[APIKeys.traveller_master.rawValue]["aertrip"].arrayValue)
        special_requests = SpecialRequest.models(jsonArr: json[APIKeys.special_requests.rawValue].arrayValue)
        hotelDetails = HotelDetails(json: json["details"]["processed_data"].dictionaryObject ?? [:])
        
        // Used In HCCouponAppliedDat
        id = json[APIKeys.id.rawValue]["$oid"].stringValue.removeNull
        part_payment = PartialPayment.getPartialPaymentData(json: json[APIKeys.part_payment.rawValue])
        travellers = Travellers.getTravellersData(jsonArr: json[APIKeys.travellers.rawValue].arrayValue)
        payment_billing_info = PaymentBillingInfo.getPaymentBillingInfo(json: json[APIKeys.payment_billing_info.rawValue])
        mobile_isd = json[APIKeys.mobile_isd.rawValue].stringValue.removeNull
        mobile = json[APIKeys.mobile.rawValue].stringValue.removeNull
        special = json[APIKeys.special.rawValue].stringValue.removeNull
        other = json[APIKeys.other.rawValue].stringValue.removeNull
        if let couponsData = json[APIKeys.coupons.rawValue].arrayObject as? JSONDictionaryArray {
            coupons = HCCouponModel.getHCCouponData(jsonArr: couponsData)
        }
        appliedCouponDetails = AppliedCouponDetails.getAppliedCouponDetails(json: json[APIKeys.applied_coupon_details.rawValue])
    }
}


struct SpecialRequest {
    var id: Int = 0
    var name: String = ""
    var is_checked: Int = 0
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue.removeNull
        self.is_checked = json["is_checked"].intValue
    }
    
    static func models(jsonArr: [JSON]) -> [SpecialRequest] {
        var all = [SpecialRequest]()
        for element in jsonArr {
            all.append(SpecialRequest(json: element))
        }
        return all
    }
}


struct  ItenaryModel {
    var id : String
    var currencyPref: String
    var grossAmount : String
    var netAmount : String
    var priceChange : String
    
    init() {
        let json = JSON()
        self.init(json:json)
    }
    
    init(json: JSON) {
        self.id = json[APIKeys.id.rawValue].stringValue
        self.currencyPref = json[APIKeys.currencyPref.rawValue].stringValue
        self.grossAmount = json[APIKeys.grossAmout.rawValue].stringValue
        self.netAmount = json[APIKeys.netAmount.rawValue].stringValue
        self.priceChange = json[APIKeys.priceChange.rawValue].stringValue
    }
}


struct PartialPayment {
    var amount: Int = 0
    var user_amount: Int = 0
    var date: String = ""
    var processing_fee: Int = 0
    
    init(json: JSON) {
        self.amount = json[APIKeys.amount.rawValue].intValue
        self.user_amount = json[APIKeys.user_amount.rawValue].intValue
        self.date = json[APIKeys.date.rawValue].stringValue.removeNull
        self.processing_fee = json[APIKeys.processing_fee.rawValue].intValue
    }
    
    static func getPartialPaymentData(json: JSON) -> PartialPayment {
        let partialPayment = PartialPayment(json: json)
            return partialPayment
    }
}

struct Travellers { //travellers
    var travellersData: [TravellersData] = []
    var rId: String = ""
    var qId: String = ""
    
    init(json: JSON) {
        self.travellersData = TravellersData.getTravellersData(jsonArr: json[APIKeys._t.rawValue].arrayValue)
        self.rId = json[APIKeys.rid.rawValue].stringValue.removeNull
        self.qId = json[APIKeys.qid.rawValue].stringValue.removeNull
    }
    
    static func getTravellersData(jsonArr: [JSON]) -> [Travellers] {
        var travellersData = [Travellers]()
        for element in jsonArr {
            travellersData.append(Travellers(json: element))
        }
        return travellersData
    }
    
    struct TravellersData {
        var fname: String = ""
        var lname: String = ""
        var sal: String = ""
        var ptype: String = ""
        var id: String = ""

        init(json: JSON) {
            self.fname = json[APIKeys.fname.rawValue].stringValue.removeNull
            self.lname = json[APIKeys.lname.rawValue].stringValue.removeNull
            self.sal = json[APIKeys.sal.rawValue].stringValue.removeNull
            self.ptype = json[APIKeys.ptype.rawValue].stringValue.removeNull
            self.id = json[APIKeys.id.rawValue].stringValue.removeNull
        }
        
        static func getTravellersData(jsonArr: [JSON]) -> [TravellersData] {
            var travellersData = [TravellersData]()
            for element in jsonArr {
                travellersData.append(TravellersData(json: element))
            }
            return travellersData
        }
    }
}

struct PaymentBillingInfo {
    var name: String = ""
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var zip: String = ""
    var country: String = ""
    var tel: String = ""
    var email: String = ""
    
    init(json: JSON) {
        self.name = json[APIKeys.name.rawValue].stringValue.removeNull
        self.address = json[APIKeys.address.rawValue].stringValue.removeNull
        self.city = json[APIKeys.city.rawValue].stringValue.removeNull
        self.zip = json[APIKeys.zip.rawValue].stringValue.removeNull
        self.country = json[APIKeys.country.rawValue].stringValue.removeNull
        self.tel = json[APIKeys.telephone.rawValue].stringValue.removeNull
        self.email = json[APIKeys.email.rawValue].stringValue.removeNull
    }
    
    static func getPaymentBillingInfo(json: JSON) -> PaymentBillingInfo {
        let paymentBillingInfo = PaymentBillingInfo(json: json)
        return paymentBillingInfo
    }
}

struct AppliedCouponDetails { //applied_coupon_details
    
    var coupon_id: String = ""
    var coupon_code: String = ""
    var total_usage_limit: String = ""
    var per_user_usage_limit: String = ""
    var is_payment_method_mapped: String = ""
    var is_points_usage_allowed: String = ""
    var is_partial_payment_allowed: String = ""
    var payment_method_mapping: [String : Any] = [:]
    
    init(json: JSON) {
        self.coupon_id = json[APIKeys.coupon_id.rawValue].stringValue.removeNull
        self.coupon_code = json[APIKeys.coupon_code.rawValue].stringValue.removeNull
        self.total_usage_limit = json[APIKeys.total_usage_limit.rawValue].stringValue.removeNull
        self.per_user_usage_limit = json[APIKeys.per_user_usage_limit.rawValue].stringValue.removeNull
        self.is_payment_method_mapped = json[APIKeys.is_payment_method_mapped.rawValue].stringValue.removeNull
        self.is_points_usage_allowed = json[APIKeys.is_points_usage_allowed.rawValue].stringValue.removeNull
        self.is_partial_payment_allowed = json[APIKeys.is_partial_payment_allowed.rawValue].stringValue.removeNull
        self.payment_method_mapping = json[APIKeys.payment_method_mapping.rawValue].dictionaryObject ?? [:]
    }
    
    static func getAppliedCouponDetails(json: JSON) -> AppliedCouponDetails {
        let appliedCouponDetails = AppliedCouponDetails(json: json)
        return appliedCouponDetails
    }

}
