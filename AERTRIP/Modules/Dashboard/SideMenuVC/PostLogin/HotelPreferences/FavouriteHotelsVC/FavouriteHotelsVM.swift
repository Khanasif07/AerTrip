//
//  ViewAllHotelsVM.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
//import PKCategoryView

protocol ViewAllHotelsVMDelegate: class {
    func willGetHotelPreferenceList()
    func getHotelPreferenceListSuccess()
    func getHotelPreferenceListFail()
    
    func willUpdateFavourite()
    func updateFavouriteSuccess()
    func updateFavouriteFail()
}

class FavouriteHotelsVM {
    
    //MARK:- Properties
    //MARK:- Public
    // var allTabs: [PKCategoryItem] = []
    //var allTabs: [ATCategoryItem] = []
    
    var hotels = [CityHotels]()
    
    weak var delegate: ViewAllHotelsVMDelegate?
    
    //MARK:- Private
    //MARK:- Methods
    //MARK:- Private
    
    //MARK:- Public
    func webserviceForGetHotelPreferenceList() {
        
        self.delegate?.willGetHotelPreferenceList()
        APICaller.shared.getHotelPreferenceList(params: [:], completionBlock: { [weak self] (success, errors, cities, stars)  in
            guard let strongSelf = self else {return}
            if success {
                
                strongSelf.hotels = cities
//                strongSelf.allTabs = strongSelf.hotels.map { PKCategoryItem(title: $0.cityName, normalImage: nil, selectedImage: nil) }
                
                strongSelf.delegate?.getHotelPreferenceListSuccess()
            }
            else {
                strongSelf.delegate?.getHotelPreferenceListFail()
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
                if errors.contains(ATErrorManager.LocalError.noInternet.rawValue) {
                    AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
                }
                self.delegate?.updateFavouriteFail()
            }
        }
    }
    
    func removeAllHotels(forCityIndex: Int) {
        if !hotels.isEmpty {
            self.hotels.remove(at: forCityIndex)
        }
//        self.allTabs = self.hotels.map { PKCategoryItem(title: $0.cityName, normalImage: nil, selectedImage: nil) }
    }
    
    func removeHotel(forCity: CityHotels, cityIndex: Int, forHotelAtIndex: Int) {
        var currentCity = forCity
        if !forCity.holetList[forHotelAtIndex].isFavourite {
            if forCity.holetList.count > 1 {
                currentCity.holetList.remove(at: forHotelAtIndex)
                self.hotels[cityIndex] = currentCity
            }
            else {
                self.removeAllHotels(forCityIndex: cityIndex)
            }
        }
    }
    
    //MARK:- Action
}
