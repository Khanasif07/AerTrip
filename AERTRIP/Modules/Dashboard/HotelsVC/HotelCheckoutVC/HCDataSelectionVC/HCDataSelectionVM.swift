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
    func fetchRecheckRatesDataSuccess(recheckedData: ItineraryData)
}

class HCDataSelectionVM {
    // MARK: - Properties
    
    // MARK: - Public
    
    weak var delegate: HCDataSelectionVMDelegate?
    private(set) var itineraryData: ItineraryData?
    var itineraryPriceDetail:ItenaryModel = ItenaryModel()
    
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
        
        APICaller.shared.fetchRecheckRatesData(params: params) { [weak self] success, errors, itData in
            guard let sSelf = self else { return }
            if success, let data = itData {
                sSelf.delegate?.fetchRecheckRatesDataSuccess(recheckedData: data)
            } else {
                printDebug(errors)
            }
        }
    }
    
    func webserviceForItenaryDataTraveller() {
        var params = JSONDictionary()
        
//
//        for (idx, guest) in GuestDetailsVM.shared.guests {
//            for key in Array(socialObj.jsonDict.keys) {
//                params["contact[social][\(idx)][\(key)]"] = socialObj.jsonDict[key]
//            }
//        }
        
        params["t[0][_t][0][fname]"] = "Pawan"
        params["t[0][_t][0][lname]"] =  "Kumar"
        params["t[0][_t][0][sal]:"] =  "Mr"
        params["t[0][_t][0][ptype]"] =  "ADT"
        params["t[0][_t][0][id]"] = "13332"
        params["t[0][_t][1][fname]"] = "fdsfs"
        params["t[0][_t][1][lname]"] = "fsdfsdfsdf"
        params["t[0][_t][1][sal]"] =  "Mr"
        params["t[0][_t][1][ptype]"] =  "ADT"
        params["t[0][_t][1][id]"] = "0"
        
        params["t[0][rid]"] = itineraryData?.hotelDetails?.rates?.first?.roomsRates?.first?.rid
        params["t[0][qid]"] = itineraryData?.hotelDetails?.rates?.first?.qid
        params["special"] = ""
        params["other"] = ""
        
        // sending hard coded for now
        params["mobile"] = "9716218820"
        params["mobile_isd"] = "+91"
        params["it_id"] = itineraryData?.it_id
        
        self.delegate?.willCallForItenaryDataTraveller()
        APICaller.shared.callItenaryDataForTravellerAPI(itinaryId: itineraryData?.it_id ?? "",params: params, loader: false) { [weak self] success, errors,message,itinerary in
            guard let sSelf = self else { return }
            if success {
                sSelf.itineraryPriceDetail = itinerary
                sSelf.delegate?.callForItenaryDataTravellerSuccess()
            } else {
                sSelf.delegate?.callForItenaryDataTravellerFail(errors: errors)
            }
        }
    }
}
