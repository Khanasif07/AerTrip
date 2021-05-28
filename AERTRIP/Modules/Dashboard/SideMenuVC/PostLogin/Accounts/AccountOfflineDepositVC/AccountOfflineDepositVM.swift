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
    var itineraryData:DepositItinerary?
    var userEnteredDetails: AccountOfflineDepositDetails = AccountOfflineDepositDetails()
    
    weak var delegate: AccountOfflineDepositVMDelegate?
    
    var isPayButtonTapped = false
    
    var currency :String{
        Currencies.getCurrencySymbol(currencyCode: self.itineraryData?.currency ?? "INR")
    }
    
    func registerPayment(currentUsingAs: AccountOfflineDepositVC.UsingForPayBy) {
        
        var param = JSONDictionary()
        
        if let banks = self.paymentModeDetails?.types, let bank = banks.filter({ $0.bankName.lowercased() == userEnteredDetails.aertripBank.lowercased() }).first {
            param["bank"] = bank.id
        }
        
        param["bank_name"] = userEnteredDetails.aertripBank
        param["payee_bank_name"] = userEnteredDetails.userBank
        param["account_number"] = userEnteredDetails.userAccountNum
        param["account_name"] = userEnteredDetails.userAccountName
        
        if currentUsingAs == .chequeOrDD {
            param["draft_cheque_number"] = userEnteredDetails.ddNum
            param["branch_name"] = userEnteredDetails.depositBranchDetail
            param["draft_cheque_date"] = userEnteredDetails.depositDateStr
        }
        else {
            param["transfer_type"] = userEnteredDetails.transferType
            param["utr_number"] = userEnteredDetails.utrCode
            param["deposit_date"] = userEnteredDetails.depositDateStr
        }
        
        param["type"] = "offline"
        param["payment_method_id"] = paymentModeDetails?.id ?? ""
        param["it_id"] = self.itineraryData?.id ?? ""
        param["currency_code"] = UserInfo.preferredCurrencyCode ?? ""
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
