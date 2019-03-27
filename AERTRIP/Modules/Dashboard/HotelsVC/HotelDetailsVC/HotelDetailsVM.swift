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
    func updateFavouriteFail(errors:ErrorCodes)
    
    func getHotelDistanceAndTimeSuccess()
    func getHotelDistanceAndTimeFail()
    
    func willSaveHotelWithTrip()
    func saveHotelWithTripSuccess(trip: TripModel)
}

class HotelDetailsVM {
    
    enum MapMode: String {
        case walking = "WALKING"
        case driving = "DRIVING"
    }
    
    enum FilterTagType {
        case newTag, roomMealTags, roomOtherTags, roomCancellationTags, initialTags
    }
    
    //Mark:- Variables
    //================
    internal var hotelInfo: HotelSearched?
    internal var hotelData: HotelDetails?
    internal var hotelSearchRequest: HotelSearchRequestModel?
    internal var placeModel: PlaceModel?
    internal weak var delegate: HotelDetailDelegate?
    var permanentTagsForFilteration: [String] = []
    var selectedTags: [String] = []
    var roomMealData: [String] = []
    var roomOtherData: [String] = []
    var roomCancellationData: [String] = []
    var currentlyFilterApplying: FilterTagType = .initialTags
    var ratesData = [Rates]()
    var roomRates = [[RoomsRates : Int]]()
    var tableViewRowCell = [[TableCellType]]()
    var vid: String = ""
    var hid: String = ""
    var currencyPreference: String = ""
    var mode: MapMode = .walking
    var isFooterViewHidden: Bool = false
    var filterAppliedData: UserInfo.HotelFilter = UserInfo.HotelFilter()
    
    ///Computed Property
    private var getHotelInfoParams: JSONDictionary {
        let params: JSONDictionary = [APIKeys.vid.rawValue : (self.hotelInfo?.vid ?? "") , APIKeys.hid.rawValue : (self.hotelInfo?.hid ?? ""), APIKeys.sid.rawValue : self.hotelSearchRequest?.sid ?? ""]
        return params
    }
    
    func filteredData(rates: [Rates] ,roomMealData: [String],roomOtherData: [String],roomCancellationData: [String]) -> [Rates] {
        var filteredRates: [Rates] = []
        if roomMealData.isEmpty && roomOtherData.isEmpty && roomCancellationData.isEmpty {
            return rates
        }
        for currentRate in rates {
            if !roomMealData.isEmpty {
                if let rate = self.filterationOnRoomMealData(currentRate: currentRate) {
                    filteredRates.append(rate)
                }
            } else if !roomOtherData.isEmpty {
                if let rate = self.filterationOnRoomOtherData(currentRate: currentRate) {
                    filteredRates.append(rate)
                }
            }
            else if !roomCancellationData.isEmpty {
                if let rate = self.filterationOnRoomCancellationData(currentRate: currentRate) {
                    filteredRates.append(rate)
                }
            }
        }
        return filteredRates
    }
    
    /* Filteration on the basis of RoomMealData , RoomOtherData && RoomCancellationData if these are not empty.
     If any of them is empty then filteration done on the basis on remianing non empty data
     If all are empty then unfiltered rates will be returned because there is no need to filter the data
     */
    func filterationOnRoomMealData(currentRate: Rates) -> Rates? {
        if let inclusionInfo = currentRate.inclusion_array[APIKeys.boardType.rawValue] as? [String] {
            if inclusionInfo.containsArray(array: roomMealData) {
                if !roomOtherData.isEmpty {
                    if let rate = self.filterationOnRoomOtherData(currentRate: currentRate) {
                        return rate
                    }
                } else if !roomCancellationData.isEmpty {
                    if let rate = self.filterationOnRoomCancellationData(currentRate: currentRate) {
                        return rate
                    }
                } else {
                    return currentRate
                }
            }
        }
        return nil
    }
    
    /* Filteration on the basis of RoomOtherData && RoomCancellationData if these are not empty.
     If any of them is empty then filteration done on the basis on remianing non empty data
     If all are empty then unfiltered rates will be returned because there is no need to filter the data
     */
    func filterationOnRoomOtherData(currentRate: Rates) -> Rates? {
        if let internetInfo = currentRate.inclusion_array[APIKeys.internet.rawValue] as? [String] {
            if internetInfo.containsArray(array: roomOtherData) {
                if !roomCancellationData.isEmpty {
                    if let rate = self.filterationOnRoomCancellationData(currentRate: currentRate) {
                        return rate
                    }
                } else {
                    return currentRate
                }
            }
        }
        return nil
    }
    
