//
//  SeatMapModel.swift
//  AERTRIP
//
//  Created by Rishabh on 26/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

struct SeatMapModel {
    let data: SeatMapData
    
    init() {
        self.init(JSON())
    }
    
    init(_ json: JSON) {
        data = SeatMapData(json["data"])
    }
    
    struct SeatMapData {
        let leg: [String: SeatMapLeg]
        
        init(_ json: JSON) {
            if json["leg"] != nil {
                leg = Dictionary(uniqueKeysWithValues: json["leg"].map { ($0.0, SeatMapLeg($0.1, $0.0)) })
            } else {
                leg = Dictionary(uniqueKeysWithValues: json["SEAT"].map { ($0.0, SeatMapLeg($0.1, $0.0)) })
            }
        }
    }
    
    struct SeatMapLeg {
        let lfk: String
        let ttl: [String]
        let flights: [String: SeatMapFlight]
        
        init(_ json: JSON,_ lfk: String) {
            self.lfk = lfk
            ttl = json["ttl"].arrayValue.map { $0.stringValue }
            flights = Dictionary(uniqueKeysWithValues: json["flights"].map { ($0.0, SeatMapFlight($0.1, lfk, $0.0)) })
        }
    }
    
    struct SeatMapFlight {
        let lfk: String
        let ffk: String
        let ttl: String
        let fr: String
        let to: String
        let dt: String
        let at: String
        let cc: String
        let al: String
        let ft: Int
        var ud: DeckData
        var md: DeckData
        
        init() {
            self.init(JSON(), "", "")
        }
        
        init(_ json: JSON,_ lfk: String,_ ffk: String) {
            self.lfk = lfk
            self.ffk = ffk
            ttl = json["ttl"].stringValue
            fr = json["fr"].stringValue
            to = json["to"].stringValue
            dt = json["dt"].stringValue
            at = json["at"].stringValue
            cc = json["cc"].stringValue
            al = json["al"].stringValue
            ft = json["ft"].intValue
            ud = DeckData(json["ud"], lfk, ffk)
            md = DeckData(json["md"], lfk, ffk)
        }
    }
    
    struct DeckData {
        let lfk: String
        let ffk: String
        let columns: [String]
        var rows: [Int: [String: SeatMapRow]]
        
        var rowsArr: [String] {
            let rowsStrArr = self.rows.keys.map { $0 }.sorted()
            return rowsStrArr.map { $0.toString }
        }
        
        init(_ json: JSON,_ lfk: String,_ ffk: String) {
            self.lfk = lfk
            self.ffk = ffk
            columns = json["columns"].arrayValue.map { $0.stringValue }
            rows = Dictionary(uniqueKeysWithValues: json["rows"].map { (($0.0.toInt ?? 0), Dictionary(uniqueKeysWithValues: $0.1.map { ($0.0, SeatMapRow($0.1, lfk, ffk)) }))})
        }
    }
    
    struct SeatMapRow {
        var isPreselected = false
        let lfk: String
        let ffk: String
        var columnData: ColumnData
        let aisleValue: Bool
        let isWindowSeat: Bool
        
        init() {
            self.init(JSON(), "", "")
        }
        
        init(_ json: JSON,_ lfk: String,_ ffk: String) {
            self.lfk = lfk
            self.ffk = ffk
            columnData = ColumnData(json)
            aisleValue = json.boolValue
            isWindowSeat = columnData.characteristic.contains("Window")
        }
    }
    
    struct ColumnData {
        let ssrCode: String
        let type: String
        let amount: Int
        let currency: String
        let availability: SeatAvailability
        let characteristic: [String]
        let rank: Int
        let postBooking: Bool
        
        var passenger: ATContact?
        
        var rowStr: String {
            if let number = Int(ssrCode.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                print(number)
                return "\(number)"
            }
            return ""
        }
        var columnStr: String {
            ssrCode.components(separatedBy: CharacterSet.letters.inverted).joined()
        }
        
        var seatNumber: String {
            rowStr + columnStr
        }
        
        func getCharactericstic() -> String {
            var characteristicString = ""
            characteristic.forEach { (str) in
                characteristicString.append(str+", ")
            }
            if characteristicString.suffix(2) == ", " {
                characteristicString.removeLast(2)
            }
            return characteristicString
        }
        
        init(_ json: JSON) {
            ssrCode = json["ssr_code"].stringValue
            type = json["type"].stringValue
            amount = json["amount"].intValue
            currency = json["currency"].stringValue
            availability = SeatAvailability(rawValue: json["availability"].stringValue) ?? .none
            characteristic = json["characteristic"].arrayValue.map { $0.stringValue }
            rank = json["rank"].intValue
            postBooking = json["postbooking"].boolValue
        }
    }
    
    enum SeatAvailability: String {
        case available = "available"
        case blocked = "blocked"
        case occupied = "occupied"
        case none
    }
}
