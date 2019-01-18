//
//  ViewAllHotelsVM.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol ViewAllHotelsVMDelegate: class {
    func willGetHotelPreferenceList()
    func getHotelPreferenceListSuccess()
    func getHotelPreferenceListFail()
    
    func willUpdateFavourite()
    func updateFavouriteSuccess()
    func updateFavouriteFail()
}

class ViewAllHotelsVM {
    
    //MARK:- Properties
    //MARK:- Public
    var hotels = [CityHotels]()

    var allTabs: [PKViewPagerTab] {
        return self.hotels.map { (city) -> PKViewPagerTab in
            PKViewPagerTab(title: city.cityName, image: nil)
        }
    }
    
    weak var delegate: ViewAllHotelsVMDelegate?
    
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Private
    
    //MARK:- Public
    func webserviceForGetHotelPreferenceList() {
        
        self.delegate?.willGetHotelPreferenceList()
        APICaller.shared.getHotelPreferenceList(params: [:], completionBlock: {(success, errors, cities, stars)  in
            
            if success {
                
                self.hotels = cities
                self.delegate?.getHotelPreferenceListSuccess()
            }
            else {
                self.delegate?.getHotelPreferenceListFail()
            }
        })
    }
    
    func updateFavourite(forHotels: [HotelsModel]) {
        var param: JSONDictionary = ["status": 0]
        for (idx, hotel) in forHotels.enumerated() {
            param["hid[\(idx)]"] = hotel.hotelId
        }
        
        self.delegate?.willUpdateFavourite()
        APICaller.shared.callUpdateFavouriteAPI(params: param) { (isSuccess, errors, successMessage) in
            if isSuccess {
                self.delegate?.updateFavouriteSuccess()
            }
            else {
                self.delegate?.updateFavouriteFail()
            }
        }
    }
    
    //MARK:- Action
}
