//
//  HotelsResultVM.swift
//  AERTRIP
//
//  Created by Admin on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HotelResultDelegate: class {
    func getAllHotelsListResultSuccess(_ isDone: Bool)
    func getAllHotelsListResultFail(errors: ErrorCodes)
    func willUpdateFavourite()
    func updateFavouriteSuccess()
    func updateFavouriteFail(errors:ErrorCodes)
    func willGetPinnedTemplate()
    func getPinnedTemplateSuccess()
    func getPinnedTemplateFail()
    func getAllHotelsOnResultFallbackSuccess(_ isDone: Bool)
    func getAllHotelsOnResultFallbackFail(errors: ErrorCodes)
}

class HotelsResultVM: NSObject {
    var sid: String = ""
    internal var hotelListResult = [HotelsSearched]()
    var hotelSearchRequest: HotelSearchRequestModel?
    var shortUrl: String = ""
    
    weak var delegate: HotelResultDelegate?
    
    var searchedCityLocation: CLLocationCoordinate2D? {
        if let lat = self.hotelSearchRequest?.requestParameters.latitude.toDouble, let long = self.hotelSearchRequest?.requestParameters.longitude.toDouble {
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        return nil
    }
    
    func searchHotel(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(self.callSearchHotel(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc private func callSearchHotel(_ forText: String) {
        printDebug("search text for: \(forText)")
    }
    
    func hotelListOnPreferenceResult() {
        let params: JSONDictionary = [APIKeys.vcodes.rawValue: self.hotelSearchRequest?.vcodes.first ?? "", APIKeys.sid.rawValue: self.hotelSearchRequest?.sid ?? ""]
        printDebug(params)
        APICaller.shared.getHotelsListOnPreferenceResult(params: params) { [weak self] success, errors, hotels, isDone in
            guard let sSelf = self else { return }
            if success {
                sSelf.hotelListResult = hotels
                HotelFilterVM.shared.totalHotelCount = hotels.count
                for hotel in hotels {
                    _ = HotelSearched.insert(dataDict: hotel.jsonDict)
                }
                
                sSelf.delegate?.getAllHotelsListResultSuccess(isDone)
            } else {
                printDebug(errors)
                // AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelSearch)
                sSelf.delegate?.getAllHotelsListResultFail(errors: errors)
            }
        }
    }
    
    // MARK: - Methods
    
    // MARK: - Private
    
    // MARK: - Public
    
    func updateFavourite(forHotels: [HotelSearched], isUnpinHotels: Bool) {
        var param = JSONDictionary()
        for (idx, hotel) in forHotels.enumerated() {
            param["hid[\(idx)]"] = hotel.hid
        }
        if !isUnpinHotels {
            param[APIKeys.status.rawValue] = forHotels.first?.fav == "1" ? 0 : 1
        } else {
            param[APIKeys.status.rawValue] = 0
        }
        
        self.delegate?.willUpdateFavourite()
        APICaller.shared.callUpdateFavouriteAPI(params: param) { isSuccess,errors, successMessage in
            if isSuccess {
                for hotel in forHotels {
                    if !isUnpinHotels {
                        hotel.fav = hotel.fav == "1" ? "0" : "1"
                    } else {
                        hotel.fav = "0"
                    }
                    _ = hotel.afterUpdate
                }
                if isUnpinHotels {  AppToast.default.showToastMessage(message: successMessage) }
                self.delegate?.updateFavouriteSuccess()
            } else {
                self.delegate?.updateFavouriteFail(errors: errors)
            }
        }
    }
    
    func getPinnedTemplate(hotels: [HotelSearched]) {
        var param = JSONDictionary()
        for (idx, hotel) in hotels.enumerated() {
            param["hid[\(idx)]"] = hotel.hid
        }
        param[APIKeys.sid.rawValue] = self.hotelSearchRequest?.sid
        
        self.delegate?.willGetPinnedTemplate()
        APICaller.shared.getPinnedTemplateAPI(params: param) { isSuccess, _, shortTemplateUrl in
            if isSuccess {
                self.delegate?.getPinnedTemplateSuccess()
                self.shortUrl = shortTemplateUrl
            } else {
                self.delegate?.getPinnedTemplateFail()
            }
        }
    }
    
    func hotelListOnResultFallback() {
        let params: JSONDictionary = [APIKeys.vcodes.rawValue: self.hotelSearchRequest?.vcodes.first ?? "", APIKeys.sid.rawValue: self.hotelSearchRequest?.sid ?? ""]
        printDebug(params)
        APICaller.shared.getHotelsOnFallBack(params: params) { [weak self] success, errors, hotels, isDone in
            guard let sSelf = self else { return }
            if success {
                sSelf.hotelListResult = hotels
                for hotel in hotels {
                    _ = HotelSearched.insert(dataDict: hotel.jsonDict)
                }
                sSelf.delegate?.getAllHotelsOnResultFallbackSuccess(isDone)
            } else {
                printDebug(errors)
                sSelf.delegate?.getAllHotelsOnResultFallbackFail(errors: errors)
            }
        }
    }
   
}
