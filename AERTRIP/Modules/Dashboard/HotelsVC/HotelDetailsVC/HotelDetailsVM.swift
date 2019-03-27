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
        for currentRate in rates {
            if !roomMealData.isEmpty {
                if let inclusionInfo = currentRate.inclusion_array[APIKeys.boardType.rawValue] as? [String] {
                    if inclusionInfo.containsArray(array: roomMealData) {
                        if !roomOtherData.isEmpty {
                            if let internetInfo = currentRate.inclusion_array[APIKeys.internet.rawValue] as? [String] {
                                if internetInfo.containsArray(array: roomOtherData) {
                                    if !roomCancellationData.isEmpty {
                                        let isRefundableSelected = roomCancellationData.contains(LocalizedString.Refundable.localized)
                                        let isPartRefundable = roomCancellationData.contains(LocalizedString.PartRefundable.localized)
                                        let isNonRefundable = roomCancellationData.contains(LocalizedString.NonRefundable.localized)
                                        if isRefundableSelected && isPartRefundable && isNonRefundable || (!isRefundableSelected && !isPartRefundable && !isNonRefundable) /* remianing cases */ {
                                            filteredRates.append(currentRate)
                                        } else {
                                            if isRefundableSelected && currentRate.cancellation_penalty!.is_refundable {
                                                filteredRates.append(currentRate)
                                            } else if isPartRefundable {
                                                for penalty in currentRate.penalty_array! {
                                                    if !penalty.to.isEmpty && !penalty.from.isEmpty {
                                                        filteredRates.append(currentRate)
                                                    }
                                                }
                                            } else if isNonRefundable && !currentRate.cancellation_penalty!.is_refundable {
                                                filteredRates.append(currentRate)
                                            }
                                        }
                                    } else {
                                        filteredRates.append(currentRate)
                                    }
                                }
                            }
                        } else if !roomCancellationData.isEmpty {
                            let isRefundableSelected = roomCancellationData.contains(LocalizedString.Refundable.localized)
                            let isPartRefundable = roomCancellationData.contains(LocalizedString.PartRefundable.localized)
                            let isNonRefundable = roomCancellationData.contains(LocalizedString.NonRefundable.localized)
                            if isRefundableSelected && isPartRefundable && isNonRefundable || (!isRefundableSelected && !isPartRefundable && !isNonRefundable) /* remianing cases */ {
                                filteredRates.append(currentRate)
                            } else {
                                if isRefundableSelected && currentRate.cancellation_penalty!.is_refundable {
                                    filteredRates.append(currentRate)
                                } else if isPartRefundable {
                                    for penalty in currentRate.penalty_array! {
                                        if !penalty.to.isEmpty && !penalty.from.isEmpty {
                                            filteredRates.append(currentRate)
                                        }
                                    }
                                } else if isNonRefundable && !currentRate.cancellation_penalty!.is_refundable {
                                    filteredRates.append(currentRate)
                                }
                            }
                        } else {
                            filteredRates.append(currentRate)
                        }
                    }
                }
            } else if !roomOtherData.isEmpty {
                if let internetInfo = currentRate.inclusion_array[APIKeys.internet.rawValue] as? [String] {
                    if internetInfo.containsArray(array: roomOtherData) {
                        if !roomCancellationData.isEmpty {
                            let isRefundableSelected = roomCancellationData.contains(LocalizedString.Refundable.localized)
                            let isPartRefundable = roomCancellationData.contains(LocalizedString.PartRefundable.localized)
                            let isNonRefundable = roomCancellationData.contains(LocalizedString.NonRefundable.localized)
                            if isRefundableSelected && isPartRefundable && isNonRefundable || (!isRefundableSelected && !isPartRefundable && !isNonRefundable) /* remianing cases */ {
                                filteredRates.append(currentRate)
                            } else {
                                if isRefundableSelected && currentRate.cancellation_penalty!.is_refundable {
                                    filteredRates.append(currentRate)
                                } else if isPartRefundable {
                                    for penalty in currentRate.penalty_array! {
                                        if !penalty.to.isEmpty && !penalty.from.isEmpty {
                                            filteredRates.append(currentRate)
                                        }
                                    }
                                } else if isNonRefundable && !currentRate.cancellation_penalty!.is_refundable {
                                    filteredRates.append(currentRate)
                                }
                            }
                        } else {
                            filteredRates.append(currentRate)
                        }
                    }
                }
            }
            else if !roomCancellationData.isEmpty {
                let isRefundableSelected = roomCancellationData.contains(LocalizedString.Refundable.localized)
                let isPartRefundable = roomCancellationData.contains(LocalizedString.PartRefundable.localized)
                let isNonRefundable = roomCancellationData.contains(LocalizedString.NonRefundable.localized)
                if isRefundableSelected && isPartRefundable && isNonRefundable || (!isRefundableSelected && !isPartRefundable && !isNonRefundable) /* remianing cases */ {
                    filteredRates.append(currentRate)
                } else {
                    if isRefundableSelected && currentRate.cancellation_penalty!.is_refundable {
                        filteredRates.append(currentRate)
                    } else if isPartRefundable {
                        for penalty in currentRate.penalty_array! {
                            if !penalty.to.isEmpty && !penalty.from.isEmpty {
                                filteredRates.append(currentRate)
                            }
                        }
                    } else if isNonRefundable && !currentRate.cancellation_penalty!.is_refundable {
                        filteredRates.append(currentRate)
                    }
                }
            }
        }
