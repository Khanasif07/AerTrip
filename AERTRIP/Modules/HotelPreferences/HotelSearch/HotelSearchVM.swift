//
//  HotelSearchVM.swift
//  AERTRIP
//
//  Created by Admin on 03/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelSearchVM: NSObject {
    
    func searchHotel(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(callSearchHotelAPI(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc private func callSearchHotelAPI(_ forText: String) {
        print("searchHotel for: \(forText)")
    }
}
