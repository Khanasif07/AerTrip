//
//  HCDataSelectionVM.swift
//  AERTRIP
//
//  Created by Admin on 12/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HCDataSelectionVMDelegate: class {
    func willFetchConfirmItineraryData()
    func fetchConfirmItineraryDataSuccess()
    func fetchConfirmItineraryDataFail()
    func willCallForItenaryDataTraveller()
    func callForItenaryDataTravellerSuccess()
    func callForItenaryDataTravellerFail(errors: ErrorCodes)
    
    func willFetchRecheckRatesData()
    func fetchRecheckRatesDataFail()
    func fetchRecheckRatesDataSuccess(recheckedData: ItineraryData)
    
    func updateFavouriteSuccess(withMessage: String)
    func updateFavouriteFail(errors: ErrorCodes)
}

class HCDataSelectionVM {
    // MARK: - Properties
    
    // MARK: - Public
    
    weak var delegate: HCDataSelectionVMDelegate?
    var itineraryData: ItineraryData?
    var itineraryPriceDetail: ItenaryModel = ItenaryModel()
    var placeModel: PlaceModel?
    var sectionData: [[TableCellType]] = []
    var hotelSearchRequest: HotelSearchRequestModel?
    internal var hotelInfo: HotelSearched?
    var mobileNumber: String = ""
    var mobileIsd: String = ""
    var email: String = ""
    
    // following properties will use to hit the confirmation API, will passed from where this class is being initiated
    var sId = "", hId = "", qId = ""
    
    // MARK: - Private
    
    // MARK: - Methods
    
    // MARK: - Private
    
    // MARK: - Public
    
    func fetchConfirmItineraryData() {
        let params: JSONDictionary = [APIKeys.sid.rawValue: sId, APIKeys.hid.rawValue: hId, "data[0][qid]": qId, "p": "hotels"]
        printDebug(params)
        
        delegate?.willFetchConfirmItineraryData()
        APICaller.shared.fetchConfirmItineraryData(params: params) { [weak self] success, errors, itData in
            guard let sSelf = self else { return }
            if success {
                sSelf.itineraryData = itData
                sSelf.delegate?.fetchConfirmItineraryDataSuccess()
            } else {
                printDebug(errors)
                sSelf.delegate?.fetchConfirmItineraryDataFail()
            }
        }
    }
    
    func fetchRecheckRatesData() {
        let params: JSONDictionary = [APIKeys.it_id.rawValue: itineraryData?.it_id ?? ""]
        printDebug(params)
        
        self.delegate?.willFetchRecheckRatesData()
        APICaller.shared.fetchRecheckRatesData(params: params) { [weak self] success, errors, itData in
            guard let sSelf = self else { return }
            if success, let data = itData {
                sSelf.delegate?.fetchRecheckRatesDataSuccess(recheckedData: data)
            } else {
                sSelf.delegate?.fetchRecheckRatesDataFail()
                printDebug(errors)
            }
        }
    }
    
