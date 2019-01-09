//
//  HotelsListVM.swift
//  AERTRIP
//
//  Created by Admin on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol HotelsListVMDelegate: class {
    func willUpdateFavourite()
    func updateFavouriteSuccess(withMessage: String)
    func updateFavouriteFail()
}

class HotelsListVM {
    
    //MARK:- Properties
    //MARK:- Public
    var forCity: CityHotels?
    var hotels: [HotelsModel] {
        return self.forCity?.holetList ?? []
    }
    
    weak var delegate: HotelsListVMDelegate?
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
//                    self.hotels[index] = updated
                }
                self.delegate?.updateFavouriteSuccess(withMessage: successMessage)
            }
            else {
                self.delegate?.updateFavouriteFail()
            }
        }
    }
    
    //MARK:- Action
}
