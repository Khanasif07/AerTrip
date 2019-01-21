//
//  HotelSearchVM.swift
//  AERTRIP
//
//  Created by Admin on 03/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelSearchVMDelegate: class {
    func willSearchForHotels()
    func searchHotelsSuccess()
    func searchHotelsFail()
    
    func willUpdateFavourite()
    func updateFavouriteSuccess(withMessage: String)
    func updateFavouriteFail()
}

class HotelSearchVM: NSObject {
    
    weak var delegate: HotelSearchVMDelegate?
    var hotels: [HotelsModel] = []
    
    //MARK:- Hotel Search API
    //MARK:-
    func searchHotel(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(callSearchHotelAPI(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc private func callSearchHotelAPI(_ forText: String) {

        let param: JSONDictionary = ["q":forText]
        
        self.delegate?.willSearchForHotels()
        APICaller.shared.callSearchHotelsAPI(params: param) { (isSuccess, errors, hotels) in
            if isSuccess {
                self.hotels = hotels
                self.delegate?.searchHotelsSuccess()
            }
            else {
                self.delegate?.searchHotelsFail()
            }
        }
    }
    
    //MARK:- Mark Favourite
    //MARK:-
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
                    self.hotels[index] = updated
                }
                self.delegate?.updateFavouriteSuccess(withMessage: successMessage)
            }
            else {
                self.delegate?.updateFavouriteFail()
            }
        }
    }
}
