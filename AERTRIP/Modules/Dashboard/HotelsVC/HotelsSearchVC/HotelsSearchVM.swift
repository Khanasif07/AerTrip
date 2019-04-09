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
    weak var delegate: SearchHoteslOnPreferencesDelegate?
    var vcodes: [String] = []
    var sid: String = ""
    var hotelListResult = [HotelsSearched]()
    var hotelSearchRequst : HotelSearchRequestModel?
    var recentSearchesData: [RecentSearchesModel]?
    var searchedFormData: HotelFormPreviosSearchData = HotelFormPreviosSearchData()

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
    
    ///Validations
    internal func validationForHotelsForm() {
        
    }
    
    ///Params For Api
    private func paramsForApi() -> JSONDictionary {
        if self.searchedFormData.ratingCount.isEmpty {
            self.searchedFormData.ratingCount = [1,2,3,4,5]
        }
        var params = JSONDictionary()
        let _adultsCount = self.searchedFormData.adultsCount
        let _starRating = self.searchedFormData.ratingCount
        let _chidrenAge = self.searchedFormData.childrenAge
        params[APIKeys.check_in.rawValue] = self.searchedFormData.checkInDate
        params[APIKeys.check_out.rawValue] = self.searchedFormData.checkOutDate
        params[APIKeys.dest_id.rawValue] = self.searchedFormData.destId
        params[APIKeys.dest_type.rawValue] = self.searchedFormData.destType
        params[APIKeys.dest_name.rawValue] = self.searchedFormData.destName
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
        
        printDebug(params)
        return params
    }
    
    //MARK:- Public
    
    ///SaveFormDataToUserDefaults
    func saveFormDataToUserDefaults() {
        HotelsSearchVM.hotelFormData = self.searchedFormData
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
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
                sSelf.delegate?.getAllHotelsOnPreferenceFail()
            }
        }
    }
    
    ///Get Recent Searches Data
    func  getRecentSearchesData() {
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
}
