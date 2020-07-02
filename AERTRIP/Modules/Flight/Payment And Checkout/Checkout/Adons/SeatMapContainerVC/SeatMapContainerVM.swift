//
//  SeatMapContainerVM.swift
//  AERTRIP
//
//  Created by Rishabh on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol SeatMapContainerDelegate: AnyObject {
    func willFetchSeatMapData()
    func didFetchSeatMapData()
    func failedToFetchSeatMapData()
    func willHitPostConfAPI()
    func didHitPostConfAPI()
    func willFetchQuotationData()
    func didFetchQuotationData(_ quotationModel: AddonsQuotationsModel)
    func faildToFetchQuotationData()
}

class SeatMapContainerVM {
    
    struct AddOnPassengersToSeatModel {
        let passenger: ATContact
        let flightId: String
        let rowNum: Int
        let columnStr: String
        
        init(_ pass: ATContact,_ flightId: String,_ rowNum: Int,_ columnStr: String) {
            self.passenger = pass
            self.flightId = flightId
            self.rowNum = rowNum
            self.columnStr = columnStr
        }
    }
    
    enum SetupFor {
        case preSelection
        case postSelection
    }
    
    weak var delegate: SeatMapContainerDelegate?
    private let sid: String
    private let itId: String
    private let fk: String
    var bookingId = ""
    var seatMapModel = SeatMapModel()
    
    var allTabsStr = [NSAttributedString]()
    var currentIndex = 0
    var allFlightsData = [SeatMapModel.SeatMapFlight]()
    var originalAllFlightsData = [SeatMapModel.SeatMapFlight]()
    
    var setupFor: SetupFor = .preSelection
    
    var selectedSeats = [SeatMapModel.SeatMapRow]()
    
    //MARK: Variables for post booking
    var bookingFlightLegs = [BookingLeg]()
    var bookingAddOns = [BookingAddons]()
    var bookedPassengersArr = [ATContact]()
    var originalBookedAddOnSeats = [SeatMapModel.SeatMapRow]()
    var bookingIds = [String]()
    
    convenience init() {
        self.init("", "", "")
    }
    
    init(_ sid: String,_ itId: String,_ fk: String) {
        self.sid = sid
        self.itId = itId
        self.fk = fk
    }
    
    func fetchSeatMapData() {
        if setupFor == .postSelection {
            fetchPostSelectionSeatMapData()
        } else {
            fetchPreSelectionSeatMapData()
        }
    }
    
    private func fetchPreSelectionSeatMapData() {
        if let seatModel = AddonsDataStore.shared.originalSeatMapModel {
            seatMapModel = seatModel
            delegate?.didFetchSeatMapData()
            return
        }
        self.delegate?.willFetchSeatMapData()
        let params: JSONDictionary = [FlightSeatMapKeys.sid.rawValue: sid,
                                      FlightSeatMapKeys.itId.rawValue: itId,
                                      FlightSeatMapKeys.fk.rawValue: fk]
        APICaller.shared.callSeatMapAPI(params: params) { [weak self] (seatModel, error) in
            if let model = seatModel {
                self?.seatMapModel = model
                AddonsDataStore.shared.originalSeatMapModel = model
                self?.delegate?.didFetchSeatMapData()
            }else {
                self?.delegate?.failedToFetchSeatMapData()
            }
        }
    }
    
    private func fetchPostSelectionSeatMapData() {
        self.delegate?.willFetchSeatMapData()
        let params: JSONDictionary = [FlightSeatMapKeys.type.rawValue: "seat", FlightSeatMapKeys.bid.rawValue: bookingId]
        APICaller.shared.callPostBookingSeatMapAPI(params: params) { [weak self] (seatModel, error) in
            if let model = seatModel {
                self?.seatMapModel = model
                self?.delegate?.didFetchSeatMapData()
            }else {
                self?.delegate?.failedToFetchSeatMapData()
            }
        }
    }
    
    func getSeatTotal(_ seatTotal: @escaping ((Int) -> ())) {
        
        let previouslySelectedSeats = originalBookedAddOnSeats.map { $0.columnData.ssrCode }
        
        func calculateSeatTotal() -> Int {
            var seatTotal = 0
            selectedSeats.removeAll()
            allFlightsData.forEach { (flight) in
                let rows = flight.md.rows.flatMap { $0.value } + flight.ud.rows.flatMap { $0.value }
                rows.forEach { (_, rowData) in
                    if rowData.columnData.passenger != nil {
                        if !previouslySelectedSeats.contains(rowData.columnData.ssrCode) {
                            seatTotal += rowData.columnData.amount
                        }
                        selectedSeats.append(rowData)
                    }
                }
            }
            return seatTotal
        }
        
        DispatchQueue.global(qos: .background).async {
            let totalAmount = calculateSeatTotal()
            DispatchQueue.main.async {
                seatTotal(totalAmount)
            }
        }
    }
    
    func hitPostSeatConfirmationAPI() {
     //   delegate?.willHitPostConfAPI()
        let params = createParamsForPostConfirmation()
        self.delegate?.willFetchQuotationData()
        APICaller.shared.hitSeatPostConfirmationAPI(params: params) {[weak self] (addOnModel, err) in
            if let model = addOnModel {
                let itId = model.itinerary.id
                self?.getQuatationDataAPI(with: itId)
            }else{
                self?.delegate?.faildToFetchQuotationData()
            }
        }
    }
    
    
    func getQuatationDataAPI(with itId:String){
        let param = [APIKeys.it_id.rawValue:itId]
        APICaller.shared.getAddonsQuatationApi(params: param) {[weak self] (quotationModel, err) in
            printDebug(quotationModel)
            if let quotataion = quotationModel{
                self?.delegate?.didFetchQuotationData(quotataion)
            }else{
                self?.delegate?.faildToFetchQuotationData()
            }
            
            
        }
        
        
    }
    
    
    private func createParamsForPostConfirmation() -> JSONDictionary {
        var dict = JSONDictionary()
        dict[FlightSeatMapKeys.bookingId.rawValue] = bookingId
        selectedSeats.forEach { (seatData) in
            let passengerId = seatData.columnData.passenger?.apiId ?? ""
            
            var rowStr: String {
                if let number = Int(seatData.columnData.ssrCode.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                    print(number)
                    return "\(number)"
                }
                return ""
            }
            let columnStr = seatData.columnData.ssrCode.components(separatedBy: CharacterSet.letters.inverted).joined()
                    
            let priceStr = "\(seatData.columnData.amount)"
                        
            let seatParamBaseStr = "addons[\(seatData.lfk)][\(seatData.ffk)][\(passengerId)][seat]"
            dict[seatParamBaseStr+"[row]"] = rowStr
            dict[seatParamBaseStr+"[column]"] = columnStr
            dict[seatParamBaseStr+"[price]"] = priceStr
            dict[seatParamBaseStr+"[isOverwing]"] = "\(seatData.isWindowSeat)"
        }
        return dict
    }
    
}
