//
//  HotelsResultVM.swift
//  AERTRIP
//
//  Created by Admin on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelsResultVM: NSObject {
    
    var hotelListResult = [HotelsSearched]()
    var hotelSearchRequest : HotelSearchRequestModel?
    
    func searchHotel(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(callSearchHotel(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc private func callSearchHotel(_ forText: String) {
        printDebug("search text for: \(forText)")
    }
}
