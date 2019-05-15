//
//  APICaller+Booking.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    func getHotelInfo(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ hotel: HotelDetails? ) -> Void) {
                let frameworkBundle = Bundle(for: PKCountryPicker.self)
                guard let jsonPath = frameworkBundle.path(forResource: "hotelData", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
                    return completionBlock(false, [],nil)
                }
        
                do {
                    if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? JSONDictionary {
        
                        if let hotelDetail = jsonObjects["data"] as? JSONDictionary {
                            let hotel = hotelDetail["results"] as? JSONDictionary
                            let hotelInfo = HotelDetails.hotelInfo(response: hotel!) as? HotelDetails
        
                            completionBlock(true, [], hotelInfo)
                        }
                        else {
                            completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
                        }
                    }
                }
                catch {
                    completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
                }
    }
}
