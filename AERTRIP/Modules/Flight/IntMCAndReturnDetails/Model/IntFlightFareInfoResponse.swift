//
//  IntFlightFareInfoResponse.swift
//  Aertrip
//
//  Created by Apple  on 12.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation
struct IntFlightFareInfoResponse {
    var updatedFareInfo: [IntFareInfo]
    init(_ json: JSON){
        var updFareInfo = [IntFareInfo]()
        if let jsonDict = json["data"].dictionary{
            for value in jsonDict.values{
                updFareInfo.append(IntFareInfo(value))
            }
        }
        updatedFareInfo = updFareInfo
    }
}

struct IntFareInfo {
    var cp : IntTaxes.SubFares
    var rscp : IntTaxes.SubFares
    init(_ json: JSON) {
        cp = IntTaxes.SubFares(json["cp"])
        rscp = IntTaxes.SubFares(json["rscp"])
    }
}
