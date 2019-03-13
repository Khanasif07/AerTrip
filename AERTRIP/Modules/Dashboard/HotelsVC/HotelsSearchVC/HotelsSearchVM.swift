//
//  HotelsSearchVM.swift
//  AERTRIP
//
//  Created by Admin on 25/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SearchHoteslOnPreferencesDelegate: class {
    func getAllHotelsOnPreferenceSuccess()
    func getAllHotelsOnPreferenceFail()
    
    func getRecentSearchesDataSuccess()
    func getRecentSearchesDataFail()
}

class HotelsSearchVM: NSObject{
    
    //MARK:- Properties
    //MARK:- Public
    var roomNumber: Int = 1
    var adultsCount: [Int] = [2]
    var childrenCounts: [Int] = [0]
    var childrenAge: [[Int]] = [[]]
    var checkInDate = "2019-03-18"
    var checkOutDate = "2019-03-23"
    var destId: String = ""
    var destType: String = ""
    var destName: String = ""
    var ratingCount: [Int] = []
    weak var delegate: SearchHoteslOnPreferencesDelegate?
    var vcodes: [String] = []
    var sid: String = ""
    var hotelListResult = [HotelsSearched]()
    var hotelSearchRequst : HotelSearchRequestModel?
    var recentSearchesData: [RecentSearchesModel]?
    var cityName = ""
    var stateName = ""
    
    class var hotelFormData: HotelFormPreviosSearchData {
        get {
            return UserDefaults.getCustomObject(forKey: APIKeys.hotelFormPreviosSearchData.rawValue) as? HotelFormPreviosSearchData ?? HotelFormPreviosSearchData()
        }
        set {
            UserDefaults.saveCustomObject(customObject: newValue, forKey: APIKeys.hotelFormPreviosSearchData.rawValue)
        }
    }
    
    //MARK:- Functions
    //================
    //MARK:- Private
    ///Params For Api
    private func paramsForApi() -> JSONDictionary {
        if self.ratingCount.isEmpty {
            self.ratingCount = [1,2,3,4,5]
        }
        var params = JSONDictionary()
        let _adultsCount = self.adultsCount
        let _starRating = self.ratingCount
        let _chidrenAge = self.childrenAge
        params[APIKeys.check_in.rawValue] = self.checkInDate
        params[APIKeys.check_out.rawValue] = self.checkOutDate
        params[APIKeys.dest_id.rawValue] = self.destId
        params[APIKeys.dest_type.rawValue] = self.destType
        params[APIKeys.dest_name.rawValue] = self.destName
        params[APIKeys.isPageRefereshed.rawValue] = true
        
        for (idx , data ) in _starRating.enumerated() {
//            params["filter[star][\(idx)star]"] = true
            params["filter[star][\(data)star]"] = true
            
        }
        
        for (idx ,  data) in _adultsCount.enumerated() {
            params["r[\(idx)][a]"] = data
        }
        
        for (idx , dataX) in _chidrenAge.enumerated() {
            for (idy , dataY) in dataX.enumerated() {
                if dataY != 0 {
                    params["r[\(idx)][c][\(idy)]"] = dataY
                }
            }
        }
        
//        printDebug(params)
        return params
    }
    
    //MARK:- Public
    
    ///SaveFormDataToUserDefaults
    func saveFormDataToUserDefaults() {
        let hotelData = HotelFormPreviosSearchData()
        hotelData.roomNumber     = self.roomNumber
        hotelData.adultsCount    = self.adultsCount
        hotelData.childrenCounts = self.childrenCounts
        hotelData.childrenAge    = self.childrenAge
//        hotelData.adultsCount    = self.adultsCount.map{ $0 }
//        hotelData.childrenCounts = self.childrenCounts.map{ $0 }
//        hotelData.childrenAge    = self.childrenAge.map{ $0 }
        hotelData.checkInDate    = self.checkInDate
        hotelData.checkOutDate   = self.checkOutDate
        hotelData.destId         = self.destId
        hotelData.destName       = self.destName
        hotelData.stateName      = self.stateName
        hotelData.cityName       = self.cityName
        hotelData.ratingCount    = self.ratingCount
        hotelData.destType       = self.destType
        
        HotelsSearchVM.hotelFormData = hotelData
        printDebug(HotelsSearchVM.hotelFormData)
    }
    
    ///Hotel List Api
    func hotelListOnPreferencesApi() {
        APICaller.shared.getHotelsListOnPreference(params: self.paramsForApi() ) { [weak self] (success, errors, sid, vCodes,searhRequest) in
            guard let sSelf = self else { return }
            if success {
                sSelf.vcodes = vCodes
                sSelf.sid = sid
                sSelf.hotelSearchRequst = searhRequest
                _ = CoreDataManager.shared.deleteAllData("HotelSearched")
                sSelf.delegate?.getAllHotelsOnPreferenceSuccess()
            } else {
                printDebug(errors)
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelSearch)
                sSelf.delegate?.getAllHotelsOnPreferenceFail()
            }
        }
    }
    
    func  getRecentSearchesData() {
        let params: JSONDictionary = [APIKeys.product.rawValue : "hotel"]
        printDebug(params)
        APICaller.shared.recentHotelsSearchesApi(params: params, loader: false) { [weak self] (success, errors, recentSearchesHotels) in
            guard let sSelf = self else { return }
            if success {
                sSelf.recentSearchesData = recentSearchesHotels
                sSelf.delegate?.getRecentSearchesDataSuccess()
            } else {
                printDebug(errors)
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelSearch)
                sSelf.delegate?.getRecentSearchesDataFail()
            }
        }
    }
}
