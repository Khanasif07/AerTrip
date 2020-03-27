//
//  HotelsSearchVM.swift
//  AERTRIP
//
//  Created by Admin on 25/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SearchHoteslOnPreferencesDelegate: class {
    func getRecentSearchesDataSuccess()
    func getRecentSearchesDataFail()
    
    func setRecentSearchesDataSuccess()
    func setRecentSearchesDataFail()
    
    func getMyLocationSuccess()
    func getMyLocationFail()
}

class HotelsSearchVM: NSObject{
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: SearchHoteslOnPreferencesDelegate?
    var hotelListResult = [HotelsSearched]()
    var recentSearchesData: [RecentSearchesModel]?
    var searchedFormData: HotelFormPreviosSearchData = HotelFormPreviosSearchData()
    var nearMeLocation: SearchedDestination?

    class var hotelFormData: HotelFormPreviosSearchData {
        get {
            return UserDefaults.standard.retrieve(objectType: HotelFormPreviosSearchData.self, fromKey: APIKeys.hotelFormPreviosSearchData.rawValue) ?? HotelFormPreviosSearchData()
        }
        set {
            UserDefaults.standard.save(customObject: newValue, inKey: APIKeys.hotelFormPreviosSearchData.rawValue)
        }
    }
    
    //MARK:- Functions
    //================
    //MARK:- Private
    
    //MARK:- Public
    ///Get Recent Searches Data
    func getRecentSearchesData() {
        let params: JSONDictionary = [APIKeys.product.rawValue : "hotel"]
        printDebug(params)
        APICaller.shared.recentHotelsSearchesApi(loader: false) { [weak self] (success, errors, recentSearchesHotels) in
            guard let sSelf = self else { return }
            if success {
                sSelf.recentSearchesData = recentSearchesHotels
                sSelf.delegate?.getRecentSearchesDataSuccess()
            } else {
                printDebug(errors)
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
                sSelf.delegate?.getRecentSearchesDataFail()
            }
        }
    }
    
    func setRecentSearchesData() {
        let place: JSONDictionary = [APIKeys.error.rawValue : false , APIKeys.errorMsg.rawValue : "" , APIKeys.dest_id.rawValue : self.searchedFormData.destId , APIKeys.dest_type.rawValue : self.searchedFormData.destType , APIKeys.dest_name.rawValue : self.searchedFormData.destName]
        let checkInDate: JSONDictionary = [APIKeys.value.rawValue : self.searchedFormData.checkInDateWithDay, APIKeys.error.rawValue : false , APIKeys.errorMsg.rawValue : ""]
        let checkOutDate: JSONDictionary = [APIKeys.value.rawValue : self.searchedFormData.checkOutDateWithDay, APIKeys.error.rawValue : false , APIKeys.errorMsg.rawValue : ""]
        let nights: JSONDictionary = [APIKeys.value.rawValue : self.searchedFormData.totalNights, APIKeys.error.rawValue : false , APIKeys.errorMsg.rawValue : ""]
        let guests: JSONDictionary = [APIKeys.value.rawValue : "\(self.searchedFormData.adultsCount.count) Room,\(self.searchedFormData.totalGuestCount) Guests", APIKeys.error.rawValue : false , APIKeys.errorMsg.rawValue : ""]
        
        var room: JSONDictionaryArray = []
        for (index,adultData) in self.searchedFormData.adultsCount.enumerated() {
            var childArrayData: JSONDictionaryArray = []
            
            if index < self.searchedFormData.childrenAge.count {
                for (childIndex,child) in self.searchedFormData.childrenAge[index].enumerated() {
                    if  childIndex < self.searchedFormData.childrenCounts[index] {
                    
                    let show: Int = child >= 0 ? 1 : 0
                    let childData: JSONDictionary = [APIKeys.show.rawValue : show , APIKeys.age.rawValue : child , APIKeys.error.rawValue : false]
                    childArrayData.append(childData)
                    }
                }
            }
            let roomData: JSONDictionary = [APIKeys.adults.rawValue : adultData , APIKeys.child.rawValue : childArrayData , APIKeys.show.rawValue : 1]
            room.append(roomData)
        }
        
        var star: JSONDictionary = [:]
        for rating in self.searchedFormData.ratingCount {
            star["\(rating)\(APIKeys.star.rawValue.lowercased())"] = true
        }
        
        let filter: JSONDictionary = [APIKeys.star.rawValue : star]
        
        let query: JSONDictionary = [APIKeys.place.rawValue : place , APIKeys.checkInDate.rawValue : checkInDate , APIKeys.checkOutDate.rawValue : checkOutDate , APIKeys.nights.rawValue : nights , APIKeys.guests.rawValue : guests, APIKeys.room.rawValue : room , APIKeys.filter.rawValue : filter, APIKeys.lat.rawValue : self.searchedFormData.lat, APIKeys.lng.rawValue : self.searchedFormData.lng ]

        
        let params: JSONDictionary = [
            APIKeys.product.rawValue : "hotel",
            "data[start_date]" : self.searchedFormData.checkInDate,
            "data[query]" : AppGlobals.shared.json(from: query) ?? ""
        ]
        printDebug(params)
        APICaller.shared.setRecentHotelsSearchesApi(params: params) { [weak self] (success, response, errors) in
            guard let sSelf = self else { return }
            if success {
                printDebug(response)
                sSelf.delegate?.setRecentSearchesDataSuccess()
            } else {
                printDebug(errors)
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
                sSelf.delegate?.setRecentSearchesDataFail()
            }
        }
    }
    
    func hotelsNearByMe() {
        APICaller.shared.getHotelsNearByMe(params: [:]) { [weak self] (success, error, hotel) in
            
            guard let sSelf = self else {return}
            
            if success, let obj = hotel {
                sSelf.nearMeLocation = obj
                sSelf.delegate?.getMyLocationSuccess()
            }
            else {
                //AppToast.default.sho
                sSelf.delegate?.getMyLocationFail()
            }
        }
    }
}

