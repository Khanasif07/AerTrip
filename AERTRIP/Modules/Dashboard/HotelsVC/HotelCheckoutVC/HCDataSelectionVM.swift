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
}

class HCDataSelectionVM {
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: HCDataSelectionVMDelegate?
    private(set) var itineraryData: ItineraryData?
    
    static let shared = HCDataSelectionVM()
    
    // Save Hotel Form Data
    
    var hotelFormData : HotelFormPreviosSearchData = HotelFormPreviosSearchData()
    var selectedIndexPath: IndexPath = IndexPath()
    
    //GuestModalArray for travellers
    var guests : [[GuestModal]] = [[]]
    
    
    private init() {}
    
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Private
    
    
    //MARK:- Public
    func fetchConfirmItineraryData() {
        let params: JSONDictionary = ["":""]
        printDebug(params)
        
        delegate?.willFetchConfirmItineraryData()
        APICaller.shared.fetchConfirmItineraryData(params: params) { [weak self] (success, errors, itData) in
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
}
