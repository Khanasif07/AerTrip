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
        
        self.delegate?.willUpdateFavourite()
        APICaller.shared.callUpdateFavouriteAPI(params: param) { (isSuccess, errors, successMessage) in
            if isSuccess {
                if let index = self.hotels.firstIndex(where: { (hotel) -> Bool in
                    hotel.hotelId == forHotel.hotelId
                }) {
                    var updated = forHotel
                    updated.isFavourite = !updated.isFavourite
                    self.forCity?.holetList[index] = updated
                    self.delegate?.updateFavouriteSuccess(atIndex: index, withMessage: successMessage)
                }
            }
            else {
                self.delegate?.updateFavouriteFail()
            }
        }
    }
    
    //MARK:- Action
}
