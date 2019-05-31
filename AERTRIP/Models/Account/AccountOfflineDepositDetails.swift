//
//  AccountOfflineDepositDetails.swift
//  AERTRIP
//
//  Created by Admin on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

struct AccountOfflineDepositDetails {
    var depositAmount: Double = 0.0
    var aertripBank: String = ""
    var depositDate: Date?
    var ddNum: String = ""
    var depositBranchDetail = ""
    var userBank: String = ""
    var userAccountName: String = ""
    var userAccountNum: String = ""
    var additionalNote: String = ""
    var uploadedSlips: [String] = []
    var isAgreeToTerms: Bool = false
    
    var transferType: String = ""
    var utrCode: String = ""
    
    var depositDateStr: String {
        return depositDate?.toString(dateFormat: "YYYY-MM-dd") ?? ""
    }
    
    var isForFundTransfer: Bool = false
    
    var isDataVarified: Bool {
        var flag = true
        
        if depositAmount <= 0.0 {
            flag = false
            AppToast.default.showToastMessage(message: "Please enter some amount to deposit.")
        }
        else if aertripBank.removeAllWhitespaces.isEmpty {
            flag = false
            AppToast.default.showToastMessage(message: "Please select aertrip bank.")
        }
        else if depositDate == nil {
            flag = false
            AppToast.default.showToastMessage(message: "Please select deposit date.")
        }
        else if isForFundTransfer, transferType.removeAllWhitespaces.isEmpty {
            flag = false
            AppToast.default.showToastMessage(message: "Please select transfer type.")
        }
        else if isForFundTransfer, utrCode.removeAllWhitespaces.isEmpty {
            flag = false
            AppToast.default.showToastMessage(message: "Please enter UTR code.")
        }
        else if !isForFundTransfer, ddNum.removeAllWhitespaces.isEmpty {
            flag = false
            AppToast.default.showToastMessage(message: "Please enter draft/cheque number.")
        }
        else if !isForFundTransfer, depositBranchDetail.removeAllWhitespaces.isEmpty {
            flag = false
            AppToast.default.showToastMessage(message: "Please enter deposit branch detail.")
        }
        else if userBank.removeAllWhitespaces.isEmpty {
            flag = false
            AppToast.default.showToastMessage(message: "Please select your bank name.")
        }
        else if userAccountName.removeAllWhitespaces.isEmpty {
            flag = false
            AppToast.default.showToastMessage(message: "Please enter your account name.")
        }
        else if userAccountNum.removeAllWhitespaces.isEmpty {
            flag = false
            AppToast.default.showToastMessage(message: "Please enter your account number.")
        }
        else if uploadedSlips.isEmpty {
            flag = false
            AppToast.default.showToastMessage(message: "Please upload some slips as proof.")
        }
        else if !isAgreeToTerms {
            flag = false
            AppToast.default.showToastMessage(message: "Please indicate that you understand and agree to the rules and terms.")
        }
        
        return flag
    }
}