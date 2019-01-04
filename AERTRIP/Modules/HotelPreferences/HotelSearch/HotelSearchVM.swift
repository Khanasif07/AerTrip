//
//  HotelSearchVM.swift
//  AERTRIP
//
//  Created by Admin on 03/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelSearchVMDelegate: class {
    func willSearchForHotels()
    func searchHotelsSuccess()
    func searchHotelsFail()
}

class HotelSearchVM: NSObject {
    
    weak var delegate: HotelSearchVMDelegate?
    var hotels: [HotelsModel] = []
    
    func searchHotel(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(callSearchHotelAPI(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc private func callSearchHotelAPI(_ forText: String) {
        print("searchHotel for: \(forText)")
        let param: JSONDictionary = ["q":forText]
        
        self.delegate?.willSearchForHotels()
        APICaller.shared.callSearchHotelsAPI(params: param) { (isSuccess, errors, hotels) in
            if isSuccess {
                self.hotels = hotels
                self.delegate?.searchHotelsSuccess()
            }
            else {
                self.delegate?.searchHotelsFail()
            }
        }
    }
}
