//
//  BookingDetailModel.swift
//  AERTRIP
//
//  Created by apple on 06/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct BookingDetailModel {
    var id: String = ""
    var bookingNumber: String = ""
    var bookingDate: String = ""
    var communicationNumber: String = ""
    var depart: String = ""
    var billingInfo: BillingDetail?
    var product: String = ""
    var category: String = ""
    var tripType: String = ""
    var specialFare: String = ""
    var bookingDetail: BookingDetail?
    var itineraryId: String = ""
    var cases: [CaseStatus] = []
    var receipt: Receipt?
    
    var totalAmountPaid: String = ""
    var vCode: String = ""
    var bookingStatus: String = ""
    var addOnRequestAllowed: Bool = false
    var cancellationRequestAllowed: Bool = false
    var rescheduleRequestAllowed: Bool = false
    var specialRequestAllowed: Bool = false
    var user: UserInfo?
    
    var jsonDict: JSONDictionary {
        return [:]
    }
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.id = "\(obj)"
        }
        if let obj = json["booking_number"] {
            self.bookingNumber = "\(obj)"
        }
        if let obj = json["booking_date"] {
            self.bookingDate = "\(obj)"
        }
        
        if let obj = json["communication_number"] {
            self.communicationNumber = "\(obj)"
        }
        
        if let obj = json["depart"] {
            self.depart = "\(obj)"
        }
        
        if let obj = json["billing_info"] as? JSONDictionary {
            self.billingInfo = BillingDetail(json: obj)
        }
        
        if let obj = json["product"] {
            self.product = "\(obj)"
        }
        
        if let obj = json["category"] {
            self.category = "\(obj)"
        }
        
        if let obj = json["trip_type"] {
            self.tripType = "\(obj)"
        }
        
        if let obj = json["special_fares"] {
            self.specialFare = "\(obj)"
        }
        
        if let obj = json["user"] as? UserInfo {
            self.user = obj
        }
    }
}

struct BookingDetail {
    var tripCities: [String] = []
    var travelledCities: String = ""
    var disconnected: Bool = false
    var routes: [[String]] = [[]]
    var leg: [Leg] = []
    var journeyCompleted: Int16 = 0
    var pax: [String] = []
    var note: String = ""
    var eventStartDate: String = ""
    var eventEndDate: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["tripCities"] as? [String] {
            self.tripCities = obj
        }
        
        if let obj = json["travelledCities"] {
            self.travelledCities = "\(obj)"
        }
        
        if let obj = json["disconnected"] as? Bool {
            self.disconnected = obj
        }
        
        if let obj = json["routes"] as? [[String]] {
            self.routes = obj
        }
    }
}

struct Leg {
    var legId: String = ""
    var origin: String = ""
    var destination: String = ""
    var title: String = ""
    var stops: String = ""
    var refundable: String = ""
    var reschedulable: String = ""
    var fareName: String = ""
    var flight: [FlightDetail] = []
    var halts: String = ""

    init() {}
    
    init(json: JSONDictionary) {
        if let obj = json["leg_id"] {
            self.legId = "\(obj)"
        }
        
        if let obj = json["origin"] {
            self.origin = "\(obj)"
        }
        if let obj = json["destination"] {
            self.destination = "\(obj)"
        }
        if let obj = json["ttl"] {
            self.title = "\(obj)"
        }
        if let obj = json["stops"] {
            self.stops = "\(obj)"
        }
        if let obj = json["refundable"] {
            self.refundable = "\(obj)"
        }
        if let obj = json["reschedulable"] {
            self.reschedulable = "\(obj)"
        }
        if let obj = json["fare_name"] {
            self.fareName = "\(obj)"
        }
    }
}

struct FlightDetail {
    var flightId: String = ""
    var departure: String = ""
    var departureAirport: String = ""
    var departureTerminal: String = ""
    var departureCountry: String = ""
    var departureCountryCode: String = ""
    var departCity: String = ""
    
    var departDate: String = ""
    var departureTime: String = ""
    var arrival: String = ""
    var arrivalAirport: String = ""
    var arrivalTerminal: String = ""
    var arrivalCountry: String = ""
    var arrivalCity: String = ""
    var arrivalCountryCode: String = ""
    var arrivalDate: String = ""
    var arrivalTime: String = ""
    var flightTime: String = ""
    var carrier: String = ""
    var carrierCode: String = ""
    var flightNumber: String = ""
    var equipment: String = ""
    var quality: String = ""
    var cabinClass: String = ""
    var operatedBy: String = ""
    var baggage: Baggage?
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["flight_id"] {
            self.flightId = "\(obj)"
        }
        
        if let obj = json["departure"] {
            self.departure = "\(obj)"
        }
        
