//
//  HotelDetailsVM.swift
//  AERTRIP
//
//  Created by Admin on 14/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol HotelDetailDelegate: class {
    func getHotelDetailsSuccess()
    func getHotelDetailsFail()
    
    func updateFavouriteSuccess(withMessage: String)
    func updateFavouriteFail()
    
    func getHotelDistanceAndTimeSuccess()
    func getHotelDistanceAndTimeFail()
}

class HotelDetailsVM {
    
    enum MapMode: String {
        case walking = "WALKING"
        case driving = "DRIVING"
    }
    
    //Mark:- Variables
    //================
    internal var hotelInfo: HotelSearched?
    internal var hotelData: HotelDetails?
    internal var hotelSearchRequest: HotelSearchRequestModel?
    internal var placeModel: PlaceModel?
    internal weak var delegate: HotelDetailDelegate?
    var permanentTagsForFilteration: [String] = ["Breakfast"]
    var tagsForFilteration: [String] = ["Breakfast"]
    var selectedTags: [String] = ["Breakfast"]
    var ratesData = [Rates]()
    var roomRates = [[RoomsRates : Int]]()
    var tableViewRowCell = [[TableCellType]]()
    var vid: String = ""
    var sid: String = ""
    var hid: String = ""
    var mode: MapMode = .walking
    var isFooterViewHidden: Bool = false
    
    ///Computed Property
    private var getHotelInfoParams: JSONDictionary {
        let params: JSONDictionary = [APIKeys.vid.rawValue : (self.hotelInfo?.vid ?? "") , APIKeys.hid.rawValue : (self.hotelInfo?.hid ?? ""), APIKeys.sid.rawValue : self.hotelSearchRequest?.sid ?? ""]
        return params
    }
    
    ///Get Filtered Data
    func getFilteredData(rates: [Rates], tagList: [String]) -> [Rates] {
        let filteredRates = rates.filter { (rate: Rates) -> Bool in
            if let inclusionInfo = rate.inclusion_array[APIKeys.boardType.rawValue] as? [String] {
                if inclusionInfo.containsArray(array: tagList) { return true }
                //                for tag in tagList {
                //                    if inclusionInfo.contains(tag) { return true }
                //                }
            }
            return false
        }
        return filteredRates
    }
    
    ///Get Hotel Info Api
    func getHotelInfoApi() {
//        let frameworkBundle = Bundle(for: PKCountryPicker.self)
//        if let jsonPath = frameworkBundle.path(forResource: "hotelData", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
//            do {
//                if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] {
//                    if let hotel = jsonObjects["data"] as? JSONDictionary, let data = hotel["results"] as? JSONDictionary  {
//                        self.hotelData = HotelDetails.hotelInfo(response: data)
//                        self.delegate?.getHotelDetailsSuccess()
//                    }
//                }
//            }
//            catch {
//                printDebug("error")
//                //self.hotelData = hotelData
//            }
//        }
        
                APICaller.shared.getHotelDetails(params: self.getHotelInfoParams) { [weak self] (success, errors, hotelData) in
                    guard let sSelf = self else {return}
                    if success {
                        if let safeHotelData = hotelData {
                            sSelf.hotelData = safeHotelData
                            sSelf.delegate?.getHotelDetailsSuccess()
                        }
                    } else {
                        printDebug(errors)
                        sSelf.isFooterViewHidden = true
                        sSelf.delegate?.getHotelDetailsFail()
                    }
                }
    }
    
    //MARK:- Mark Favourite
    //MARK:-
    func updateFavourite() {
        let param: JSONDictionary = ["hid[0]": hotelInfo?.hid ?? "0", "status": hotelInfo?.fav == "0" ? 1 : 0]
        APICaller.shared.callUpdateFavouriteAPI(params: param) { [weak self] (isSuccess, errors, successMessage) in
            if let sSelf = self {
                if isSuccess {
                    sSelf.hotelInfo?.fav = sSelf.hotelInfo?.fav == "0" ? "1" : "0"
                    sSelf.delegate?.updateFavouriteSuccess(withMessage: successMessage)
                }
                else {
                    sSelf.delegate?.updateFavouriteFail()
                }
            }
        }
    }
    
    func getHotelDistanceAndTimeInfo() {
        if let hotelSearchRequest = self.hotelSearchRequest , let hotelInfo = self.hotelInfo {
            let requestParams = hotelSearchRequest.requestParameters
            APICaller.shared.getHotelDistanceAndTravelTime(originLat: requestParams.latitude, originLong: requestParams.longitude, destinationLat: hotelInfo.lat ?? "", destinationLong: hotelInfo.long ?? "", mode: self.mode.rawValue) { [weak self] (success, placeData) in
                if let sSelf = self {
                    if success {
                        sSelf.placeModel = placeData
                        sSelf.delegate?.getHotelDistanceAndTimeSuccess()
                        printDebug(placeData)
                    } else {
                        sSelf.delegate?.getHotelDistanceAndTimeFail()
                    }
                }
            }
        }
    }
}
