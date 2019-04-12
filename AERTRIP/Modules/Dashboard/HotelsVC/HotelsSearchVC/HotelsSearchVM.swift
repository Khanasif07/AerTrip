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
}

class HotelsSearchVM: NSObject{
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: SearchHoteslOnPreferencesDelegate?
    var hotelListResult = [HotelsSearched]()
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
    
    //MARK:- Public
    
    ///SaveFormDataToUserDefaults
    func saveFormDataToUserDefaults() {
        HotelsSearchVM.hotelFormData = self.searchedFormData
        printDebug(HotelsSearchVM.hotelFormData)
    }
    
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
}
