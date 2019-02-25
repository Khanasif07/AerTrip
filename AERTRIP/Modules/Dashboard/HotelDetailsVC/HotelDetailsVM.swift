//
//  HotelDetailsVM.swift
//  AERTRIP
//
//  Created by Admin on 14/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

protocol DataSource {
    var title: String? { get }
    var sections: [Section] { get }
}

protocol Section {
    var header: String? { get }
    var footer: String? { get }
    var items: [Item] { get }
}

protocol Item {
    var identifier: String { get }
    var viewModel: ViewModel { get }
    var child: DataSource? { get }
}

protocol ViewModel {}

// MARK: - Helpers

extension DataSource {
    var title: String? { return nil }
    
    func item(at indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.item]
    }
    func identifier(at indexPath: IndexPath) -> String {
        return item(at: indexPath).identifier
    }
    func viewModel(at indexPath: IndexPath) -> ViewModel {
        return item(at: indexPath).viewModel
    }
    
    var uniqueIdentifiers: Set<String> {
        var ids: Set<String> = Set<String>()
        sections.forEach { section in
            let allSectionIdentifiers: [String] = section.items.map({ $0.identifier })
            ids.formUnion(allSectionIdentifiers)
        }
        return ids
    }
}

extension Section {
    var header: String? { return nil }
    var footer: String? { return nil }
}

extension Item {
    var child: DataSource? { return nil }
}

protocol CellDelegate: class {
    func callback(from cell: Cell, sender: Any)
}

protocol Cell: class {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
    
    var delegate: CellDelegate? { get set }
    var userInfo: [AnyHashable: Any] { get set }
    
    func configure()
    func reset()
    func update(with item: Item)
    
    func callback(_ sender: Any)
}

extension Cell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    static var nib: UINib? {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    func callback(_ sender: Any) {
        delegate?.callback(from: self, sender: sender)
    }
}


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
    
    
    private var getParams: JSONDictionary {
        let params: JSONDictionary = [APIKeys.vid.rawValue : "\(self.hotelInfo?.vid ?? "")" , APIKeys.hid.rawValue : "\(self.hotelInfo?.hid ?? "")", APIKeys.sid.rawValue : self.sid]
        return params
    }
    
    func getHotelInfoApi() {
        
        let params: JSONDictionary = self.getParams
        printDebug(params)
        APICaller.shared.getHotelDetails(params: params) { [weak self] (success, errors, hotelData) in
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

