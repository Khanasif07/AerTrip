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
    private(set) var collectionViewList: [String: Any] = [String: Any]()
    
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
    func fetchHotelsDataForCollectionView(fromController: NSFetchedResultsController<HotelSearched>) {
        self.collectionViewList.removeAll()
        if let allHotels = fromController.fetchedObjects {
            for hs in allHotels {
                if let lat = hs.lat, let long = hs.long {
                    if var allHotles = self.collectionViewList["\(lat)\(long)"] as? [HotelSearched] {
                        allHotles.append(hs)
                        self.collectionViewList["\(lat)\(long)"] = allHotles
                    } else {
                        self.collectionViewList["\(lat)\(long)"] = [hs]
                    }
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
        
        //make fav/unfav locally
        for hotel in forHotels {
            if !isUnpinHotels {
                hotel.fav = hotel.fav == "1" ? "0" : "1"
            } else {
                hotel.fav = "0"
            }
            _ = hotel.afterUpdate
        }
        self.delegate?.willUpdateFavourite()
        APICaller.shared.callUpdateFavouriteAPI(params: param) { isSuccess,errors, successMessage in
            if isSuccess {
                if isUnpinHotels {  AppToast.default.showToastMessage(message: successMessage) }
                self.delegate?.updateFavouriteSuccess()
            } else {
                if let _ = UserInfo.loggedInUserId {
                    //revert back in API not success fav/unfav locally
                    for hotel in forHotels {
                        if !isUnpinHotels {
                            hotel.fav = hotel.fav == "1" ? "0" : "1"
                        } else {
                            hotel.fav = "1"
                        }
                        _ = hotel.afterUpdate
                    }
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
