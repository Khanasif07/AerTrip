//
//  HotelsResultVM.swift
//  AERTRIP
//
//  Created by Admin on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import CoreData

protocol HotelResultDelegate: class {
    func getAllHotelsListResultSuccess(_ isDone: Bool)
    func getAllHotelsListResultFail(errors: ErrorCodes)
    func willUpdateFavourite()
    func updateFavouriteSuccess(isHotelFavourite: Bool)
    func updateFavouriteFail(errors:ErrorCodes, isHotelFavourite: Bool)
    func willGetPinnedTemplate()
    func getPinnedTemplateSuccess()
    func getPinnedTemplateFail()
    func getAllHotelsOnResultFallbackSuccess(_ isDone: Bool)
    func getAllHotelsOnResultFallbackFail(errors: ErrorCodes)
    func willGetAllHotel()
    func getAllHotelsOnPreferenceSuccess()
    func getAllHotelsOnPreferenceFail()
    
    func callShareTextSuccess()
    func callShareTextfail(errors:ErrorCodes)
}

class HotelsResultVM: NSObject {
    var sid: String = ""
    internal var hotelListResult = [HotelsSearched]()
    var hotelSearchRequest: HotelSearchRequestModel?
    var searchedFormData: HotelFormPreviosSearchData = HotelFormPreviosSearchData()
    var isUnpinHotelTapped : Bool = false
    var shortUrl: String = ""
    var shareText: String = ""
    private(set) var collectionViewList: [String: Any] = [String: Any]()
    private(set) var collectionViewLocArr: [String] = []
    
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
        self.delegate?.willGetAllHotel()
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
    func fetchHotelsDataForCollectionView(fromController: NSFetchedResultsController<HotelSearched>) {
        self.collectionViewList.removeAll()
        self.collectionViewLocArr.removeAll()
        if let allHotels = fromController.fetchedObjects {
            for hs in allHotels {
                if let lat = hs.lat, let long = hs.long {
                    if var allHotles = self.collectionViewList["\(lat),\(long)"] as? [HotelSearched] {
                        allHotles.append(hs)
                        self.collectionViewList["\(lat),\(long)"] = allHotles
                    } else {
                        self.collectionViewLocArr.append("\(lat),\(long)")
                        self.collectionViewList["\(lat),\(long)"] = [hs]
                    }
                }
            }
        }
    }
    
    func deleteHotelsDataForCollectionView(hotel: HotelSearched) {
        if let lat = hotel.lat, let long = hotel.long {
            if var allHotles = self.collectionViewList["\(lat),\(long)"] as? [HotelSearched] {
                allHotles.remove(object: hotel)
                if allHotles.isEmpty {
                    self.collectionViewLocArr.remove(object: "\(lat),\(long)")
                    self.collectionViewList.removeValue(forKey: "\(lat),\(long)")
                } else {
                    self.collectionViewList["\(lat),\(long)"] = allHotles
                }
            }
        }
    }
    
    
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
        var isHotelFavourite = false
        //make fav/unfav locally
        for hotel in forHotels {
            if !isUnpinHotels {
                if hotel.fav == "1" {
                    hotel.fav = "0"
                    isHotelFavourite = false
                } else {
                    hotel.fav = "1"
                    isHotelFavourite = true
                }
                // hotel.fav = hotel.fav == "1" ? "0" : "1"
                
            } else {
                hotel.fav = "0"
                isHotelFavourite = false
            }
            _ = hotel.afterUpdate
        }
        
