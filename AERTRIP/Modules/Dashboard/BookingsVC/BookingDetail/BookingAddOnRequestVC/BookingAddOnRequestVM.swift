//
//  BookingAddOnRequestVC.swift
//  AERTRIP
//
//  Created by apple on 16/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BookingAddOnRequestVMDelegate: class {
    func getCaseHistorySuccess()
    func getCaseHistoryFail()
    
    func makeRequestConfirmSuccess()
    func makeRequestConfirmFail()
}

class BookingAddOnRequestVM {
    
    var receipt: Receipt? // to be used on the vouchers screen
    var caseData: Case? //to be bassed when the vc is created
    var caseHistory: BookingCaseHistory? {
        didSet {
            caseData?.resolutionStatusId = caseHistory?.resolutionStatusId ?? ""
            self.fetchCaseDetailData()
        }
    }
    weak var delegate: BookingAddOnRequestVMDelegate?
    
    var caseDetailData: JSONDictionary = [:]
    var caseDetailTitle: [String] {
        return Array(caseDetailData.keys).sorted(by: { $0 < $1 })
    }
    
    private func fetchCaseDetailData() {
        var temp: JSONDictionary = [:]
        
        guard let caseD = caseData, let history = caseHistory else {
            self.caseDetailData = temp
            return
        }

        temp["00Case Status"] = caseD.resolutionStatus.rawValue
        temp["01Agent"] = caseD.csrName.isEmpty ? LocalizedString.dash.localized : "🎧 \(caseD.csrName)"
        
        let dateStr = caseD.requestDate?.toString(dateFormat: "d MMM yyyy | HH:mm") ?? ""
        temp["02Requested on"] = dateStr.isEmpty ? LocalizedString.dash.localized : dateStr
        temp["03Associate Booking ID"] = caseD.bookingId.isEmpty ? LocalizedString.dash.localized : caseD.bookingId
        temp["04Reference Case ID"] = history.referenceCaseId.isEmpty ? LocalizedString.dash.localized : history.referenceCaseId
        
        for (idx,val) in history.associatedVouchersArr.enumerated() {
            if idx == 0 {
                temp["1\(idx)Associate Voucher No."] = val
            }
            else {
                temp["1\(idx)"] = val
            }
        }
        
        self.caseDetailData = temp
    }
    
    func getCaseHistory() {
        let param: JSONDictionary = ["case_id": caseData?.id ?? ""]
        APICaller.shared.getCaseHistory(params: param) { [weak self](success, errore, history) in
            guard let sSelf = self else {return}
            
            if success {
                sSelf.caseHistory = history
                sSelf.fetchCaseDetailData()
                sSelf.delegate?.getCaseHistorySuccess()
            }
            else {
                sSelf.delegate?.getCaseHistoryFail()
            }
        }
    }
    
    func makeRequestConfirm() {
        
        guard let caseData = caseData else {
            fatalError("Please pass the case to be aborted in \(#file) at line numer \(#line)")
        }
        
        let param = ["case_id": caseData.id, "booking_id": caseData.bookingId]
        AppGlobals.shared.startLoading()
        APICaller.shared.requestConfirmationAPI(params: param) { [weak self] (success, errors) in
            guard let sSelf = self else {return}
            
            if success {
                sSelf.delegate?.makeRequestConfirmSuccess()
            }
            else {
                sSelf.delegate?.makeRequestConfirmFail()
            }
        }
    }
}
