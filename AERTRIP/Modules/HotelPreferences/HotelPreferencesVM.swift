
//
//  HotelPreferencesV.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 31/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

protocol HotelPreferencesDelegate: NSObjectProtocol {
    
    func willCallApi()
    func getApiSuccess()
    func getApiFailure(errors: ErrorCodes)
}

class HotelPreferencesVM {
    
    weak var delegate: HotelPreferencesDelegate?
    var ratingFilter = [String]()
    var hotels = [CityHotels]()
    
    func webserviceForGetHotelPreferenceList() {
        
//        var params = JSONDictionary()
       self.delegate?.willCallApi()
        APICaller.shared.getHotelPreferenceList(params: [:], completionBlock: {(success, errors, cities) in
            
            if success {

                self.hotels = cities
                self.delegate?.getApiSuccess()
            }
            else {
                self.delegate?.getApiFailure(errors: errors)
            }
        })
    }
}
