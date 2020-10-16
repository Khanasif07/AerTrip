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
    func fetchConfirmItineraryDataFail(errors: ErrorCodes)
    func willCallForItenaryDataTraveller()
    func callForItenaryDataTravellerSuccess()
    func callForItenaryDataTravellerFail(errors: ErrorCodes)
    
    func willFetchRecheckRatesData()
    func fetchRecheckRatesDataFail(errors: ErrorCodes)
    func fetchRecheckRatesDataSuccess(recheckedData: ItineraryData)
    func userLoginApiSuccess()
    func userLoginFailed(errors: ErrorCodes)
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
    internal var roomRates = [[RoomsRates : Int]]()
    var sectionData: [[TableCellType]] = []
    var hotelSearchRequest: HotelSearchRequestModel?
    internal var hotelInfo: HotelSearched?
    var mobileNumber: String = ""
    var mobileIsd: String = ""
    var email: String = ""
    var isGuestUser: String = "false"
    var selectedSpecialRequest : [Int] = []
    var selectedRequestsName: [String] = []
    var other: String = ""
    var specialRequest: String = ""
    // following properties will use to hit the confirmation API, will passed from where this class is being initiated
    var sId = "", hId = "", qId = ""
    var locid = ""
    var panCard: String = "CEQPK4956K"
    var detailPageRoomRate: Rates?
    var minContactLimit = 10
    var maxContactLimit = 10
    var canShowErrorForEmailPhone = false
    
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
                sSelf.itineraryData?.hotelDetails?.locid = sSelf.locid
                sSelf.delegate?.fetchConfirmItineraryDataSuccess()
            } else {
                printDebug(errors)
                sSelf.delegate?.fetchConfirmItineraryDataFail(errors: errors)
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
                sSelf.delegate?.fetchRecheckRatesDataFail(errors: errors)
                printDebug(errors)
            }
        }
    }
    
    func isValidateData(vc: UIViewController) -> Bool {
        var isValid = true
        
        // check for guest details valid or not
        for (_, room) in GuestDetailsVM.shared.guests.enumerated() {
            for (_, guest) in room.enumerated() {
                if (guest.firstName.isEmpty || guest.firstName.count < 3) || (guest.lastName.isEmpty || guest.lastName.count < 3)  || guest.salutation.isEmpty {
                    isValid = false
                    AppToast.default.showToastMessage(message: LocalizedString.GuestDetailsMessage.localized)
                    return isValid
                } else {
                    isValid = true
                }
            }
        }
        
        // check if mobile isd is valid or Not
        if self.mobileIsd.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.EnterIsdMessage.localized)
            return false
        }
        
        
        // check if mobile number is valid or Not
        if self.mobileNumber.isEmpty {
            AppToast.default.showToastMessage(message: LocalizedString.EnterMobileNumberMessage.localized)
            return false
        }
        
        if self.mobileNumber.count < self.minContactLimit {
            AppToast.default.showToastMessage(message: LocalizedString.PleaseEnterValidMobileNumber.localized)
            return false
        }
        
        
        // check if email is empty or Not
        if self.email.isEmpty || !self.email.checkValidity(.Email) {
            AppToast.default.showToastMessage(message: LocalizedString.EnterEmailAddressMessage.localized)
            return false
        }
        
        
        
        
        if (self.itineraryData?.hotelDetails?.pan_required ?? false) {
            // check if panCard is empty or Not
            if self.panCard.isEmpty || !self.panCard.checkValidity(.PanCard) {
                AppToast.default.showToastMessage(message: LocalizedString.EnterPanCardMessage.localized)
                return false
            }
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
                    params["t[\(i)][_t][\(j)][ptype]"] = guest.passengerType.rawValue
                } else {
                    params["t[\(i)][_t][\(j)][ptype]"] = guest.passengerType.rawValue
                    params["t[\(i)][_t][\(j)][age]"] = guest.age
                }
                params["t[\(i)][_t][\(j)][id]"] = guest.id
                
                printDebug("guest.id: \(guest.id)")
                printDebug("guest.apiId: \(guest.apiId)")

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
        if let rate = self.itineraryData?.hotelDetails?.rates?.first , let roomRates = rate.roomsRates {
            for(x,roomRate) in roomRates.enumerated() {
                params["t[\(x)][rid]"] = roomRate.rid
                params["t[\(x)][qid]"] = rate.qid
            }
        }
        
        //        params["t[0][rid]"] = self.itineraryData?.hotelDetails?.rates?.first?.roomsRates?.first?.rid
        //        params["t[0][qid]"] = self.itineraryData?.hotelDetails?.rates?.first?.qid
        params["special"] = self.specialRequest
        params["other"] = self.other
        
        params["mobile"] = self.mobileNumber
        params["mobile_isd"] = self.mobileIsd
        params["it_id"] = self.itineraryData?.it_id
        params["t_pan"] = self.panCard
        
        for value in selectedSpecialRequest {
            params["preference[\(value)]"] = true
        }
        
        
        //        self.delegate?.willCallForItenaryDataTraveller()
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
    
    func dataForTableCell(rate: Rates, currentRoom: RoomsRates) -> [TableCellType] {
        var presentedCell = [TableCellType]()
        presentedCell.removeAll()
        if (rate.roomsRates?.count ?? 0) > 0 {
            presentedCell.append(.roomBedsTypeCell)
        }
        //        } else {
        //            for room in rate.roomsRates ?? [] {
        //                if room.name != currentRoom.name {
        //                    presentedCell.append(.roomBedsTypeCell)
        //                }
        //            }
        //        }
        if let boardInclusion =  rate.inclusion_array[APIKeys.boardType.rawValue] as? [Any], !boardInclusion.isEmpty {
            presentedCell.append(.inclusionCell)
        } else if let internetData =  rate.inclusion_array[APIKeys.internet.rawValue] as? [Any], !internetData.isEmpty {
            presentedCell.append(.inclusionCell)
        }
        if let otherInclusion =  rate.inclusion_array[APIKeys.other_inclusions.rawValue] as? [Any], !otherInclusion.isEmpty {
            presentedCell.append(.otherInclusionCell)
        }
        if rate.cancellation_penalty != nil {
            presentedCell.append(.cancellationPolicyCell)
        }
        presentedCell.append(.paymentPolicyCell)
        if let notesData =  rate.inclusion_array[APIKeys.notes_inclusion.rawValue] as? [Any], !notesData.isEmpty {
            presentedCell.append(.notesCell)
        }
        return presentedCell
    }
    
    private func getFirstSectionCell(hotelData: HotelDetails) -> [TableCellType] {
        var firstSectionCells: [TableCellType] = []
        firstSectionCells.append(.imageSlideCell)
        firstSectionCells.append(.hotelRatingCell)
        firstSectionCells.append(.addressCell)
        firstSectionCells.append(.checkInOutDateCell)
        if !hotelData.info.isEmpty {
            firstSectionCells.append(.overViewCell)
        }
        if ((hotelData.amenities?.main) != nil) {
            firstSectionCells.append(.amenitiesCell)
        }
        if !hotelData.locid.isEmpty {
            firstSectionCells.append(.tripAdvisorRatingCell)
        }
        return firstSectionCells
    }
    
    func getHotelDetailsSectionData() {
        self.sectionData.removeAll()
        self.roomRates.removeAll()
        
        if let hotelData = self.itineraryData?.hotelDetails , let ratesData = hotelData.rates {
            self.sectionData.append(getFirstSectionCell(hotelData: hotelData))
            // Room details cell only for room label cell
            self.sectionData.append([.roomDetailsCell])
            for rate in ratesData {
//                self.sectionData.append(self.dataForTableCell(rate: rate, currentRoom: rate.roomsRates?.first ?? RoomsRates()))
                self.sectionData.append(rate.tableViewRowCell)
                self.roomRates.append(rate.roomData)
//                var tempData = [RoomsRates: Int] ()
//                for currentRoom in rate.roomsRates ?? [] {
//                    var count = 1
//                    for otherRoom in rate.roomsRates ?? [] {
//                        if (otherRoom.uuRid != currentRoom.uuRid) , currentRoom.rid == otherRoom.rid {
//                            if otherRoom == currentRoom {
//                                count = count + 1
//                            }
//                        }
//                    }
//                    tempData[currentRoom] = count
//                }
//                if !roomRates.contains(array: [tempData]) {
//                    self.roomRates.append(tempData)
//                }
            }
            printDebug(self.roomRates)
        }
    }
    
    // MARK: - Mark Favourite
    
    // MARK: -
    
    func updateFavourite() {
        let param: JSONDictionary = ["hid[0]": itineraryData?.hotelDetails?.hid ?? "0", "status": itineraryData?.hotelDetails?.fav == "0" ? 1 : 0]
        
        
        //save locally and update ui
        self.hotelInfo?.fav = self.hotelInfo?.fav == "0" ? "1" : "0"
        _ = self.hotelInfo?.afterUpdate
        self.delegate?.updateFavouriteSuccess(withMessage: "")
        
        APICaller.shared.callUpdateFavouriteAPI(params: param) { [weak self] isSuccess, errors, successMessage in
            if let sSelf = self {
                if isSuccess {
                    sSelf.delegate?.updateFavouriteSuccess(withMessage: successMessage)
                } else {
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
                    sSelf.delegate?.updateFavouriteFail(errors: errors)
                }
            }
        }
    }
    
    func logInUserApi() {
        let params: JSONDictionary = [APIKeys.loginid.rawValue : self.email.removeLeadingTrailingWhitespaces , APIKeys.password.rawValue : "" , APIKeys.isGuestUser.rawValue : "true"]
        printDebug(params)
        APICaller.shared.loginForPaymentAPI(params: params) { [weak self] (success, logInId, isGuestUser, errors) in
            guard let sSelf = self else { return }
            if success {
                sSelf.isGuestUser = isGuestUser
                printDebug("\(logInId) , \(isGuestUser)")
                sSelf.delegate?.userLoginApiSuccess()
            } else {
                sSelf.delegate?.userLoginFailed(errors: errors)
            }
        }
    }
}