    /* Filteration on the basis of RoomCancellationData if this is non empty.
     If it is empty then unfiltered rates will be returned because there is no need to filter the data
     */
    func filterationOnRoomCancellationData(currentRate: Rates) -> Rates? {
        let isRefundableSelected = roomCancellationData.contains(LocalizedString.Refundable.localized)
        let isPartRefundable = roomCancellationData.contains(LocalizedString.PartRefundable.localized)
        let isNonRefundable = roomCancellationData.contains(LocalizedString.NonRefundable.localized)
        if isRefundableSelected && isPartRefundable && isNonRefundable || (!isRefundableSelected && !isPartRefundable && !isNonRefundable) /* remianing cases */ {
            return currentRate
        } else {
            if isRefundableSelected && currentRate.cancellation_penalty!.is_refundable {
                return currentRate
            } else if isPartRefundable {
                for penalty in currentRate.penalty_array! {
                    if !penalty.to.isEmpty && !penalty.from.isEmpty {
                        return currentRate
                    }
                }
            } else if isNonRefundable && !currentRate.cancellation_penalty!.is_refundable {
                return currentRate
            }
        }
        return nil
    }
    
    ///Get Hotel Info Api
    func getHotelInfoApi() {
        /*   let frameworkBundle = Bundle(for: PKCountryPicker.self)
         if let jsonPath = frameworkBundle.path(forResource: "hotelData", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
         do {
         if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any] {
         if let hotel = jsonObjects["data"] as? JSONDictionary, let data = hotel["results"] as? JSONDictionary  {
         self.hotelData = HotelDetails.hotelInfo(response: data)
         self.delegate?.getHotelDetailsSuccess()
         }
         }
         }
         catch {
         printDebug("error")
         //self.hotelData = hotelData
         }
         } */
        
        APICaller.shared.getHotelDetails(params: self.getHotelInfoParams) { [weak self] (success, errors, hotelData, currencyPref) in
            guard let sSelf = self else {return}
            if success {
                if let safeHotelData = hotelData {
                    sSelf.hotelData = safeHotelData
                    sSelf.currencyPreference = currencyPref
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
                    _ = self?.hotelInfo?.afterUpdate
                }
                else {
                    sSelf.delegate?.updateFavouriteFail(errors:errors)
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
    
    func saveHotelWithTrip(toTrip trip: TripModel, forRate: Rates, forRoomRate: RoomsRates) {
        
        var params: JSONDictionary = [APIKeys.timezone.rawValue: "Automatic"]
        params[APIKeys.trip_id.rawValue] = trip.id
        params[APIKeys.hotel_id.rawValue] = self.hotelData?.hid ?? ""
        params[APIKeys.check_in_dt.rawValue] = self.hotelData?.checkin ?? ""
        params[APIKeys.check_out_dt.rawValue] = self.hotelData?.checkout ?? ""
        params[APIKeys.check_in_time.rawValue] = self.hotelData?.checkin_time ?? ""
        params[APIKeys.check_out_time.rawValue] = self.hotelData?.checkout_time ?? ""
        params[APIKeys.total_cost.rawValue] = "\(Int(self.hotelData?.price ?? 0.0))"
        params[APIKeys.per_night_cost.rawValue] = "\(Int(self.hotelData?.per_night_price.toDouble ?? 0.0))"
        params[APIKeys.num_rooms.rawValue] = self.hotelData?.num_rooms ?? 0
        params[APIKeys.num_guests.rawValue] = 3
        params[APIKeys.currency_code.rawValue] = self.currencyPreference
        params["rooms[0][room_type]"] = forRoomRate.name + forRoomRate.desc
        params["rooms[0][room_id]"] = forRoomRate.rid
        params["rooms[0][inclusions]"] = ""
        
        self.delegate?.willSaveHotelWithTrip()
        APICaller.shared.saveHotelWithTripAPI(params: params) { [weak self](success, errors) in
            if success {
                self?.delegate?.saveHotelWithTripSuccess(trip: trip)
            }
        }
    }
}
