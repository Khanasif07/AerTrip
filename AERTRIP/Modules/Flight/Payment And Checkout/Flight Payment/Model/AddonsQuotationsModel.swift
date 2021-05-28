//
//  AddonsQuatationsModel.swift
//  AERTRIP
//
//  Created by Apple  on 25.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

enum AddonsType{
    case seat,meal,other,baggage
}
// MARK: - Itinerary
struct AddonsQuotationsModel {
    var id: String
    var netAmount: Int
    var details: QTDetails
    var paymentModes: PaymentMode
    var bankMaster: [String]
    var walletBalance, userPoints, pointsBalance: Int
    var currency: String

    init(_ json:JSON = JSON()){
        id = json["id"].stringValue
        netAmount = json["net_amount"].intValue
        details = QTDetails(json["details"])
        paymentModes = PaymentMode(json: json["payment_modes"])
        bankMaster = json["bank_master"].arrayValue.map{$0.stringValue}
        walletBalance = json["wallet_balance"].intValue
        userPoints = json["user_points"].intValue
        pointsBalance = json["points_balance"].intValue
        currency = json["currency"].stringValue
    }
    
}

// MARK: - ItineraryDetails
struct QTDetails {
    var leg: [QTLeg]
    var addonsSum: [String:Int]
    var addons: QTAddons
    var addonsTotal, grandTotal: Int

    init(_ json:JSON = JSON()){
        leg = json["leg"].dictionaryValue.values.map{QTLeg($0)}
        addonsSum = Dictionary(uniqueKeysWithValues: json["addons_sum"].map { ($0.0, $0.1.intValue) })
        addons = QTAddons(json["addons"])
        addonsTotal = json["addons_total"].intValue
        grandTotal = json["grand_total"].intValue
    }
}

// MARK: - Addons
struct QTAddons {
    var details: QTAddonsDetails
    var total: Int
    init(_ json:JSON = JSON()){
        details = QTAddonsDetails(json["details"])
        total = json["total"].intValue
    }
}

// MARK: - AddonsDetails
struct QTAddonsDetails {
    var seat: AddonDetails
    var baggage: AddonDetails
    var meal: AddonDetails
    var other: AddonDetails
    
    init(_ json:JSON = JSON()){
        seat = AddonDetails(json["seat"])
        baggage = AddonDetails(json["baggage"])
        meal = AddonDetails(json["meal"])
        other = AddonDetails(json["special"])
    }
    
}

// MARK: - Seat
struct AddonDetails {
    var paxCount, total: Int
    init(_ json:JSON = JSON()){
        paxCount = json["pax_count"].intValue
        total = json["total"].intValue
    }
}


// MARK: - The8976
struct QTLeg {
    var legID: Int
    var flights: [QTFlights]
    var flightIDS: [Int]
    var legTotal: Int
    var typeTotal: TypeTotal

     init(_ json:JSON = JSON()) {
        legID = json["leg_id"].intValue
        flights = json["flights"].dictionaryValue.values.map{QTFlights($0)}
        flightIDS = json["flight_ids"].arrayValue.map{$0.intValue}
        legTotal = json["leg_total"].intValue
        typeTotal = TypeTotal(json["type_total"])
    }
}


// MARK: - Flights
struct QTFlights {
    var flightID: Int
    var airlineCode, airlineName, flightNumber, origin: String
    var destination, std: String
    var pax: [QTPax]
    
    init(_ json:JSON = JSON()) {
        flightID = json["flight_id"].intValue
        airlineCode = json["airline_code"].stringValue
        airlineName = json["airline_name"].stringValue
        flightNumber = json["flight_number"].stringValue
        origin = json["origin"].stringValue
        destination = json["destination"].stringValue
        std = json["std"].stringValue
        pax = json["pax"].dictionaryValue.values.map{QTPax($0)}
    }
    
