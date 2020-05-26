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
            leg = Dictionary(uniqueKeysWithValues: json["leg"].map { ($0.0, SeatMapLeg($0.1)) })
        }
    }
    
    struct SeatMapLeg {
        let ttl: [String]
        let flights: [String: SeatMapFlight]
        
        init(_ json: JSON) {
            ttl = json["ttl"].arrayValue.map { $0.stringValue }
            flights = Dictionary(uniqueKeysWithValues: json["flights"].map { ($0.0, SeatMapFlight($0.1)) })
        }
    }
    
    struct SeatMapFlight {
        let ttl: String
        let fr: String
        let to: String
        let dt: String
        let at: String
        let cc: String
        let al: String
        let ft: Int
        let md: Md
        
        init() {
            self.init(JSON())
        }
        
        init(_ json: JSON) {
            ttl = json["ttl"].stringValue
            fr = json["fr"].stringValue
            to = json["to"].stringValue
            dt = json["dt"].stringValue
            at = json["at"].stringValue
            cc = json["cc"].stringValue
            al = json["al"].stringValue
            ft = json["ft"].intValue
            md = Md(json["md"])
        }
    }
    
    struct Md {
        let columns: [String]
        let rows: [Int: [String: SeatMapRow]]
        
        var rowsArr: [String] {
            self.rows.keys.map { $0.toString }
        }
        
        init(_ json: JSON) {
            columns = json["columns"].arrayValue.map { $0.stringValue }
            rows = Dictionary(uniqueKeysWithValues: json["rows"].map { (($0.0.toInt ?? 0), Dictionary(uniqueKeysWithValues: $0.1.map { ($0.0, SeatMapRow($0.1)) }))})
            
        }
    }
    
    struct SeatMapRow {
        let columnData: ColumnData
        let aisleValue: Bool
        
        init(_ json: JSON) {
            columnData = ColumnData(json)
            aisleValue = json.boolValue
        }
    }
    
//    struct aisleDict {
//        let key: String
//        let value: Bool
//    }
//
//    struct ColumnDict {
//        let key: String
//        let value: ColumnData
//
//        init(_ json: JSON) {
//
//        }
//    }
    
    struct ColumnData {
        let ssrCode: String
        let type: String
        let amount: Int
        let currency: String
        let availability: String
        let characteristic: [String]
        let rank: Int
        let postBooking: Bool
        
        init(_ json: JSON) {
            ssrCode = json["ssr_code"].stringValue
            type = json["type"].stringValue
            amount = json["amount"].intValue
            currency = json["currency"].stringValue
            availability = json["availability"].stringValue
            characteristic = json["characteristic"].arrayValue.map { $0.stringValue }
            rank = json["rank"].intValue
            postBooking = json["postbooking"].boolValue
        }
    }

}
