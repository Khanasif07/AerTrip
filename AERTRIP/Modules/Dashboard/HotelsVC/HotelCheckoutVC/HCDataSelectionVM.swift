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
    
    func fetchRecheckRatesDataSuccess(recheckedData: ItineraryData)
}

class HCDataSelectionVM {
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: HCDataSelectionVMDelegate?
    private(set) var itineraryData: ItineraryData?

    //following properties will use to hit the confirmation API, will passed from where this class is being initiated
    var sId = "", hId = "", qId = ""
        
    var guests : [[GuestModal]] = [[]]

    //MARK:- Private
    
    //MARK:- Methods
    //MARK:- Private
    
    
    //MARK:- Public
    func fetchConfirmItineraryData() {
        let params: JSONDictionary = [APIKeys.sid.rawValue: sId, APIKeys.hid.rawValue: hId, "data[0][qid]": qId, "p": "hotels"]
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
    
    func fetchRecheckRatesData() {
        let params: JSONDictionary = [APIKeys.it_id.rawValue: itineraryData?.it_id ?? ""]
        printDebug(params)
        
        APICaller.shared.fetchRecheckRatesData(params: params) { [weak self] (success, errors, itData) in
            guard let sSelf = self else { return }
            if success, let data = itData {
                sSelf.delegate?.fetchRecheckRatesDataSuccess(recheckedData: data)
            } else {
                printDebug(errors)
            }
        }
    }
}