        self.delegate?.willUpdateFavourite()
        APICaller.shared.callUpdateFavouriteAPI(params: param) { isSuccess,errors, successMessage in
            if isSuccess {
                if isUnpinHotels {
                    AppToast.default.showToastMessage(message: successMessage)
                }
                self.delegate?.updateFavouriteSuccess(isHotelFavourite: isHotelFavourite)
            } else {
                
                if let _ = UserInfo.loggedInUserId {
                    //revert back in API not success fav/unfav locally
                    for hotel in forHotels {
                        if !isUnpinHotels {
                            if hotel.fav == "1" {
                                hotel.fav = "0"
                                isHotelFavourite = false
                            } else {
                                hotel.fav = "1"
                                isHotelFavourite = true
                            }
                            //hotel.fav = hotel.fav == "1" ? "0" : "1"
                        } else {
                            hotel.fav = "1"
                            isHotelFavourite = true
                        }
                        _ = hotel.afterUpdate
                    }
                }
                else {
                    if isUnpinHotels {
                        self.isUnpinHotelTapped = false
                        UserInfo.locallyFavHotels.removeAll()
                    }
                    else {
                        //if user is not logged in save them locally
                        for hotel in forHotels {
                            if let id = hotel.hid, !id.isEmpty {
                                if let idx = UserInfo.locallyFavHotels.firstIndex(of: id) {
                                    UserInfo.locallyFavHotels.remove(at: idx)
                                }
                                else {
                                    UserInfo.locallyFavHotels.append(id)
                                }
                            }
                        }
                    }
                    
                    //save fav/unfav locally
                    for hotel in forHotels {
                        if !isUnpinHotels {
                            if hotel.fav == "1" {
                                hotel.fav = "0"
                                isHotelFavourite = false
                            } else {
                                hotel.fav = "1"
                                isHotelFavourite = true
                            }
                            //hotel.fav = hotel.fav == "1" ? "0" : "1"
                        } else {
                            hotel.fav = "0"
                            isHotelFavourite = false
                        }
                        _ = hotel.afterUpdate
                    }
                }
                self.delegate?.updateFavouriteFail(errors: errors, isHotelFavourite: isHotelFavourite)
            }
        }
    }
    
    func getPinnedTemplate(hotels: [HotelSearched],completionBlock: @escaping(_ success: Bool)->Void ) {
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
                completionBlock(true)
            } else {
                self.delegate?.getPinnedTemplateFail()
                completionBlock(false)
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
    
    
    //
    
    func getShareText() {
        
        // create params 
        var params = JSONDictionary()
        if self.searchedFormData.ratingCount.isEmpty || self.searchedFormData.ratingCount.count == 5 {
            self.searchedFormData.ratingCount = [1,2,3,4,5]
        }
        for (idx, _) in  self.searchedFormData.ratingCount.enumerated() {
            params["filter[star][\(idx+1)star]"] = true
        }
        let _adultsCount = self.searchedFormData.adultsCount
        let _chidrenAge = self.searchedFormData.childrenAge
        params["p"] = "hotels"
        params["dest_id"] = self.hotelSearchRequest?.requestParameters.destinationId
        params["check_in"] = self.hotelSearchRequest?.requestParameters.checkIn
        params["check_out"] = self.hotelSearchRequest?.requestParameters.checkOut
        params["dest_type"] = self.hotelSearchRequest?.requestParameters.destType
        params["dest_name"]  = self.hotelSearchRequest?.requestParameters.destName
        params["lat"] = self.hotelSearchRequest?.requestParameters.latitude
        params["long"] = self.hotelSearchRequest?.requestParameters.longitude
        params["checkout"] = self.hotelSearchRequest?.requestParameters.checkOut
        
        // get number of adult count
        
        for (idx ,  data) in _adultsCount.enumerated() {
            params["r[\(idx)][a]"] = data
        }
        
        // get number of children
        for (idx , dataX) in _chidrenAge.enumerated() {
            for (idy , dataY) in dataX.enumerated() {
                if dataY != 0 {
                    params["r[\(idx)][c][\(idy)]"] = dataY
                }
            }
        }
        
        // Get share text Api
        
        APICaller.shared.callShareTextAPI(params: params) { [weak self ] (success, error, message,shareText) in
            if success {
                self?.shareText = shareText
                self?.delegate?.callShareTextSuccess()
            } else {
                self?.delegate?.callShareTextfail(errors: error)
            }
        }
    }
    
}


extension HotelsResultVM {
    
    ///Params For Api
    func paramsForApi() -> JSONDictionary {
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
    
    ///Hotel List Api
    func hotelListOnPreferencesApi() {
        APICaller.shared.getHotelsListOnPreference(params: self.paramsForApi() ) { [weak self] (success, errors, sid, vCodes,searhRequest) in
            guard let sSelf = self else { return }
            if success {
                sSelf.hotelSearchRequest = searhRequest
                sSelf.delegate?.getAllHotelsOnPreferenceSuccess()
            } else {
                printDebug(errors)
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
                sSelf.delegate?.getAllHotelsOnPreferenceFail()
            }
        }
    }
    
}
