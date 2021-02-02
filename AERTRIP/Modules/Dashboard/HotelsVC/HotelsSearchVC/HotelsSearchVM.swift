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
    
    func favouriteHotelAPISuccess()
}

class HotelsSearchVM: NSObject{
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: SearchHoteslOnPreferencesDelegate?
    var hotelListResult = [HotelsSearched]()
    var recentSearchesData: [RecentSearchesModel]?
    var searchedFormData: HotelFormPreviosSearchData = HotelFormPreviosSearchData()
    var nearMeLocation: SearchedDestination?
    static var isComminFromRecentWhatNext = false
    class var hotelFormData: HotelFormPreviosSearchData {
        get {
            return UserDefaults.standard.retrieve(objectType: HotelFormPreviosSearchData.self, fromKey: APIKeys.hotelFormPreviosSearchData.rawValue) ?? HotelFormPreviosSearchData()
        }
        set {
            UserDefaults.standard.save(customObject: newValue, inKey: APIKeys.hotelFormPreviosSearchData.rawValue)
        }
    }
    
    func createSearchedFormDataFromRecentRearch()-> HotelFormPreviosSearchData?{
        
        if let recentSearch = self.recentSearchesData?.first, !HotelsSearchVM.isComminFromRecentWhatNext{
            var seachedData = HotelFormPreviosSearchData()
            seachedData.destId = recentSearch.dest_id
//            seachedData.cityName = recentSearch.
            seachedData.destType = recentSearch.dest_type
            var splittedStringArray = recentSearch.dest_name.components(separatedBy: ",")
            let city = splittedStringArray.removeFirst()
            if seachedData.destType != "Hotel"{
                seachedData.cityName = city
            }
            let stateName = splittedStringArray.joined(separator: ",")
            seachedData.stateName = stateName
            seachedData.lat = recentSearch.lat
            seachedData.lng = recentSearch.lng
            seachedData.destName = recentSearch.dest_name
            seachedData.destId = recentSearch.dest_id
            
            if let checkIn = recentSearch.checkInDate.toDate(dateFormat: "E, dd MMM yy"), let checkOut = recentSearch.checkOutDate.toDate(dateFormat: "E, dd MMM yy"), checkIn > Date(){
                seachedData.checkInDate = checkIn.toString(dateFormat: "yyyy-MM-dd")
                seachedData.checkOutDate = checkOut.toString(dateFormat: "yyyy-MM-dd")
            }else if let checkIn = recentSearch.checkInDate.toDate(dateFormat: "yyyy-MM-dd"), checkIn > Date(){
                seachedData.checkInDate = recentSearch.checkInDate
                seachedData.checkOutDate = recentSearch.checkOutDate
            }else{
                seachedData.checkInDate = Date().toString(dateFormat: "yyyy-MM-dd")
                seachedData.checkOutDate = Date().add(years: 0, months: 0, days: 1, hours: 0, minutes: 0, seconds: 0)?.toString(dateFormat: "yyyy-MM-dd") ?? ""
            }
            
            

            seachedData.roomNumber     =  recentSearch.room?.count ?? 1
            var roomAdults = [Int]()
            var roomChid = [Int]()
            var roomChildAge = [[Int]]()
            for room in recentSearch.room ?? []{
                roomAdults.append(room.adultCounts.toInt ?? 2)
                roomChid.append(room.child.count)
                roomChildAge.append(room.child.map{$0.childAge})
            }
            seachedData.adultsCount  = (roomAdults.isEmpty) ? [2] : roomAdults
            seachedData.childrenCounts = roomChid
            seachedData.childrenAge = roomChildAge
            HotelsSearchVM.isComminFromRecentWhatNext = false
            return seachedData
//            HotelsSearchVM.hotelFormData = seachedData
        }
        
        return nil
        
    }
    
