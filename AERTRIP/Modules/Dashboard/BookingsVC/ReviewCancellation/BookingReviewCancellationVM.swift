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
    func makeCancellationRequestSuccess(caseData: Case?)
    func makeCancellationRequestFail()
}

class BookingReviewCancellationVM {
    
    //MARK:- Enum
    enum UsingFor {
        case flightCancellationReview
        case hotelCancellationReview
        case specialRequest
    }
    
    var currentUsingAs = UsingFor.flightCancellationReview
    var isForflightCancellation = false
    
    //special request
    var bookingId: String  = ""
    
    //hotel
    var totRefundForHotel: Double {
        return 50.0
    }
    
    var selectedRooms: [RoomDetailModel] = []
    
    //flight
    var legsWithSelection: [BookingLeg] = []
    
    var bookingDetails:BookingDetailModel?
    
    // Net Refund for Cancellation is used for Flight detail
    var totRefundForFlight: Double {
        return (legsWithSelection.reduce(0) { $0 + ($1.selectedPaxs.reduce(0, { $0 + $1.netRefundForCancellation })) } - (legsWithSelection.reduce(0){ $0 + ($1.selectedPaxs.reduce(0, { $0 + $1.reversalMFPax }))}))
    }
    
    var totalRefundForHotel: Double {
          return (selectedRooms.reduce(0) { $0 + ($1.netRefund) } - (self.bookingDetails?.receipt?.reversalMF ?? 0.0))
    }

    private(set) var refundModes: [String] = []
    private(set) var cancellationReasons: [String] = []
    private(set) var userRefundMode: String = "" {
        didSet {
            self.selectedMode = userRefundMode
        }
    }
    
    private(set) var specialRequests: [String] = []
    
    var selectedMode: String = ""
    var selectedReason: String = ""
    var comment: String = ""
    
    var selectedSpecialRequest: String = ""
    
    weak var delegate: BookingReviewCancellationVMDelegate?
    
    func isUserDataVerified(showMessage: Bool) -> Bool {
        var flag = true
        
        if self.currentUsingAs == .specialRequest {
            if selectedSpecialRequest.isEmpty || selectedSpecialRequest.lowercased() == LocalizedString.Select.localized.lowercased() {
                flag = false
                if showMessage {
                    AppToast.default.showToastMessage(message: "Please select request type.")
                }
            }
            else if comment.isEmpty || comment.lowercased() == LocalizedString.Select.localized.lowercased() {
                flag = false
                if showMessage {
                    AppToast.default.showToastMessage(message: "Please write something about your special request.")
                }
            }
        }
        else {
            if selectedMode.isEmpty || selectedMode.lowercased() == LocalizedString.Select.localized.lowercased() {
                flag = false
                if showMessage {
                    AppToast.default.showToastMessage(message: "Please select refund mode.")
                }
            }
            else if selectedReason.isEmpty || selectedReason.lowercased() == LocalizedString.Select.localized.lowercased() {
                flag = false
                if showMessage {
                    AppToast.default.showToastMessage(message: "Please select a reason for cancellation.")
                }
            }
        }
        
        return flag
    }
    
    func getCancellationRefundModeReasons() {

        var param: JSONDictionary = ["product": "flight", "booking_id": self.legsWithSelection.first?.bookingId ?? ""]
        
        if currentUsingAs == .flightCancellationReview {
            param["product"] = "flight"
            param["booking_id"] = self.legsWithSelection.first?.bookingId ?? ""
        }
        else if currentUsingAs == .hotelCancellationReview {
            param["product"] = "hotel"
            param["booking_id"] = self.selectedRooms.first?.bookingId ?? ""
        }
        
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
                self?.refundModes = [LocalizedString.Select.localized]
                self?.delegate?.getCancellationRefundModeReasonsFail()
            }
        }
    }
    
    
    func getAllHotelSpecialRequest() {
        
        self.delegate?.willGetCancellationRefundModeReasons()
        APICaller.shared.getHotelSpecialRequestAPI() { [weak self](success, error, rquests) in
            
            if success {
                self?.specialRequests = rquests
                self?.specialRequests.insert(LocalizedString.Select.localized, at: 0)
                self?.delegate?.getCancellationRefundModeReasonsSuccess()
            }
            else {
                self?.specialRequests = [LocalizedString.Select.localized]
                self?.delegate?.getCancellationRefundModeReasonsFail()
            }
        }
    }
    
    func makeHotelSpecialRequest() {
        let param: JSONDictionary = ["booking_id": self.bookingId, "category": self.selectedSpecialRequest.lowercased(), "other": self.comment]
        self.delegate?.willMakeCancellationRequest()
        APICaller.shared.makeHotelSpecialRequestAPI(params: param) { (success, error) in
            if success {
                self.delegate?.makeCancellationRequestSuccess(caseData: nil)
            }
            else {
                self.delegate?.makeCancellationRequestFail()
            }
        }
    }
    
    func makeCancellationRequest() {
        
        var param: JSONDictionary = JSONDictionary()
        
        if self.currentUsingAs == .flightCancellationReview {
            
            var allSelected: [String] = []
            for leg in self.legsWithSelection {
                allSelected.append(contentsOf: leg.selectedPaxs.map { $0.paxId })
            }
            
            param["booking_id"] = self.legsWithSelection.first?.bookingId ?? ""
            param["refund_mode"] = self.selectedMode
            param["reason"] = self.selectedReason
            param["cancel"] = allSelected
            if !self.comment.isEmpty {
              param["comments"] = self.comment
            }
        
        }
        else if self.currentUsingAs == .hotelCancellationReview {

            let allSelected: [String] = self.selectedRooms.map { $0.rid }
            
            param["booking_id"] = self.selectedRooms.first?.bookingId ?? ""
            param["refund_mode"] = self.selectedMode
            param["reason"] = self.selectedReason
            param["cancel"] = allSelected
            param["comments"] = self.comment
            param["totalNetRef"] = self.totRefundForHotel
        }
        
        self.delegate?.willMakeCancellationRequest()
        APICaller.shared.cancellationRequestAPI(params: param) { [weak self](success, error, caseData) in

            if success {
                self?.delegate?.makeCancellationRequestSuccess(caseData: caseData)
            }
            else {
                self?.delegate?.makeCancellationRequestFail()
            }
        }
    }
}