//        if filteredRates.isEmpty {
//            return rates
//        }
        return filteredRates
    }
    
    
    
    
    func getFilteredRatesData(rates: [Rates], tagList: [String],roomMealData: [String],roomOtherData: [String],roomCancellationData: [String]) -> [Rates] {
        
        let filteredRates = rates.filter { (rate: Rates) -> Bool in
            
            switch self.currentlyFilterApplying {
                
            case .newTag:
                if let inclusionInfo = rate.inclusion_array[APIKeys.boardType.rawValue] as? [String] {
                    if inclusionInfo.containsArray(array: tagList) { return true }
                }
            case .roomMealTags:
                if let inclusionInfo = rate.inclusion_array[APIKeys.boardType.rawValue] as? [String] {
                    if inclusionInfo.containsArray(array: roomMealData) {
                        if !roomOtherData.isEmpty || !roomCancellationData.isEmpty {
                            if !roomOtherData.isEmpty {
                                if let internetInfo = rate.inclusion_array[APIKeys.internet.rawValue] as? [String] {
                                    if internetInfo.containsArray(array: roomOtherData) {
                                        return true
                                    }
                                    else {
                                        return false
                                    }
                                }
                            }
                            else if !roomCancellationData.isEmpty  {
                                let isRefundableSelected = roomCancellationData.contains(LocalizedString.Refundable.localized)
                                let isPartRefundable = roomCancellationData.contains(LocalizedString.PartRefundable.localized)
                                let isNonRefundable = roomCancellationData.contains(LocalizedString.NonRefundable.localized)
                                
                                if isRefundableSelected && isPartRefundable && isNonRefundable || (!isRefundableSelected && !isPartRefundable && !isNonRefundable) /* remianing cases */ {
                                    return true
                                } else {
                                    if isRefundableSelected && rate.cancellation_penalty!.is_refundable {
                                        return true
                                    } else if isPartRefundable {
                                        for penalty in rate.penalty_array! {
                                            if !penalty.to.isEmpty && !penalty.from.isEmpty { return true }
                                        }
                                    } else if isNonRefundable && !rate.cancellation_penalty!.is_refundable {
                                        return true
                                    }
                                }
                            }
                            
                        }
                        return true
                    }
                }
            case .roomOtherTags:
                if let internetInfo = rate.inclusion_array[APIKeys.internet.rawValue] as? [String] {
                    if internetInfo.containsArray(array: roomOtherData) {
                        return true
                    }
                }
            case .roomCancellationTags:
                let isRefundableSelected = roomCancellationData.contains(LocalizedString.Refundable.localized)
                let isPartRefundable = roomCancellationData.contains(LocalizedString.PartRefundable.localized)
                let isNonRefundable = roomCancellationData.contains(LocalizedString.NonRefundable.localized)
                
                if isRefundableSelected && isPartRefundable && isNonRefundable || (!isRefundableSelected && !isPartRefundable && !isNonRefundable) /* remianing cases */ {
                    return true
                } else {
                    if isRefundableSelected && rate.cancellation_penalty!.is_refundable {
                        return true
                    } else if isPartRefundable {
                        for penalty in rate.penalty_array! {
                            if !penalty.to.isEmpty && !penalty.from.isEmpty { return true }
                        }
                    } else if isNonRefundable && !rate.cancellation_penalty!.is_refundable {
                        return true
                    }
                }
            case .initialTags:
                if !roomMealData.isEmpty {
                    if let inclusionInfo = rate.inclusion_array[APIKeys.boardType.rawValue] as? [String] {
                        if inclusionInfo.containsArray(array: roomMealData) {
                            if !roomOtherData.isEmpty || !roomCancellationData.isEmpty {
                                
                                if !roomOtherData.isEmpty {
                                    if let internetInfo = rate.inclusion_array[APIKeys.internet.rawValue] as? [String] {
                                        if internetInfo.containsArray(array: roomOtherData) {
                                            return true
                                        }
                                        else {
                                            return false
                                        }
                                    }
                                }
                                else if !roomCancellationData.isEmpty  {
                                    let isRefundableSelected = roomCancellationData.contains(LocalizedString.Refundable.localized)
                                    let isPartRefundable = roomCancellationData.contains(LocalizedString.PartRefundable.localized)
                                    let isNonRefundable = roomCancellationData.contains(LocalizedString.NonRefundable.localized)
                                    
                                    if isRefundableSelected && isPartRefundable && isNonRefundable || (!isRefundableSelected && !isPartRefundable && !isNonRefundable) /* remianing cases */ {
                                        return true
                                    } else {
                                        if isRefundableSelected && rate.cancellation_penalty!.is_refundable {
                                            return true
                                        } else if isPartRefundable {
                                            for penalty in rate.penalty_array! {
                                                if !penalty.to.isEmpty && !penalty.from.isEmpty { return true }
                                            }
                                        } else if isNonRefundable && !rate.cancellation_penalty!.is_refundable {
                                            return true
                                        }
                                    }
                                }
                            }
                            else {
                                return true
                            }
                        } // return false
                    } else {
                        return false
                    }
                }
                    
                else if !roomOtherData.isEmpty {
                    if let internetInfo = rate.inclusion_array[APIKeys.internet.rawValue] as? [String] {
                        if internetInfo.containsArray(array: roomOtherData) {
                            if !roomCancellationData.isEmpty {
                                let isRefundableSelected = roomCancellationData.contains(LocalizedString.Refundable.localized)
                                let isPartRefundable = roomCancellationData.contains(LocalizedString.PartRefundable.localized)
                                let isNonRefundable = roomCancellationData.contains(LocalizedString.NonRefundable.localized)
                                
                                if isRefundableSelected && isPartRefundable && isNonRefundable || (!isRefundableSelected && !isPartRefundable && !isNonRefundable) /* remianing cases */ {
                                    return true
                                } else {
                                    if isRefundableSelected && rate.cancellation_penalty!.is_refundable {
                                        return true
                                    } else if isPartRefundable {
                                        for penalty in rate.penalty_array! {
                                            if !penalty.to.isEmpty && !penalty.from.isEmpty { return true }
                                        }
                                    } else if isNonRefundable && !rate.cancellation_penalty!.is_refundable {
                                        return true
                                    }
                                }
                            }
                            else {
                                return true
                            }
                        }
                    }
                }
                else if !roomCancellationData.isEmpty {
                    let isRefundableSelected = roomCancellationData.contains(LocalizedString.Refundable.localized)
                    let isPartRefundable = roomCancellationData.contains(LocalizedString.PartRefundable.localized)
                    let isNonRefundable = roomCancellationData.contains(LocalizedString.NonRefundable.localized)
                    
                    if isRefundableSelected && isPartRefundable && isNonRefundable || (!isRefundableSelected && !isPartRefundable && !isNonRefundable) /* remianing cases */ {
                        return true
                    } else {
                        if isRefundableSelected && rate.cancellation_penalty!.is_refundable {
                            return true
                        } else if isPartRefundable {
                            for penalty in rate.penalty_array! {
                                if !penalty.to.isEmpty && !penalty.from.isEmpty { return true }
                            }
                        } else if isNonRefundable && !rate.cancellation_penalty!.is_refundable {
                            return true
                        }
                    }
                }
            }
            return false
        }
        if self.selectedTags.isEmpty{//roomMealData.isEmpty && roomOtherData.isEmpty && roomCancellationData.isEmpty
            return rates
        }
        return filteredRates
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
