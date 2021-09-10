//
//  BookingRequest.swift
//  AERTRIP
//
//  Created by Admin on 25/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct BookingCaseHistory {
    
    struct Communication {
        var subject: String = ""
        var userType: String = ""
        var billingName: String = ""
        var membershipNo: String = ""
        var commHash: String = ""
        var commDate: Date?
        var templateId: String = ""
        var isEmailLoading: Bool = false
        
        init(json: JSONDictionary) {
            if let obj = json["subject"] {
                self.subject = "\(obj)"
            }
            
            if let obj = json["user_type"] { self.userType = "\(obj)" }
            
            if let obj = json["billing_name"] { self.billingName = "\(obj)" }
            
            if let obj = json["membership_no"] { self.membershipNo = "\(obj)" }
            
            if let obj = json["comm_hash"] { self.commHash = "\(obj)" }
            
            //"Fri, 21 Jun 2019 | 21:45"
            if let obj = json["comm_date"] { self.commDate = "\(obj)".toDate(dateFormat: "EEE, dd MMM yyyy | HH:mm") }
            
            if let obj = json["template_id"] { self.templateId = "\(obj)" }
            
            if let obj = json["comm_hash"] { self.commHash = "\(obj)" }
        }
        
        static func models(jsonArr: [JSONDictionary]) -> [Communication] {
            return jsonArr.map { Communication(json: $0) }
        }
    }
    
    var caseType: String = ""
    var caseId: String = ""
    var resolutionStatusId: String = ""
    private var _resolutionStatusStr: String = ""
    var csrName: String = ""
    var associatedBid: String = ""
    var associatedVouchersStr: String = ""
    var referenceCaseId: String = ""
    var note: String = ""
    var communications: [Communication] = []
    var closedDate: Date? 
    var caseName: String = ""
    var caseNumber: String = ""
    var amount: Double = 0.0
    var requestDate: Date?
    
    var associatedVouchersArr: [String] {
        return associatedVouchersStr.components(separatedBy: ",")
    }
    
    var resolutionStatus: ResolutionStatus {
        get {
            return ResolutionStatus(rawValue: self._resolutionStatusStr) ?? ResolutionStatus.closed
        }
        
        set {
            self._resolutionStatusStr = newValue.rawValue
        }
    }
    
    init(json: JSONDictionary) {
        if let obj = json["case_type"] { self.caseType = "\(obj)" }
        
        if let obj = json["case_id"] { self.caseId = "\(obj)" }
        
        if let obj = json["resolution_status_id"] { self.resolutionStatusId = "\(obj)" }
        
        if let obj = json["resolution_status"] { self._resolutionStatusStr = "\(obj)" }
        
        if let obj = json["associated_bid"] { self.associatedBid = "\(obj)" }
        
        if let obj = json["associated_vouchers"] { self.associatedVouchersStr = "\(obj)" }
        
        if let obj = json["reference_case_id"] { self.referenceCaseId = "\(obj)" }
        
        if let obj = json["note"] { self.note = "\(obj)" }
        
        //TODO:-
        self.csrName = LocalizedString.dash.localized
        if let obj = json["csr_name"] {
            self.csrName = "\(obj)"
        }
        
        if let obj = json["closed_date"] {
            self.closedDate = "\(obj)".toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        if let obj = json["communications"] as? [JSONDictionary] {
            self.communications = Communication.models(jsonArr: obj)
        }
        
        if let obj = json["case_name"] {
            self.caseName = "\(obj)"
        }
        
        if let obj = json["case_number"] {
            self.caseNumber = "\(obj)"
        }
        
        if let obj = json["payment_required"] {
            self.amount = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["request_date"] {
            // "2019-06-07 18:36:38"
            self.requestDate = "\(obj)".toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
    }
}
