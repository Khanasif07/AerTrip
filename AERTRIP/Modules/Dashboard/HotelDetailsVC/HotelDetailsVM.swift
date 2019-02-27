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
    var vid: String = ""
    var sid: String = ""
    var hid: String = ""
    //var mode: String = "WALKING"
    var mode: MapMode = .walking
    var isFooterViewHidden: Bool = false
    private var getHotelInfoParams: JSONDictionary {
        let params: JSONDictionary = [APIKeys.vid.rawValue : "\(self.hotelInfo?.vid ?? "")" , APIKeys.hid.rawValue : "\(self.hotelInfo?.hid ?? "")", APIKeys.sid.rawValue : self.sid]
        return params
    }
    
    ///Get Hotel Info Api
    func getHotelInfoApi() {
        //let params: JSONDictionary = self.getHotelInfoParams
        //printDebug(params)
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

extension HotelDetailsVM {
    
//    internal func roomFilteration(rates: Rates) {
//        var roomDict: [Int: RoomsRates] = [:]
//        if let roomsData = rates.roomsRates{
//            for room in roomsData {
//                if roomsData.con
//                //dict.filter{ $0.key.contains("Foo") }.count
////                let dictionary = roomsData.reduce(into: [:]) { counts, number in
////                    counts[number, default: 0] += 1
////                }
//                
//            }
//        }
//       
////        func filterData() -> [RLGroupUser]? {
////            guard let safeGroupModel = self.groupModel else { return nil }
////            let filteredMembers = Array(safeGroupModel.groupUsers).filter { (rlGrpUser) -> Bool in
////                return (rlGrpUser.isAdmin || rlGrpUser.isOwner)
////            }
////            return filteredMembers
////        }
//    }
}


extension Array where Element: Hashable {
    
    func countForElements() -> [Element: Int] {
        var counts = [Element: Int]()
        for element in self {
            counts[element] = (counts[element] ?? 0) + 1
        }
        return counts
    }
    
}