        if let obj = json["departure_airport"] {
            self.departureAirport = "\(obj)"
        }
        
        if let obj = json["departure_terminal"] {
            self.departureTerminal = "\(obj)"
        }
        
        if let obj = json["departure_country"] {
            self.departureCountry = "\(obj)"
        }
        
        if let obj = json["departure_country_code"] {
            self.departureCountryCode = "\(obj)"
        }
        
        if let obj = json["depart_city"] {
            self.departCity = "\(obj)"
        }
        
        if let obj = json["depart_date"] {
            self.departDate = "\(obj)"
        }
        
        if let obj = json["departure_time"] {
            self.departureTime = "\(obj)"
        }
        
        if let obj = json["arrival"] {
            self.arrival = "\(obj)"
        }
        
        if let obj = json["arrival_airport"] {
            self.arrivalAirport = "\(obj)"
        }
        
        if let obj = json["arrival_terminal"] {
            self.arrivalTerminal = "\(obj)"
        }
        
        if let obj = json["arrival_country"] {
            self.arrivalCountry = "\(obj)"
        }
        
        if let obj = json["arrival_city"] {
            self.arrivalCity = "\(obj)"
        }
        
        if let obj = json["arrival_country_code"] {
            self.arrivalCountryCode = "\(obj)"
        }
        
        if let obj = json["arrival_date"] {
            self.arrivalDate = "\(obj)"
        }
        if let obj = json["arrival_time"] {
            self.arrivalTime = "\(obj)"
        }
        if let obj = json["flight_time"] {
            self.flightTime = "\(obj)"
        }
        if let obj = json["carrier"] {
            self.carrier = "\(obj)"
        }
        if let obj = json["carrier_code"] {
            self.carrierCode = "\(obj)"
        }
        if let obj = json["flight_number"] {
            self.flightNumber = "\(obj)"
        }
        if let obj = json["equipment"] {
            self.equipment = "\(obj)"
        }
        if let obj = json["qualiy"] {
            self.quality = "\(obj)"
        }
        if let obj = json["cabin_class"] {
            self.cabinClass = "\(obj)"
        }
        if let obj = json["operated_by"] {
            self.operatedBy = "\(obj)"
        }
    }
}


struct Baggage {
//    var bg: Bg?
//    var cbg: Cbg?
    var icc: Int16
    
}

struct BillingDetail {
    var email: String = ""
    var communicationNumber: String = ""
    var billingName: String = ""
    var gst: String = ""
    var address: BillingAddress?
    
    var jsonDict: JSONDictionary {
        return [:]
    }
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["email"] {
            self.email = "\(obj)"
        }
        if let obj = json["communication_number"] {
            self.communicationNumber = "\(obj)"
        }
        if let obj = json["billing_name"] {
            self.billingName = "\(obj)"
        }
        
        if let obj = json["gst"] {
            self.gst = "\(obj)"
        }
        
        if let obj = json["address"] as? JSONDictionary {
            self.address = BillingAddress(json: obj)
        }
    }
}

struct BillingAddress {
    var addressLine1: String = ""
    var addressLine2: String = ""
    var city: String = ""
    var state: String = ""
    var postalCode: String = ""
    var country: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["address_line1"] {
            self.addressLine1 = "\(obj)"
        }
        
        if let obj = json["address_line2"] {
            self.addressLine2 = "\(obj)"
        }
        
        if let obj = json["city"] {
            self.city = "\(obj)"
        }
        
        if let obj = json["state"] {
            self.state = "\(obj)"
        }
        
        if let obj = json["postal_code"] {
            self.postalCode = "\(obj)"
        }
        
        if let obj = json["country"] {
            self.country = "\(obj)"
        }
    }
}

// Struct Case

struct Case {
    var id: String = ""
    var casedId: String = ""
    var caseType: String = ""
    var typeSlug: String = ""
    var caseName: String = ""
    var caseStatus: String = ""
    var resolutionStatusId: String = ""
    var resolutionStatus: String = ""
    var requestDate: String = ""
    var csrName: String = ""
    var resolutionDate: String = ""
    var closedDate: String = ""
    var flag: String = ""
    var note: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.id = "\(obj)"
        }
        
        if let obj = json["case_id"] {
            self.casedId = "\(obj)"
        }
        
        if let obj = json["case_type"] {
            self.caseType = "\(obj)"
        }
        
        if let obj = json["type_slug"] {
            self.typeSlug = "\(obj)"
        }
        
        if let obj = json["case_status"] {
            self.caseName = "\(obj)"
        }
        
        if let obj = json["resolution_status_id"] {
            self.resolutionStatusId = "\(obj)"
        }
        
        if let obj = json["resolution_status"] {
            self.resolutionStatus = "\(obj)"
        }
        if let obj = json["request_date"] {
            self.requestDate = "\(obj)"
        }
        
        if let obj = json["csr_name"] {
            self.csrName = "\(obj)"
        }
        if let obj = json["resolution_date"] {
            self.resolutionDate = "\(obj)"
        }
        
        if let obj = json["closed_date"] {
            self.closedDate = "\(obj)"
        }
        
        if let obj = json["flag"] {
            self.flag = "\(obj)"
        }
        if let obj = json["note"] {
            self.note = "\(obj)"
        }
    }
}