    var route: NSAttributedString{
        let route = NSMutableAttributedString(string: "")
        let attributes = [NSAttributedString.Key.font:AppFonts.Regular.withSize(14.0), .foregroundColor: AppColors.themeBlack]
        let origin = NSAttributedString(string: self.origin, attributes: attributes)
        route.append(origin)
        route.append((AppGlobals.shared.getStringFromImage(with: AppImages.onewayIcon)))
        let destination = NSAttributedString(string: self.destination, attributes: attributes)
        route.append(destination)
        return route
    }
}

// MARK: - Pax
struct QTPax{
    var paxId: Int
    var salutation, firstName, lastName, paxType: String
    var addon: QTPaxAddon

    init(_ json:JSON = JSON()) {
        paxId = json["pax_id"].intValue
        salutation  = json["salutation"].stringValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        paxType = json["pax_type"].stringValue
        addon = QTPaxAddon(json["addon"])
    }
}

// MARK: - Addon
struct QTPaxAddon {
    var seat: QTPaxAddonDetails
    var meal: QTPaxAddonDetails
    var baggage: QTPaxAddonDetails
    var other: QTPaxAddonDetails
    
    init(_ json:JSON = JSON()){
        seat = QTPaxAddonDetails(json, showFor: "seat")
        meal = QTPaxAddonDetails(json, showFor: "meal")
        baggage = QTPaxAddonDetails(json, showFor: "baggage")
        other = QTPaxAddonDetails(json, showFor: "special")
    }
    
}


struct QTPaxAddonDetails{
    
    var type, name, price, pPrice: String
    
    init(_ json:JSON = JSON(), showFor:String = "seat") {
        type = json["\(showFor)Type"].stringValue
        name = json["\(showFor)Name"].stringValue
        price = json["\(showFor)Price"].stringValue
        pPrice = json["\(showFor)PPrice"].stringValue
    }
    
}

// MARK: - TypeTotal
struct TypeTotal: Codable {
    var seat: Int
    var baggage:Int
    var meal:Int
    var other:Int
    
    init(_ json:JSON = JSON()){
        seat = json["seat"].intValue
        baggage = json["baggage"].intValue
        meal = json["meal"].intValue
        other = json["special"].intValue
    }
}

struct CustomAddonsModel{
    
    var legId:String = ""
    var flightId:String = ""
    var paxId:String = ""
    var fligtRoute:NSAttributedString = NSAttributedString(string: "")
    var addonsType:AddonsType
    var addonsDetails:QTPaxAddonDetails
    
    init(legId:String, flight:QTFlights, pax:QTPax, addonsType:AddonsType){
        self.legId = legId
        flightId = "\(flight.flightID)"
        paxId = "\(pax.paxId)"
        self.addonsType = addonsType
        switch self.addonsType{
        case .seat:
            addonsDetails = pax.addon.seat
        case .meal:
            addonsDetails = pax.addon.meal
        case .other:
            addonsDetails = pax.addon.other
        case .baggage:
            addonsDetails = pax.addon.baggage
        }
        self.setFlightRoute(flight)
    }
    
    mutating func setFlightRoute(_ flight:QTFlights){
        let route = NSMutableAttributedString(string: "")
        let attributes = [NSAttributedString.Key.font:AppFonts.Regular.withSize(14.0), .foregroundColor: AppColors.themeBlack]
        let origin = NSAttributedString(string: flight.origin, attributes: attributes)
        route.append(origin)
        route.append((AppGlobals.shared.getStringFromImage(with: AppImages.onewayIcon)))
        let destination = NSAttributedString(string: flight.destination, attributes: attributes)
        route.append(destination)
        let details = NSAttributedString(string: ": \(self.addonsDetails.name)", attributes: attributes)
        route.append(details)
        self.fligtRoute = route
    }
    
}


struct AddonsReceiptModel {
    var addonsDetails:QTDetails
    var paymentDetails: PaymentDetails

    init(_ json:JSON = JSON()){
        addonsDetails = QTDetails(json)
        paymentDetails = PaymentDetails(json)
    }
}