    func isValidateData(vc: UIViewController) -> Bool {
        var isValid = false
        
        // check for guest details valid or not
        for (_, room) in GuestDetailsVM.shared.guests.enumerated() {
            for (_, guest) in room.enumerated() {
                if guest.firstName.isEmpty || guest.lastName.isEmpty || guest.salutation.isEmpty {
                    isValid = false
                    AppToast.default.showToastMessage(message: LocalizedString.GuestDetailsMessage.localized)
                    return isValid
                } else {
                    isValid = true
                }
            }
        }
        // check if mobile number is valid or Not
        if self.mobileNumber.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.EnterMobileNumberMessage.localized)
            isValid = false
        }
        // check if mobile isd is valid or Not
        if self.mobileIsd.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.EnterIsdMessage.localized)
            isValid = false
        }
        // check if email is empty or Not
        if self.email.isEmpty || !self.email.checkValidity(.Email) {
            AppToast.default.showToastMessage(message: LocalizedString.EnterEmailAddressMessage.localized)
            isValid = false
        }
        return isValid
    }
    
    func webserviceForItenaryDataTraveller() {
        var params = JSONDictionary()
        
        // Setting params for guest User Array
        
        for (i, room) in GuestDetailsVM.shared.guests.enumerated() {
            for (j, guest) in room.enumerated() {
                params["t[\(i)][_t][\(j)][fname]"] = guest.firstName
                params["t[\(i)][_t][\(j)][lname]"] = guest.lastName
                params["t[\(i)][_t][\(j)][sal]"] = guest.salutation
                if guest.passengerType == .Adult {
                    params["t[\(i)][_t][\(j)][ptype]"] = guest.passengerType
                } else {
                    params["t[\(i)][_t][\(j)][ptype]"] = guest.passengerType
                    params["t[\(i)][_t][\(j)][age]"] = guest.age
                }
                params["t[\(i)][_t][\(j)][id]"] = guest.id
            }
        }
        
        /* Hardcode guest params required for testing if required */
        
//        params["t[0][_t][0][fname]"] = "Pawan"
//        params["t[0][_t][0][lname]"] =  "Kumar"
//        params["t[0][_t][0][sal]:"] =  "Mr"
//        params["t[0][_t][0][ptype]"] =  "ADT"
//        params["t[0][_t][0][id]"] = "13332"
//        params["t[0][_t][1][fname]"] = "fdsfs"
//        params["t[0][_t][1][lname]"] = "fsdfsdfsdf"
//        params["t[0][_t][1][sal]"] =  "Mr"
//        params["t[0][_t][1][ptype]"] =  "ADT"
//        params["t[0][_t][1][id]"] = "0"
        
        // rid and qid in parameters
        params["t[0][rid]"] = self.itineraryData?.hotelDetails?.rates?.first?.roomsRates?.first?.rid
        params["t[0][qid]"] = self.itineraryData?.hotelDetails?.rates?.first?.qid
        params["special"] = ""
        params["other"] = ""
        
        params["mobile"] = self.mobileNumber
        params["mobile_isd"] = self.mobileIsd
        params["it_id"] = self.itineraryData?.it_id
        
        self.delegate?.willCallForItenaryDataTraveller()
        APICaller.shared.callItenaryDataForTravellerAPI(itinaryId: self.itineraryData?.it_id ?? "", params: params, loader: false) { [weak self] success, errors, _, itinerary in
            guard let sSelf = self else { return }
            if success {
                sSelf.itineraryPriceDetail = itinerary
                sSelf.delegate?.callForItenaryDataTravellerSuccess()
            } else {
                sSelf.delegate?.callForItenaryDataTravellerFail(errors: errors)
            }
        }
    }
    
    func getHotelDetailsSectionData() {
        self.sectionData.removeAll()
        self.sectionData.append([.imageSlideCell, .hotelRatingCell, .addressCell, .checkInOutDateCell, .amenitiesCell, .tripAdvisorRatingCell])
        if let ratesData = self.itineraryData?.hotelDetails?.rates {
            // Room details cell only for room label cell
            self.sectionData.append([.roomDetailsCell])
            for rate in ratesData {
                var tableViewCell = rate.tableViewRowCell
                if tableViewCell.contains(.checkOutCell) {
                    tableViewCell.remove(object: .checkOutCell)
                }
                self.sectionData.append(tableViewCell)
            }
        }
    }
    
    // MARK: - Mark Favourite
    
    // MARK: -
    
    func updateFavourite() {
        let param: JSONDictionary = ["hid[0]": itineraryData?.hotelDetails?.hid ?? "0", "status": itineraryData?.hotelDetails?.fav == "0" ? 1 : 0]
        APICaller.shared.callUpdateFavouriteAPI(params: param) { [weak self] isSuccess, errors, successMessage in
            if let sSelf = self {
                if isSuccess {
                    sSelf.hotelInfo?.fav = sSelf.hotelInfo?.fav == "0" ? "1" : "0"
                    sSelf.delegate?.updateFavouriteSuccess(withMessage: successMessage)
                    _ = self?.hotelInfo?.afterUpdate
                } else {
                    sSelf.delegate?.updateFavouriteFail(errors: errors)
                }
            }
        }
    }
}
