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
    func updateProgress(_ progress: Float)
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
    private let domesticLegFKs: [String]
    let isInternational: Bool
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
        self.init("", "", "", [])
    }
    
    init(_ sid: String,_ itId: String,_ fk: String,_ legFKs: [String]) {
        self.sid = sid
        self.itId = itId
        self.fk = fk
        self.domesticLegFKs = legFKs
        self.isInternational = legFKs.isEmpty
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
        func fetchSeatMapDataForFK(_ key: String) {
            let params: JSONDictionary = [FlightSeatMapKeys.sid.rawValue: sid,
                                          FlightSeatMapKeys.itId.rawValue: itId,
                                          FlightSeatMapKeys.fk.rawValue: key]
            APICaller.shared.callSeatMapAPI(params: params) { [weak self] (seatModel, error) in
                guard let self = self else { return }
                if self.isInternational {
                    self.delegate?.updateProgress(1)
                } else {
                    self.delegate?.updateProgress(0.75/Float(self.domesticLegFKs.count))
                }
                if let model = seatModel {
                    if self.seatMapModel.data.leg.count == 0 {
                        self.seatMapModel = model
                        self.addSortOrderToIntFlights()
                    } else {
                        self.addLegsToSeatMapModel(from: model)
                    }
                    AddonsDataStore.shared.originalSeatMapModel = self.seatMapModel
                    self.delegate?.didFetchSeatMapData()
                }else {
                    self.delegate?.failedToFetchSeatMapData()
                }
            }
        }
        
        self.delegate?.willFetchSeatMapData()
        
        if isInternational {
            fetchSeatMapDataForFK(fk)
        } else {
            domesticLegFKs.forEach { (fk) in
                fetchSeatMapDataForFK(fk)
            }
        }
    }
    
    private func addLegsToSeatMapModel(from model: SeatMapModel) {
                
        model.data.leg.forEach { (lfk, legData) in
            seatMapModel.data.leg[lfk] = legData
        }
        addSortOrderToDomesticFlights()
    }
    
    private func addSortOrderToDomesticFlights() {
        let curLegs = seatMapModel.data.leg
        domesticLegFKs.enumerated().forEach { (index, lfk) in
            if let _ = curLegs[lfk] {
                seatMapModel.data.leg[lfk]?.sortOrder = index
            }
        }
    }
    
    private func addSortOrderToIntFlights() {
        guard let mainLegKey = seatMapModel.data.leg.keys.first else { return }
        let flights = seatMapModel.data.leg[mainLegKey]?.flights
        AddonsDataStore.shared.flightKeys.enumerated().forEach { (index, ffk) in
            if let _ = flights?[ffk] {
                seatMapModel.data.leg[mainLegKey]?.flights[ffk]?.intSortOrder = index
            }
        }
    }
    
    private func fetchPostSelectionSeatMapData() {
        self.delegate?.willFetchSeatMapData()
        let params: JSONDictionary = [FlightSeatMapKeys.type.rawValue: "seat", FlightSeatMapKeys.bid.rawValue: bookingId]
        APICaller.shared.callPostBookingSeatMapAPI(params: params) { [weak self] (seatModel, error) in
            self?.delegate?.updateProgress(1)
            if let model = seatModel {
                self?.seatMapModel = model
                self?.delegate?.didFetchSeatMapData()
            }else {
                self?.delegate?.failedToFetchSeatMapData()
            }
        }
    }
    
    func getSeatTotal(_ seatTotal: @escaping ((Int) -> ())) {
                
        func calculateSeatTotal() -> Int {
            var seatTotal = 0
            selectedSeats.removeAll()
            allFlightsData.forEach { (flight) in
                let rows = flight.md.rows.flatMap { $0.value } + flight.ud.rows.flatMap { $0.value }
                rows.forEach { (_, rowData) in
                    if rowData.columnData.passenger != nil {
                        
                        if originalBookedAddOnSeats.contains(where: { $0.columnData.passenger?.id == rowData.columnData.passenger?.id && $0.columnData.amount >= rowData.columnData.amount }) {
                            
                        } else {
                            if let seatData = originalBookedAddOnSeats.first(where: { $0.columnData.passenger?.id == rowData.columnData.passenger?.id }) {
                                seatTotal += rowData.columnData.amount - seatData.columnData.amount
                            } else {
                                seatTotal += rowData.columnData.amount
                            }
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
                    printDebug(number)
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