struct Receipt {
    var voucher: [Voucher] = []
    var totalAmountDue: String = ""
    var totalAmountPaid: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["total_amount_due"] {
            self.totalAmountDue = "\(obj)"
        }
        
        if let obj = json["total_amount_paid"] {
            self.totalAmountPaid = "\(obj)"
        }
    }
}

struct Voucher {
    var basic: Basic?
    var transaction: Transactions?
    var paymentInfo: BookingPaymentInfo?
}

struct Basic {
    var id: String = ""
    var voucherType: String = ""
    var name: String = ""
    var event: String = ""
    var type: String = ""
    var typeSlug: String = ""
    var pattern: String = ""
    var lastNumber: String = ""
    var isActive: String = ""
    var voucherNo: String = ""
    var transactionDateTime: String = ""
    var transactionId: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.id = "\(obj)"
        }
        if let obj = json["voucher_type"] {
            self.voucherType = "\(obj)"
        }
        if let obj = json["name"] {
            self.name = "\(obj)"
        }
        if let obj = json["event"] {
            self.event = "\(obj)"
        }
        if let obj = json["type"] {
            self.type = "\(obj)"
        }
        if let obj = json["type_slug"] {
            self.typeSlug = "\(obj)"
        }
        if let obj = json["pattern"] {
            self.pattern = "\(obj)"
        }
        if let obj = json["last_number"] {
            self.lastNumber = "\(obj)"
        }
        if let obj = json["is_active"] {
            self.isActive = "\(obj)"
        }
        if let obj = json["voucher_no"] {
            self.voucherNo = "\(obj)"
        }
        if let obj = json["transaction_datetime"] {
            self.voucherType = "\(obj)"
        }
        if let obj = json["transaction_id"] {
            self.transactionId = "\(obj)"
        }
    }
}

struct Transactions {
    var taxesAndFees: TaxesAndFees
    var baseFare: Amount?
    var grandTotal: Amount?
    var totalPayableNow: Amount?
    var total: Amount?
    var grossFare: Amount?
    
    // TODO: need to Add after discussion with Nitesh
//    [
//    {
//    "amount": "-364238.00",
//    "ledger_name": "RazorPay"
//    }
//    ]
}

struct BookingPaymentInfo {
    var orderId: String = ""
    var pgFee: String = ""
    var pgTax: String = ""
    var transDate: String = ""
    var paymentId: String = ""
    var method: String = ""
    var bankName: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["order_id"] {
            self.orderId = "\(obj)"
        }
        
        if let obj = json["pg_fee"] {
            self.pgFee = "\(obj)"
        }
        
        if let obj = json["pg_tax"] {
            self.pgTax = "\(obj)"
        }
        
        if let obj = json["trans_date"] {
            self.transDate = "\(obj)"
        }
        if let obj = json["payment_id"] {
            self.paymentId = "\(obj)"
        }
        if let obj = json["method"] {
            self.method = "\(obj)"
        }
        if let obj = json["bank_name"] {
            self.bankName = "\(obj)"
        }
    }
}

struct TaxesAndFees {
    var codes: [Codes] = []
    var total: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["codes"] as? [String: Any] {
            self.codes = Codes.models(json: obj)
        }
        if let obj = json[total] {
            self.total = "\(obj)"
        }
    }
}

struct Amount {
    var amount: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["amount"] {
            self.amount = "\(obj)"
        }
    }
}

struct Codes {
    var code: String = ""
    var ledgerName: String = ""
    var amount: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.code = "\(obj)"
        }
        
        if let obj = json["ledger_name"] {
            self.ledgerName = "\(obj)"
        }
        
        if let obj = json["amount"] {
            self.amount = "\(obj)"
        }
    }
    
    static func models(json: JSONDictionary) -> [Codes] {
        var codes = [Codes]()
        
        let keyArr: [String] = Array(json.keys)
        for key in keyArr {
            if var temp = json[key] as? [String: Any] {
                temp["id"] = key
                codes.append(Codes(json: temp))
            }
        }
        return codes
    }
}
