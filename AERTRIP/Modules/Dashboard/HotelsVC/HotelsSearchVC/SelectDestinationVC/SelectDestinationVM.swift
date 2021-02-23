//
//  SelectDestinationVM.swift
//  AERTRIP
//
//  Created by Admin on 23/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SelectDestinationVMDelegate: class {
    
    func willSearchDestination()
    func searchDestinationSuccess()
    func searchDestinationFail()
    
    func getAllPopularHotelsSuccess()
    func getAllPopularHotelsFail()
    
    func getMyLocationSuccess(selected: SearchedDestination)
    func getMyLocationFail()
}

class SelectDestinationVM: NSObject {
    
    enum DestinationType: RawRepresentable {
        case didYouMean
        case city
        case area
        case poi
        case hotel
        case custom(name: String)
        
        init?(rawValue: String) {
            switch (rawValue){
            case "Did you mean?".lowercased(): self = .didYouMean
            case "city".lowercased(): self = .city
            case "area".lowercased(): self = .area
            case "poi".lowercased(): self = .poi
            case "hotel".lowercased(): self = .hotel
            default: self = .custom(name: rawValue.lowercased())
            }
        }
        var rawValue: String{
            switch(self){
            case .didYouMean: return "Did you mean?".lowercased()
            case .city: return "city".lowercased()
            case .area: return "area".lowercased()
            case .poi: return "poi".lowercased()
            case .hotel: return "hotel".lowercased()
            case .custom(let ttl): return ttl.lowercased()
            }
        }
        
        var title: String {
            switch(self){
            case .didYouMean: return "Did you mean?".lowercased()
            case .city: return "city".lowercased()
            case .area: return "area".lowercased()
            case .poi: return "point of interest".lowercased()
            case .hotel: return "hotel".lowercased()
            case .custom(let ttl): return ttl.lowercased()
            }
        }
        
        var priority: Int {
            switch(self){
            case .didYouMean: return 0
            case .city: return 1
            case .area: return 3
            case .poi: return 4
            case .hotel: return 5
            case .custom(let ttl):
                if ttl.lowercased().contains("top".lowercased()) {
                    return 2
                }
                return 6
            }
        }
    }
    //MARK:- Properties
    //MARK:- Public
    var recentSearchLimit: Int {
        return min(_recentSearchLimit, self.recentSearches.count)
    }
    var popularDestinationLimit: Int {
        return min(_popularDestinationLimit, self.popularHotels.count)
    }
    
    var searchedHotels = JSONDictionary()
    var allTypes: [DestinationType] {
        var temp = Array(searchedHotels.keys).map { DestinationType(rawValue: $0)! }
        temp.sort { (ds1, ds2) -> Bool in
            ds1.priority < ds2.priority
        }
        return temp
    }
    
    var popularHotels = [SearchedDestination]()
    var recentSearches: [SearchedDestination] {
        return self._recentSearches ?? [SearchedDestination]()
    }
    
    var showDidYouMeanLbl = false
    var headerViewHeight: (min: CGFloat, max: CGFloat) = (70, 100)
    
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
        self.delegate?.willSearchDestination()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(callSearchDestinationAPI(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc private func callSearchDestinationAPI(_ forText: String) {
        var param = JSONDictionary()
        param["q"] = forText
        APICaller.shared.getSearchedDestinationHotels(params: param) { [weak self] (success, errors, hotels) in
            guard let sSelf = self else {return}
            var hotelsDict = hotels
            
            if success {
                if let showDidYouMean = hotelsDict["showDidYouMean"] as? Bool, showDidYouMean {
                    sSelf.showDidYouMeanLbl = true
                    hotelsDict.removeValue(forKey: "showDidYouMean")
                } else {
                    sSelf.showDidYouMeanLbl = false
                }
                sSelf.searchedHotels = hotelsDict
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
                
                //check and remove the data from popular if it exist in recents.
                var tamp = [SearchedDestination]()
                if let recent = sSelf._recentSearches {
                    for hotel in hotels {
                        if !recent.contains(where: { (dest) -> Bool in
                            dest.dest_id == hotel.dest_id
                        }) {
                            if tamp.count < 5 {
                                tamp.append(hotel)
                            }
                        }
                    }
                    sSelf.popularHotels = tamp
                }
                else {
                    sSelf.popularHotels = hotels.count > 5 ? Array(hotels[0..<5]) : hotels
                }
                
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
            
            //hold all the recent data
            var temp = recent
            
            //check if it is already added or not, if not added then add otherwise update the position
            if let index = recent.firstIndex(where: { (dest) -> Bool in
                dest.dest_id == hotel.dest_id
            }) {
                
                //if index is greater than 0 than update.
                if index > 0 {
                    let toUpdate = temp.remove(at: index)
                    temp.insert(toUpdate, at: 0)
                }
                self._recentSearches = temp
            }
            else {
                //insert the recnt on the first position
                if recent.count < self._recentSearchLimit {
                    temp.insert(hotel, at: 0)
                }
                else {
                    temp.insert(hotel, at: 0)
                    temp.removeLast()
                }
                self._recentSearches = temp
            }
        }
        else {
            self._recentSearches = [hotel]
        }
    }
    
    func hotelsNearByMe() {
        var params = JSONDictionary()
        if let value = LocationManager.shared.lastUpdatedCoordinate {
            params["latLong"] = "\(value.latitude),\(value.longitude)"
        }
        APICaller.shared.getHotelsNearByMe(params: params) { [weak self] (success, error, hotel) in
            
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
