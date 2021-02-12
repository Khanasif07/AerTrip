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
    
    func reloadHotelList(isUpdatingFav: Bool)
    func manageSwitchContainer(isHidden: Bool, shouldOff: Bool)
    func getHotelsCount()
    func deleteRow(index: IndexPath)
    func updateFavOnList()
    func updateFavouriteAndFilterView()
    
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
    
    weak var hotelResultDelegate: HotelResultDelegate?
    weak var hotelMapDelegate: HotelResultDelegate?

    var searchedCityLocation: CLLocationCoordinate2D? {
        if let lat = self.hotelSearchRequest?.requestParameters.latitude.toDouble, let long = self.hotelSearchRequest?.requestParameters.longitude.toDouble {
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        return nil
    }
    
    var isResetAnnotation = false
    var fetchRequest: NSFetchRequest<HotelSearched> = HotelSearched.fetchRequest()
    
    // fetch result controller
    lazy var fetchedResultsController: NSFetchedResultsController<HotelSearched> = {
        
        self.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "bc", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        //        do {
        //            try fetchedResultsController.performFetch()
        //        } catch {
        //            printDebug("Error in performFetch: \(error) at line \(#line) in file \(#file)")
        //        }
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    // Request and View Type
    var isLoadingListAfterUpdatingAllFav: Bool = false
    var fetchRequestType: FetchRequestType = .normal
    var favouriteHotels: [HotelSearched] = []
    var searchedHotels: [HotelSearched] = []
    var andPredicate : NSCompoundPredicate?
    var searchTextStr: String = ""
    var filterApplied: UserInfo.HotelFilter = UserInfo.HotelFilter()
    var isFilterApplied: Bool = false
    var isFavouriteOn: Bool = false
    var tempHotelFilter: UserInfo.HotelFilter? = nil
    
    var recentSearchModel: RecentSearchesModel?
    
    func getConvertedRecentSearchFilter() -> UserInfo.HotelFilter? {
        guard let recentSearchFilter = recentSearchModel?.filter else { return nil }
        let recentFilter = UserInfo.HotelFilter(recentSearchFilter: recentSearchFilter)
        return recentFilter
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
        self.hotelResultDelegate?.willGetAllHotel()
        self.hotelMapDelegate?.willGetAllHotel()
        APICaller.shared.getHotelsListOnPreferenceResult(params: params) { [weak self] success, errors, hotels, isDone in
            guard let sSelf = self else { return }
            if success {
                sSelf.hotelListResult = hotels
                HotelFilterVM.shared.totalHotelCount = hotels.count
                for hotel in hotels {
                    _ = HotelSearched.insert(dataDict: hotel.jsonDict)
                }
                let result = CoreDataManager.shared.fetchData("HotelSearched", nsPredicate: NSPredicate(format: "filterStar CONTAINS[c] '\(0)'")) ?? []
                printDebug("hotels count with zero rating \(result.count)")
                HotelFilterVM.shared.showIncludeUnrated = !result.isEmpty
                
                let tAUnrated = CoreDataManager.shared.fetchData("HotelSearched", nsPredicate: NSPredicate(format: "filterTripAdvisorRating CONTAINS[c] '\(0)'")) ?? []
                HotelFilterVM.shared.showIncludeTAUnrated = !tAUnrated.isEmpty
                
                HotelFilterVM.shared.availableAmenities.removeAll()
                for amentity in 1...10 {
                    let result = CoreDataManager.shared.fetchData("HotelSearched", nsPredicate: NSPredicate(format: "amenities CONTAINS[c] ',\(amentity),'")) ?? []
                    printDebug("amentity \("\(amentity)") count with  \(result.count)")
                    if !result.isEmpty {
                        HotelFilterVM.shared.availableAmenities.append("\(amentity)")
                    }
                }
                printDebug("HotelFilterVM.shared.availableAmenities : \(HotelFilterVM.shared.availableAmenities)")
                sSelf.hotelResultDelegate?.getAllHotelsListResultSuccess(isDone)
                sSelf.hotelMapDelegate?.getAllHotelsListResultSuccess(isDone)
            } else {
                printDebug(errors)
                // AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelSearch)
                sSelf.hotelResultDelegate?.getAllHotelsListResultFail(errors: errors)
                sSelf.hotelMapDelegate?.getAllHotelsListResultFail(errors: errors)
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
                        UIImageView.downloadImage(url: hs.thumbnail?.first ?? "")
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
        
        self.hotelResultDelegate?.willUpdateFavourite()
        self.hotelMapDelegate?.willUpdateFavourite()

        APICaller.shared.callUpdateFavouriteAPI(params: param) { isSuccess,errors, successMessage in
            if isSuccess {
                if isUnpinHotels {
                    AppToast.default.showToastMessage(message: successMessage)
                }
                self.hotelMapDelegate?.updateFavouriteSuccess(isHotelFavourite: isHotelFavourite)
                self.hotelResultDelegate?.updateFavouriteSuccess(isHotelFavourite: isHotelFavourite)

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
                self.hotelMapDelegate?.updateFavouriteFail(errors: errors, isHotelFavourite: isHotelFavourite)
                self.hotelResultDelegate?.updateFavouriteFail(errors: errors, isHotelFavourite: isHotelFavourite)
            }
        }
    }
    
    /*
    func getPinnedTemplate(hotels: [HotelSearched],completionBlock: @escaping(_ success: Bool)->Void ) {
        var param = JSONDictionary()
        for (idx, hotel) in hotels.enumerated() {
            param["hid[\(idx)]"] = hotel.hid
        }
        param[APIKeys.sid.rawValue] = self.hotelSearchRequest?.sid
        
        self.hotelResultDelegate?.willGetPinnedTemplate()
        self.hotelMapDelegate?.willGetPinnedTemplate()
        APICaller.shared.getPinnedTemplateAPI(params: param) { isSuccess, _, shortTemplateUrl in
            if isSuccess {
                self.hotelResultDelegate?.getPinnedTemplateSuccess()
                self.hotelMapDelegate?.getPinnedTemplateSuccess()

                self.shortUrl = shortTemplateUrl
                completionBlock(true)
            } else {
                self.hotelResultDelegate?.getPinnedTemplateFail()
                self.hotelMapDelegate?.getPinnedTemplateFail()
                completionBlock(false)
            }
        }
    }
    */
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
                sSelf.hotelResultDelegate?.getAllHotelsOnResultFallbackSuccess(isDone)
                sSelf.hotelMapDelegate?.getAllHotelsOnResultFallbackSuccess(isDone)
            } else {
                printDebug(errors)
                sSelf.hotelResultDelegate?.getAllHotelsOnResultFallbackFail(errors: errors)
                sSelf.hotelMapDelegate?.getAllHotelsOnResultFallbackFail(errors: errors)
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
//        for (idx, _) in  self.searchedFormData.ratingCount.enumerated() {
//            params["filter[star][\(idx+1)star]"] = true
//        }
        let filter = getFilterParams()
        if !filter.keys.isEmpty {
            params["filter"] = AppGlobals.shared.json(from: filter)
        }
        let _adultsCount = self.searchedFormData.adultsCount
        params["p"] = "hotels"
        params["dest_id"] = self.hotelSearchRequest?.requestParameters.destinationId
        params["check_in"] = self.hotelSearchRequest?.requestParameters.checkIn
        params["check_out"] = self.hotelSearchRequest?.requestParameters.checkOut
        params["dest_type"] = self.hotelSearchRequest?.requestParameters.destType
        params["dest_name"]  = self.hotelSearchRequest?.requestParameters.destName
        params["lat"] = self.hotelSearchRequest?.requestParameters.latitude
        params["lng"] = self.hotelSearchRequest?.requestParameters.longitude
//        params["checkout"] = self.hotelSearchRequest?.requestParameters.checkOut
            
        
        // get number of adult count
        
        for (idx ,  data) in _adultsCount.enumerated() {
            params["r[\(idx)][a]"] = data
        }
        
        // get number of children
        for (room, children) in searchedFormData.childrenCounts.enumerated() {
            if children < 1 { continue }
            let roomChildrenAges = searchedFormData.childrenAge[room]
            for index in 0..<children {
                params["r[\(room)][c][\(index)]"] = roomChildrenAges[index]
            }
        }
        
        // Replaced previously written logic with the one above
//        for (idx , dataX) in _chidrenAge.enumerated() {
//            for (idy , dataY) in dataX.enumerated() {
//                if dataY != 0 {
//                    params["r[\(idx)][c][\(idy)]"] = dataY
//                }
//            }
//        }
        
        // Get share text Api
        
        APICaller.shared.callShareTextAPI(params: params) { [weak self ] (success, error, message,shareText) in
            if success {
                self?.shareText = shareText
                self?.hotelResultDelegate?.callShareTextSuccess()
                self?.hotelMapDelegate?.callShareTextSuccess()
            } else {
                self?.hotelResultDelegate?.callShareTextfail(errors: error)
                self?.hotelMapDelegate?.callShareTextfail(errors: error)
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
        let _chidrenCount = self.searchedFormData.childrenCounts
        params[APIKeys.check_in.rawValue] = self.searchedFormData.checkInDate
        params[APIKeys.check_out.rawValue] = self.searchedFormData.checkOutDate
        params[APIKeys.dest_id.rawValue] = self.searchedFormData.destId
        params[APIKeys.dest_type.rawValue] = self.searchedFormData.destType
        params[APIKeys.dest_name.rawValue] = self.searchedFormData.destName
        params[APIKeys.isPageRefereshed.rawValue] = true
        
        params[APIKeys.latitude.rawValue] = self.searchedFormData.lat
        params[APIKeys.longitude.rawValue] = self.searchedFormData.lng
        params[APIKeys.search_nearby.rawValue] = self.searchedFormData.isHotelNearMeSelected

        
        for (_ , data ) in _starRating.enumerated() {
            //            params["filter[star][\(idx)star]"] = true
            params["filter[star][\(data)star]"] = true
            
        }
        
        for (idx ,  data) in _adultsCount.enumerated() {
            params["r[\(idx)][a]"] = data
        }
        
        printDebug(_chidrenCount)

        for (idx , dataX) in _chidrenAge.enumerated() {
            let numberOfChildInRoom  = _chidrenCount[idx]
            for (idy , dataY) in dataX.enumerated() {
                
                if idy < numberOfChildInRoom {
                
//                if dataY != 0 {
                    params["r[\(idx)][c][\(idy)]"] = dataY
//                }
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
                sSelf.hotelResultDelegate?.getAllHotelsOnPreferenceSuccess()
                sSelf.hotelMapDelegate?.getAllHotelsOnPreferenceSuccess()
            } else {
                printDebug(errors)
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .hotelsSearch)
                sSelf.hotelResultDelegate?.getAllHotelsOnPreferenceFail()
                sSelf.hotelMapDelegate?.getAllHotelsOnPreferenceFail()
            }
        }
    }
    
}
