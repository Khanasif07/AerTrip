//
//  FavouriteHotelsListVM.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol FavouriteHotelsListVMDelegate: class {
    func willUpdateFavourite()
    func updateFavouriteSuccess(atIndex: Int, withMessage: String)
    func updateFavouriteFail()
}

class FavouriteHotelsListVM {
    
    //MARK:- Properties
    //MARK:- Public
    var forCity: CityHotels?
    var hotels: [HotelsModel] {
        return self.forCity?.holetList ?? []
    }
    
    weak var delegate: FavouriteHotelsListVMDelegate?
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Private
    
    //MARK:- Public
    func updateFavourite(forHotel: HotelsModel) {
        let param: JSONDictionary = ["hid[0]": forHotel.hotelId, "status": forHotel.isFavourite ? 0 : 1]
        
        var hIndex = -1
        if let index = self.hotels.firstIndex(where: { (hotel) -> Bool in
            hotel.hotelId == forHotel.hotelId
        }) {
            hIndex = index
            var updated = forHotel
            updated.isFavourite = !updated.isFavourite
            self.forCity?.holetList[hIndex] = updated
            self.delegate?.updateFavouriteSuccess(atIndex: hIndex, withMessage: "")
        }
        
        self.delegate?.willUpdateFavourite()
        APICaller.shared.callUpdateFavouriteAPI(params: param) { (isSuccess, errors, successMessage) in
            if !isSuccess {
                if let _ = UserInfo.loggedInUserId {
                    //revert back in API not success fav/unfav locally
                    if hIndex >= 0, hIndex < (self.forCity?.holetList.count ?? 0)  {
                        var updated = forHotel
                        updated.isFavourite = !updated.isFavourite
                        self.forCity?.holetList[hIndex] = updated
                    }
                }
                else {
                    //if user is not logged in save them locally
                    if !forHotel.hotelId.isEmpty {
                        if let idx = UserInfo.locallyFavHotels.firstIndex(of: forHotel.hotelId) {
                            UserInfo.locallyFavHotels.remove(at: idx)
                        }
                        else {
                            UserInfo.locallyFavHotels.append(forHotel.hotelId)
                        }
                    }
                }
                self.delegate?.updateFavouriteFail()
            }
        }
    }
    
    func goToSearchWithHotel(_ hotel: HotelsModel) {
        let hotelName = hotel.name
        /*let address = booking?.hotelAddress let lat =  booking?.latitude, let long = booking?.longitude,*/
        let city = hotel.city
        let hotelId = hotel.hotelId
        var hotelData = HotelFormPreviosSearchData()
        hotelData.cityName = city
        
        hotelData.destType = "Hotel"
        hotelData.destName = hotelName
        hotelData.destId = "\(hotelId):gn"
        
        hotelData.checkInDate = Date().toString(dateFormat: "yyyy-MM-dd")
        hotelData.checkOutDate = Date().add(years: 0, months: 0, days: 1, hours: 0, minutes: 0, seconds: 0)?.toString(dateFormat: "yyyy-MM-dd") ?? ""
        
        hotelData.roomNumber     =  1
        hotelData.adultsCount    = [2]
        hotelData.isComingFromFavouriteHotels = true
        HotelsSearchVM.isComminFromRecentWhatNext = true
        HotelsSearchVM.hotelFormData = hotelData
        AppFlowManager.default.goToDashboard(toBeSelect: .hotels)
        
        
    }
    
    //MARK:- Action
}
