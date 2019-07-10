//
//  BookingReviewCancellationVM.swift
//  AERTRIP
//
//  Created by apple on 08/07/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol BookingReviewCancellationVMDelegate: class {
    func willGetCancellationRefundModeReasons()
    func getCancellationRefundModeReasonsSuccess()
    func getCancellationRefundModeReasonsFail()
    
    func willMakeCancellationRequest()
    func makeCancellationRequestSuccess()
    func makeCancellationRequestFail()
}

class BookingReviewCancellationVM {
    var legsWithSelection: [Leg] = []
    
    var totRefund: Double {
        return legsWithSelection.reduce(0) { $0 + ($1.selectedPaxs.reduce(0, { $0 + $1.netRefundForReschedule })) }
    }
    
    private(set) var refundModes: [String] = []
    private(set) var cancellationReasons: [String] = []
    private(set) var userRefundMode: String = "" {
        didSet {
            self.selectedMode = userRefundMode
        }
    }
    
    var selectedMode: String = ""
    var selectedReason: String = ""
    var comment: String = ""
    
    weak var delegate: BookingReviewCancellationVMDelegate?
    
    var isUserDataVerified: Bool {
        var flag = true
        
        if selectedMode.isEmpty || selectedMode.lowercased() == LocalizedString.Select.localized.lowercased() {
            flag = false
            AppToast.default.showToastMessage(message: "Please select refund mode.")
        }
        else if selectedReason.isEmpty || selectedReason.lowercased() == LocalizedString.Select.localized.lowercased() {
            flag = false
            AppToast.default.showToastMessage(message: "Please select a reason for cancellation.")
        }
        
        return flag
    }
    
    func getCancellationRefundModeReasons() {

        let param: JSONDictionary = ["product": "flight", "booking_id": self.legsWithSelection.first?.bookingId ?? ""]
        
        self.delegate?.willGetCancellationRefundModeReasons()
        APICaller.shared.getCancellationRefundModeReasonsAPI(params: param) { [weak self](success, error, modes, reasons, userMode) in
            
            if success {
                self?.refundModes = modes
                self?.cancellationReasons = reasons
                self?.userRefundMode = userMode
                self?.refundModes.insert(LocalizedString.Select.localized, at: 0)
                self?.cancellationReasons.insert(LocalizedString.Select.localized, at: 0)
                self?.delegate?.getCancellationRefundModeReasonsSuccess()
            }
            else {
                self?.delegate?.getCancellationRefundModeReasonsFail()
            }
        }
    }
    
    func makeCancellationRequest() {
        
        var allSelected: [String] = []
        for leg in self.legsWithSelection {
            allSelected.append(contentsOf: leg.selectedPaxs.map { $0.paxId })
        }
        
        let param: JSONDictionary = ["booking_id": self.legsWithSelection.first?.bookingId ?? "", "refund_mode": self.selectedMode, "reason": self.selectedReason, "cancel[]": allSelected, "comments": self.comment]
        
        self.delegate?.willMakeCancellationRequest()
        APICaller.shared.cancellationRequestAPI(params: param) { [weak self](success, error) in

            if success {
                self?.delegate?.makeCancellationRequestSuccess()
            }
            else {
                self?.delegate?.makeCancellationRequestFail()
            }
        }
    }
}
