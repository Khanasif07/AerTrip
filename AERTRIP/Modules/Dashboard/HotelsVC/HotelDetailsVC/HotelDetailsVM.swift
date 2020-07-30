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
    func saveHotelWithTripSuccess(trip: TripModel, isAllreadyAdded: Bool)
    
    func willGetPinnedTemplate()
    func getPinnedTemplateSuccess()
    func getPinnedTemplateFail()
    
    func willFetchConfirmItineraryData(index:Int)
    func fetchConfirmItineraryDataResponse(itineraryData: ItineraryData?, index:Int, error:ErrorCodes)
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
    var permanentTagsForFilteration: [String] = []
    var selectedTags: [String] = []
    var roomMealDataCopy: [String] = []
    var roomOtherDataCopy: [String] = []
    var roomCancellationDataCopy: [String] = []
    var ratesData = [Rates]()
    var roomRates = [[RoomsRates : Int]]()
    var hotelDetailsTableSectionData = [[TableCellType]]()
    var currencyPreference: String = ""
    var mode: MapMode = .walking
    var isFooterViewHidden: Bool = false
    var filterAppliedData: UserInfo.HotelFilter = UserInfo.HotelFilter()
    var shareLinkURL = ""
    var confirmationCount = 1
    var isBookLoaderHidden = true
    
    private let defaultCheckInTime = "07:00"
    private let defaultCheckOutTime = "07:00"
    
    ///Computed Property
    private var getHotelInfoParams: JSONDictionary {
        let params: JSONDictionary = [APIKeys.vid.rawValue : (self.hotelInfo?.vid ?? "") , APIKeys.hid.rawValue : (self.hotelInfo?.hid ?? ""), APIKeys.sid.rawValue : self.hotelSearchRequest?.sid ?? ""]
        return params
    }
    
    func syncPermanentTagsWithSelectedFilter() {
        guard let filter = UserInfo.hotelFilter else {
            printDebug("Filter not found")
            HotelFilterVM.shared.resetToDefault()
            return
        }
        let selected = filter.roomMeal + filter.roomCancelation + filter.roomOther
        for element in selected {
            if !self.permanentTagsForFilteration.contains(element) {
                self.permanentTagsForFilteration.append(element)
            }
        }
        self.selectedTags = self.permanentTagsForFilteration
    }
    
    /// Filtered Rates
    func filteredRates(rates: [Rates] ,roomMealData: [String],roomOtherData: [String],roomCancellationData: [String]) -> [Rates] {
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
    
    
    func newFiltersAccordingToTags(rates: [Rates], selectedTag: [String])-> [Rates]{
        var filteredRates: [Rates] = []
        var tempRatesData = rates
        if !selectedTag.isEmpty{
//            for tag in selectedTag{
//                if (tag != selectedTag.first ?? ""){//To Apply AND filter on rates.
//                    tempRatesData = filteredRates
//                    filteredRates = []
//                }
                let filteredArray = tempRatesData.filter{ rates in
                    
                    for tag in selectedTag{
                    let roomRate = rates.roomsRates ?? []
                    if roomRate.map({$0.name.lowercased()}).joined(separator: ",").contains(tag.lowercased()){
                        return true
                    }
                    if roomRate.map({$0.desc.lowercased()}).joined(separator: ",").contains(tag.lowercased()){
                        return true
                    }
                        if (rates.inclusion_array[APIKeys.boardType.rawValue] as? [String] ?? []).joined(separator: ",").lowercased().contains(tag.lowercased()){
                        return true
                    }
                    if (rates.inclusion_array[APIKeys.other_inclusions.rawValue] as? [String] ?? []).joined(separator: ",").lowercased().contains(tag.lowercased()){
                        return true
                    }
                    if (rates.inclusion_array[APIKeys.inclusions.rawValue] as? [String] ?? []).joined(separator: ",").lowercased().contains(tag.lowercased()){
                        return true
                    }
                    if (rates.inclusion_array[APIKeys.notes_inclusion.rawValue] as? [String] ?? []).joined(separator: ",").lowercased().contains(tag.lowercased()){
                        return true
                    }
                    if (rates.cancellation_penalty?.is_refundable ?? false){
                        
                        if let firstRefundableData = rates.penalty_array?.first {
                            let roomPrice: Double = rates.price
                            let toDate: String = firstRefundableData.to
                            let fromDate: String = firstRefundableData.from
                            let penalty: Int = firstRefundableData.penalty
                            
                            if !toDate.isEmpty && fromDate.isEmpty && penalty == 0 {
                                // free cancelation
                                if  (tag.lowercased() == "free cancellation") || (tag.lowercased() == "free") {
                                    return true
                                }
                            }
                            if !toDate.isEmpty && !fromDate.isEmpty && penalty != 0 {
                                // Part Refundable
                                if (tag.lowercased() == "part refundable") {
                                    return true
                                }
                            }
                            if toDate.isEmpty && !fromDate.isEmpty && penalty != 0 {
                                // Part Refundable
                                if  (tag.lowercased() == "part refundable") {
                                    return true
                                }
                            }
                        }
                        //return false
                    }
                    if ((rates.cancellation_penalty?.is_refundable  ?? false) == false && ((tag.lowercased() == "non-refundable") || (tag.lowercased() == "non refundable"))){
                        return true
                    }
                    }
                    return false
                }
                for rt in filteredArray{
                    if !filteredRates.contains(array: [rt]){
                        filteredRates.append(rt)
                    }
                }
//            }
            return filteredRates
        }else{
            return rates
        }
    }
    
    
    /* Filteration on the basis of RoomMealData , RoomOtherData && RoomCancellationData if these are not empty.
     If any of them is empty then filteration done on the basis on remianing non empty data
     If all are empty then unfiltered rates will be returned because there is no need to filter the data
     */
    func filterationOnRoomMealData(currentRate: Rates) -> Rates? {
        if let inclusionInfo = currentRate.inclusion_array[APIKeys.boardType.rawValue] as? [String] {
            if inclusionInfo.containsArray(array: roomMealDataCopy) {
                if !roomOtherDataCopy.isEmpty {
                    if let rate = self.filterationOnRoomOtherData(currentRate: currentRate) {
                        return rate
                    }
                } else if !roomCancellationDataCopy.isEmpty {
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
            if internetInfo.containsArray(array: roomOtherDataCopy) {
                if !roomCancellationDataCopy.isEmpty {
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
        let isRefundableSelected = roomCancellationDataCopy.contains(LocalizedString.Refundable.localized)
        let isPartRefundable = roomCancellationDataCopy.contains(LocalizedString.PartRefundable.localized)
        let isNonRefundable = roomCancellationDataCopy.contains(LocalizedString.NonRefundable.localized)
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
        
        //save locally and update ui
        self.hotelInfo?.fav = self.hotelInfo?.fav == "0" ? "1" : "0"
        _ = self.hotelInfo?.afterUpdate
        self.delegate?.updateFavouriteSuccess(withMessage: "")
        
        APICaller.shared.callUpdateFavouriteAPI(params: param) { [weak self] (isSuccess, errors, successMessage) in
            if let sSelf = self {
                if isSuccess {
                    sSelf.delegate?.updateFavouriteSuccess(withMessage: successMessage)
                }
                else {
                    if let _ = UserInfo.loggedInUserId {
                        //revert back in API not success fav/unfav locally
                        sSelf.hotelInfo?.fav = sSelf.hotelInfo?.fav == "0" ? "1" : "0"
                        _ = sSelf.hotelInfo?.afterUpdate
                    }
                    else {
                        //if user is not logged in save them locally
                        if let id = sSelf.hotelInfo?.hid, !id.isEmpty {
                            if let idx = UserInfo.locallyFavHotels.firstIndex(of: id) {
                                UserInfo.locallyFavHotels.remove(at: idx)
                            }
                            else {
                                UserInfo.locallyFavHotels.append(id)
                            }
                        }
                        
                        //save fav/unfav locally
                        sSelf.hotelInfo?.fav = sSelf.hotelInfo?.fav == "0" ? "1" : "0"
                        _ = sSelf.hotelInfo?.afterUpdate
                    }
                    
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
                        printDebug(placeData)
                        sSelf.delegate?.getHotelDistanceAndTimeSuccess()
                        
                    } else {
                        sSelf.delegate?.getHotelDistanceAndTimeFail()
                    }
                }
            }
        }
    }
    
    func saveHotelWithTrip(toTrip trip: TripModel, forRate: Rates, forRoomRate: RoomsRates) {
        
        /*hotel_id: 145242
         check_in: 2019-04-17 20:19
         check_out: 2019-04-18 20:19
         check_in_dt: 2019-04-17
         check_in_time: 20:19
         check_out_dt: 2019-04-18
         check_out_time: 20:19
         timezone: Automatic
         total_cost: 6517
         per_night_cost: 0
         num_rooms: 3
         num_guests: 12
         currency_code: INR
         rooms[0][room_type]: Deluxe Room
         rooms[0][room_id]: 0
         rooms[0][inclusions]:
         trip_id: 535*/
        
        var params: JSONDictionary = [APIKeys.timezone.rawValue: "Automatic"]
        params[APIKeys.trip_id.rawValue] = trip.id
        params[APIKeys.hotel_id.rawValue] = self.hotelData?.hid ?? ""
        params[APIKeys.check_in_dt.rawValue] = self.hotelData?.checkin ?? ""
        params[APIKeys.check_out_dt.rawValue] = self.hotelData?.checkout ?? ""
        
        if let time = self.hotelData?.checkin_time, !time.isEmpty {
            params[APIKeys.check_in_time.rawValue] = time
            params[APIKeys.check_in.rawValue] = "\(self.hotelData?.checkin ?? "") \(time)"
        }
        else {
            params[APIKeys.check_in_time.rawValue] = defaultCheckInTime
            params[APIKeys.check_in.rawValue] = "\(self.hotelData?.checkin ?? "") \(defaultCheckInTime)"
        }
        
        if let time = self.hotelData?.checkout_time, !time.isEmpty {
            params[APIKeys.check_out_time.rawValue] = time
            params[APIKeys.check_out.rawValue] = "\(self.hotelData?.checkout ?? "") \(time)"
        }
        else {
            params[APIKeys.check_out_time.rawValue] = defaultCheckOutTime
            params[APIKeys.check_out.rawValue] = "\(self.hotelData?.checkout ?? "") \(defaultCheckOutTime)"
        }
        
        params[APIKeys.total_cost.rawValue] = "\(Int(self.hotelData?.price ?? 0.0))"
        params[APIKeys.per_night_cost.rawValue] = "\(Int(self.hotelData?.per_night_list_price.toDouble ?? 0.0))"
        params[APIKeys.num_rooms.rawValue] = self.hotelData?.num_rooms ?? 0
        params[APIKeys.num_guests.rawValue] = self.hotelData?.totalOccupant ?? 0
        params[APIKeys.currency_code.rawValue] = self.currencyPreference
        params["rooms[0][room_type]"] = forRoomRate.name + forRoomRate.desc
        params["rooms[0][room_id]"] = 0
        params["rooms[0][inclusions]"] = ""
        
        self.delegate?.willSaveHotelWithTrip()
        APICaller.shared.saveHotelWithTripAPI(params: params) { [weak self](success, errors, isAlreadyAdded) in
            if success {
                self?.delegate?.saveHotelWithTripSuccess(trip: trip, isAllreadyAdded: isAlreadyAdded)
            }
        }
    }
    
    func getShareLinkAPI(completionBlock: @escaping(_ success: Bool)->Void ) {
        var param = JSONDictionary()
        param["hid[]"] = self.hotelInfo?.hid ?? ""
        param[APIKeys.sid.rawValue] = self.hotelSearchRequest?.sid
        param["u"] = ""
        
        self.delegate?.willGetPinnedTemplate()
        APICaller.shared.getShareLinkAPI(params: param) { [weak self] isSuccess, _, shareLinkUrl in
            if isSuccess {
                self?.shareLinkURL = shareLinkUrl
                self?.delegate?.getPinnedTemplateSuccess()
                completionBlock(true)
            } else {
                self?.delegate?.getPinnedTemplateFail()
                completionBlock(false)
            }
        }
    }
    
    ///Hotel confirmation Api
    func fetchConfirmItineraryData(at index:Int) {
        let params: JSONDictionary = [APIKeys.sid.rawValue: self.hotelSearchRequest?.sid ?? "", APIKeys.hid.rawValue: self.hotelInfo?.hid ?? "", "data[0][qid]": self.ratesData[index].qid, "p": "hotels"]
        delegate?.willFetchConfirmItineraryData(index: index)
        APICaller.shared.fetchConfirmItineraryData(params: params) { [weak self] success, errors, itData in
            guard let self = self else { return }
            self.delegate?.fetchConfirmItineraryDataResponse(itineraryData: itData, index: index, error: errors)
        }
    }
}

