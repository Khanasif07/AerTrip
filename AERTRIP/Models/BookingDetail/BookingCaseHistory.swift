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
    var csrName: String = ""
    var associatedBid: String = ""
    var associatedVouchersStr: String = ""
    var referenceCaseId: String = ""
    var note: String = ""
    var communications: [Communication] = []
    
    var associatedVouchersArr: [String] {
        return associatedVouchersStr.components(separatedBy: ",")
    }
    
    init(json: JSONDictionary) {
        if let obj = json["case_type"] { self.caseType = "\(obj)" }
        
        if let obj = json["case_id"] { self.caseId = "\(obj)" }
        
        if let obj = json["resolution_status_id"] { self.resolutionStatusId = "\(obj)" }
        
        if let obj = json["associated_bid"] { self.associatedBid = "\(obj)" }
        
        if let obj = json["associated_vouchers"] { self.associatedVouchersStr = "\(obj)" }
        
        if let obj = json["reference_case_id"] { self.referenceCaseId = "\(obj)" }
        
        if let obj = json["note"] { self.note = "\(obj)" }
        
        //TODO:-
        self.csrName = LocalizedString.dash.localized
        if let obj = json["csr_name"] {
            self.csrName = "\(obj)"
        }
        
        if let obj = json["communications"] as? [JSONDictionary] {
            self.communications = Communication.models(jsonArr: obj)
        }
    }
}