    func canSetRecentSearch() -> Bool {
        // TODO: Remove this method for this pointer https://app.asana.com/0/1181922655927025/1199180703186773/f
       // guard let lastSearchedData = self.recentSearchesData?.first else { return true }
        var canSetSearch = true
        guard let lastSearchedData = recentSearchesData?.first else { return true }
        
        if lastSearchedData.dest_id == self.searchedFormData.destId {
            printDebug("lastSearchedData.checkInDate \(lastSearchedData.checkInDate )")
            printDebug("lastSearchedData.checkOutDate \(lastSearchedData.checkOutDate)")
            printDebug("self.searchedFormData.checkInDateWithDay \(self.searchedFormData.checkInDateWithDay)")
            printDebug("self.searchedFormData.checkOutDateWithDay \(self.searchedFormData.checkOutDateWithDay)")

            if lastSearchedData.checkInDate ==  self.searchedFormData.checkInDateWithDay  && lastSearchedData.checkOutDate ==  self.searchedFormData.checkOutDateWithDay{
                printDebug("lastSearchedData.room?.count \(lastSearchedData.room?.count ?? 0)")
                printDebug("self.searchedFormData.adultsCount.count \(self.searchedFormData.adultsCount.count)")

                if (lastSearchedData.room?.count ?? 0) == self.searchedFormData.adultsCount.count {
                    for i in 0..<(lastSearchedData.room?.count ?? 0) {
                      printDebug("lastSearchedData.room?[\(i)].adultCounts \(lastSearchedData.room?[i].adultCounts ?? "0")")
                        printDebug("self.searchedFormData.adultsCount[\(i)] \(self.searchedFormData.adultsCount[i])")
                        
                        if (lastSearchedData.room?[i].adultCounts ?? "0") == "\(self.searchedFormData.adultsCount[i])" {
                            canSetSearch = true
                            break
                        } else {
                            canSetSearch = true
                            //break
                        }
                    }
                }
            }
        }
        
        
//        self.recentSearchesData?.forEach({ (lastSearchedData) in
        
//        if lastSearchedData.dest_id == self.searchedFormData.destId {
//            printDebug("lastSearchedData.checkInDate \(lastSearchedData.checkInDate )")
//            printDebug("lastSearchedData.checkOutDate \(lastSearchedData.checkOutDate)")
//            printDebug("self.searchedFormData.checkInDateWithDay \(self.searchedFormData.checkInDateWithDay)")
//            printDebug("self.searchedFormData.checkOutDateWithDay \(self.searchedFormData.checkOutDateWithDay)")
//
//            if lastSearchedData.checkInDate ==  self.searchedFormData.checkInDateWithDay  || lastSearchedData.checkOutDate ==  self.searchedFormData.checkOutDateWithDay{
//                printDebug("lastSearchedData.room?.count \(lastSearchedData.room?.count ?? 0)")
//                printDebug("self.searchedFormData.adultsCount.count \(self.searchedFormData.adultsCount.count)")
//
//                if (lastSearchedData.room?.count ?? 0) == self.searchedFormData.adultsCount.count {
//                    for i in 0..<(lastSearchedData.room?.count ?? 0) {
//                      printDebug("lastSearchedData.room?[\(i)].adultCounts \(lastSearchedData.room?[i].adultCounts ?? "0")")
//                        printDebug("self.searchedFormData.adultsCount[\(i)] \(self.searchedFormData.adultsCount[i])")
//
//                        if (lastSearchedData.room?[i].adultCounts ?? "0") == "\(self.searchedFormData.adultsCount[i])" {
//                            canSetSearch = false
//                            break
//                        } else {
//                            canSetSearch = true
//                            //break
//                        }
//                    }
//                }
//            }
//        }
//        })
        return canSetSearch
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
                sSelf.setupRecentlySearchedDestination()
                sSelf.delegate?.getRecentSearchesDataSuccess()
            } else {
                printDebug(errors)
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
                sSelf.delegate?.getRecentSearchesDataFail()
            }
        }
    }
    
    func setupRecentlySearchedDestination(){
        guard let recentSearches = self.recentSearchesData else {return}
        let destinationData = recentSearches.map({SearchedDestination(wirh: $0)})
        var destinations = [SearchedDestination]()
        var dict:[String:Int] = [:]
        destinationData.forEach { dest in
            if dict[dest.dest_id] == nil{
                dict[dest.dest_id] = 1
                destinations.append(dest)
            }
        }
        if let data = try? PropertyListEncoder().encode(destinations){
            UserDefaults.setObject(data, forKey: "recentSearches")
        }
        
    }
    
    func setRecentSearchesData() {
        guard self.canSetRecentSearch() else { return}
        
        let place: JSONDictionary = [APIKeys.error.rawValue : false , APIKeys.errorMsg.rawValue : "" , APIKeys.dest_id.rawValue : self.searchedFormData.destId , APIKeys.dest_type.rawValue : self.searchedFormData.destType , APIKeys.dest_name.rawValue : self.searchedFormData.destName]
        let checkInDate: JSONDictionary = [APIKeys.value.rawValue : self.searchedFormData.checkInDateWithDay, APIKeys.error.rawValue : false , APIKeys.errorMsg.rawValue : ""]
        let checkOutDate: JSONDictionary = [APIKeys.value.rawValue : self.searchedFormData.checkOutDateWithDay, APIKeys.error.rawValue : false , APIKeys.errorMsg.rawValue : ""]
        let nights: JSONDictionary = [APIKeys.value.rawValue : self.searchedFormData.totalNights, APIKeys.error.rawValue : false , APIKeys.errorMsg.rawValue : ""]
        
        let roomStr = searchedFormData.adultsCount.count < 2 ? "Room" : "Rooms"
        let guestStr = searchedFormData.totalGuestCount < 2 ? "Guest" : "Guests"
        let guests: JSONDictionary = [APIKeys.value.rawValue : "\(self.searchedFormData.adultsCount.count) \(roomStr), \(self.searchedFormData.totalGuestCount) \(guestStr)", APIKeys.error.rawValue : false , APIKeys.errorMsg.rawValue : ""]
        
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
        
        let query: JSONDictionary = [APIKeys.place.rawValue : place , APIKeys.checkInDate.rawValue : checkInDate , APIKeys.checkOutDate.rawValue : checkOutDate , APIKeys.nights.rawValue : nights , APIKeys.guests.rawValue : guests, APIKeys.room.rawValue : room , APIKeys.filter.rawValue : filter, APIKeys.lat.rawValue : self.searchedFormData.lat, APIKeys.lng.rawValue : self.searchedFormData.lng, APIKeys.search_nearby.rawValue : self.searchedFormData.isHotelNearMeSelected ]
        
        let params: JSONDictionary = [
            APIKeys.product.rawValue : "hotel",
            "data[start_date]" : self.searchedFormData.checkInDate.stringIn_ddMMyyyy,
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
        var params = JSONDictionary()
        if var value = LocationManager.shared.lastUpdatedCoordinate {
            if value.latitude == LocationManager.defaultCoordinate.latitude && value.longitude == LocationManager.defaultCoordinate.longitude {
                value = CLLocationCoordinate2D(latitude: 19.075989, longitude: 72.8773928)
            }
            params["latLong"] = "\(value.latitude),\(value.longitude)"
        } else {
            // default set to Mumbai
            params["latLong"] = "19.0759899, 72.8773928"
        }
        
        APICaller.shared.getHotelsNearByMe(params: params) { [weak self] (success, error, hotel) in
            
            guard let sSelf = self else {return}
            
            if success, var obj = hotel {
                if sSelf.nearMeLocation?.isHotelNearMeSelected ?? false {
                    obj.isHotelNearMeSelected = true
                }
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

// MARK:- Favourite Hotels
extension HotelsSearchVM {
    func callSearchDestinationAPI(_ hotelDetails: HotelFormPreviosSearchData) {
        var param = JSONDictionary()
        param["q"] = hotelDetails.destName
        APICaller.shared.getSearchedDestinationHotels(params: param) { [weak self] (success, errors, hotels) in
            guard let self = self else {return}
            
            if success {
                var isHotelFound = false
                if let searchedHotelsArr = hotels[APIKeys.hotel.rawValue] as? [SearchedDestination] {
                    for hotel in searchedHotelsArr {
                        if hotel.dest_id == hotelDetails.destId {
                            isHotelFound = true
                            self.updateHotelDataFromFavourites(hotel, isHotelFound: true)
                            self.delegate?.favouriteHotelAPISuccess()
                            break
                        }
                    }
                    if !isHotelFound {
                        if let firstHotel = searchedHotelsArr.first {
                            self.updateHotelDataFromFavourites(firstHotel)
                        }
                    }
                }
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
//                sSelf.delegate?.searchDestinationFail()
            }
        }
    }
    
    private func updateHotelDataFromFavourites(_ hotel: SearchedDestination, isHotelFound: Bool = false) {
        let hotelName = hotel.dest_name
        let address = hotel.label
        let lat =  hotel.latitude
        let long = hotel.longitude
        let city = hotel.city
        
        var hotelData = HotelFormPreviosSearchData()
        
        hotelData.cityName = city
        hotelData.destType = "Hotel"
        var splittedStringArray = address.components(separatedBy: ",")
        splittedStringArray.removeFirst()
        let stateName = splittedStringArray.joined(separator: ",")
        hotelData.stateName = stateName
        
        if isHotelFound {
            hotelData.lat = lat
            hotelData.lng = long
            hotelData.destName = hotelName
            hotelData.destId = hotel.dest_id
        } else {
            hotelData.destName = city
            var destId = hotel.dest_id
            if destId.suffix(3) == ":gn" {
                destId.removeLast(3)
            }
            hotelData.destId = destId
        }
        
        hotelData.checkInDate = Date().toString(dateFormat: "yyyy-MM-dd")
        hotelData.checkOutDate = Date().add(years: 0, months: 0, days: 1, hours: 0, minutes: 0, seconds: 0)?.toString(dateFormat: "yyyy-MM-dd") ?? ""

        hotelData.roomNumber     =  1
        hotelData.adultsCount    = [2]

        HotelsSearchVM.hotelFormData = hotelData
    }
}

