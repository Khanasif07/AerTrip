//
//  SelectDestinationVM.swift
//  AERTRIP
//
//  Created by Admin on 23/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SelectDestinationVMDelegate: class {
    
    func searchDestinationSuccess()
    func searchDestinationFail()
    
    func getAllPopularHotelsSuccess()
    func getAllPopularHotelsFail()
    
    func getMyLocationSuccess(selected: SearchedDestination)
    func getMyLocationFail()
}

class SelectDestinationVM: NSObject {
    
    //MARK:- Properties
    //MARK:- Public
    var recentSearchLimit: Int {
        return min(_recentSearchLimit, self.recentSearches.count)
    }
    var popularDestinationLimit: Int {
        return min(_popularDestinationLimit, self.popularHotels.count)
    }
    
    var searchedHotels = JSONDictionary()
    var allTypes: [String] {
        return Array(searchedHotels.keys)
    }
    
    var popularHotels = [SearchedDestination]()
    var recentSearches: [SearchedDestination] {
        return self._recentSearches ?? [SearchedDestination]()
    }
    
    weak var delegate: SelectDestinationVMDelegate?
    
    //MARK:- Private
    private let _recentSearchLimit: Int = 5
    private let _popularDestinationLimit: Int = 10
    
    private var _recentSearches: [SearchedDestination]? {
        get {
            
            if let data = UserDefaults.getObject(forKey: "recentSearches") as? Data {
                
                do {
                    let hotels = try PropertyListDecoder().decode([SearchedDestination].self, from: data)
                    return hotels
                }
                catch let error{
                    printDebug("Error: \(error)")
                    return nil
                }
            }
            return nil
        }
        set {
            
            if let value = newValue {
                do {
                    let data = try PropertyListEncoder().encode(value)
                    UserDefaults.setObject(data, forKey: "recentSearches")
                }
                catch let error{
                    printDebug("Error: \(error)")
                }
            }
            else {
                UserDefaults.removeObject(forKey: "recentSearches")
            }
        }
    }
    
    //MARK:- Methods
    //MARK:- Public
    func searchDestination(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(callSearchDestinationAPI(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc private func callSearchDestinationAPI(_ forText: String) {
        var param = JSONDictionary()
        param["q"] = forText
        APICaller.shared.getSearchedDestinationHotels(params: param) { [weak self] (success, errors, hotels) in
            guard let sSelf = self else {return}
            
            if success {
                sSelf.searchedHotels = hotels                
                sSelf.delegate?.searchDestinationSuccess()
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
                sSelf.delegate?.searchDestinationFail()
            }
        }
    }
    
    func getAllPopularHotels() {
        
        var params = JSONDictionary()
        params["popular_destination"] = 1
        
        APICaller.shared.getPopularHotels(params: params) { [weak self] (success, error, hotels) in
            
            guard let sSelf = self else {return}
            
            if success {
                sSelf.popularHotels = hotels
                sSelf.delegate?.getAllPopularHotelsSuccess()
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .hotelsSearch)
                sSelf.delegate?.getAllPopularHotelsFail()
            }
        }
    }
    
    func updateRecentSearch(hotel: SearchedDestination) {
        if let recent = self._recentSearches {
            var temp = recent
            if recent.count < self._recentSearchLimit {
                temp.insert(hotel, at: 0)
            }
            else {
                temp.insert(hotel, at: 0)
                temp.removeLast()
            }
            self._recentSearches = temp
        }
        else {
            self._recentSearches = [hotel]
        }
    }
    
    func hotelsNearByMe() {
        APICaller.shared.getHotelsNearByMe(params: [:]) { [weak self] (success, error, hotel) in
            
            guard let sSelf = self else {return}
            
            if success, let obj = hotel {
                sSelf.delegate?.getMyLocationSuccess(selected: obj)
            }
            else {
                //AppToast.default.sho
                sSelf.delegate?.getMyLocationFail()
            }
        }
    }
}
