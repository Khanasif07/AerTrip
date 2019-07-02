//
//  AccountOfflineDepositVM.swift
//  AERTRIP
//
//  Created by apple on 26/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation


protocol AccountOfflineDepositVMDelegate: class {
    func willRegisterPayment()
    func registerPaymentSuccess()
    func registerPaymentFail()
}

class AccountOfflineDepositVM: NSObject {
    
    var paymentModeDetails: PaymentModeDetails?
    var bankMaster: [String] = []

    var userEnteredDetails: AccountOfflineDepositDetails = AccountOfflineDepositDetails()
    
    weak var delegate: AccountOfflineDepositVMDelegate?
    
    
    func registerPayment(currentUsingAs: AccountOfflineDepositVC.UsingForPayBy) {
        
        var param = JSONDictionary()
        
        if let banks = self.paymentModeDetails?.types, let bank = banks.filter({ $0.bankName.lowercased() == userEnteredDetails.aertripBank.lowercased() }).first {
            param["bank"] = bank.id
        }
        
        param["bank_name"] = userEnteredDetails.aertripBank
        param["payee_bank_name"] = userEnteredDetails.userBank
        param["account_number"] = userEnteredDetails.userAccountNum
        param["account_name"] = userEnteredDetails.userAccountName
        param["draft_cheque_date"] = userEnteredDetails.depositDateStr
        
        if currentUsingAs == .chequeOrDD {
            param["draft_cheque_number"] = userEnteredDetails.ddNum
            param["branch_name"] = userEnteredDetails.depositBranchDetail
        }
        else {
            param["transfer_type"] = userEnteredDetails.transferType
            param["swift_code"] = userEnteredDetails.utrCode
        }
        
        param["type"] = "offline"
        param["payment_method_id"] = paymentModeDetails?.id ?? ""
        param["it_id"] = paymentModeDetails?.itId ?? ""
        param["currency_code"] = UserInfo.loggedInUser?.preferredCurrency ?? ""
        param["total_amount"] = userEnteredDetails.depositAmount
        param["product_type"] = "make-payment"
        
        param["part_payment_amount"] = "0"
        param["use_points"] = "0"
        param["use_wallet"] = "0"
        param["wallet_id"] = ""
        
        param["note"] = userEnteredDetails.additionalNote
        
        self.delegate?.willRegisterPayment()
        APICaller.shared.registerOfflinePaymentAPI(params: param, filePath: userEnteredDetails.uploadedSlips.first ?? "") { [weak self](success, errors) in
            
            guard let sSelf = self else {return}
            if success {
                sSelf.delegate?.registerPaymentSuccess()
            }
            else {
                sSelf.delegate?.registerPaymentFail()
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
            }
        }
    }
}
