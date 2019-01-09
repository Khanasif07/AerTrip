
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
    
    func willUpdateFavourite()
    func updateFavouriteSuccess(withMessage: String)
    func updateFavouriteFail()
}

class HotelPreferencesVM {
    
    weak var delegate: HotelPreferencesDelegate?
    private(set) var selectedStars = [Int]()
    private(set) var hotels = [CityHotels]()
    
    func webserviceForGetHotelPreferenceList() {
        
//        var params = JSONDictionary()
       self.delegate?.willCallApi()
        APICaller.shared.getHotelPreferenceList(params: [:], completionBlock: {(success, errors, cities, stars)  in
            
            if success {

                self.hotels = cities
                self.selectedStars = stars
                self.delegate?.getApiSuccess()
            }
            else {
                self.delegate?.getApiFailure(errors: errors)
            }
        })
    }
    
    func updateFavourite(forHotel: HotelsModel) {
        let param: JSONDictionary = ["hid[0]": forHotel.hotelId, "status": forHotel.isFavourite ? 0 : 1]
        
        self.delegate?.willUpdateFavourite()
        APICaller.shared.callUpdateFavouriteAPI(params: param) { (isSuccess, errors, successMessage) in
            if isSuccess {
                self.delegate?.updateFavouriteSuccess(withMessage: successMessage)
            }
            else {
                self.delegate?.updateFavouriteFail()
            }
        }
    }

    func getHotelsByStarPreference(stars: [Int]) {
        var param: JSONDictionary = [:]
        for (idx, value) in stars.enumerated() {
            param["stars[\(idx)]"] = value
        }
        
        APICaller.shared.getHotelsByStarPreference(params: param) { (success, error, hotels) in
            
        }
    }
}
