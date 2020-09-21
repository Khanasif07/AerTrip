//
//  AccountChargeInfoVM.swift
//  AERTRIP
//
//  Created by Admin on 06/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit


class AccountChargeInfoVM {
    
    enum UsingFor {
        case chargeInfo
        case offlinePaymentSteps
    }
    
    //MARK:- Properties
    //MARK:- Public
    var currentUsingFor = UsingFor.chargeInfo

    private let statementTitles: [String] = [
                            "Opening Balance",
                            "Recent Transactions",
                            "Total Outstanding",
                            "Current Balance",
                            "Available Credits",
                            "Total Amount Due"
                           ]
    
    private let statementDescription: [String] = [
                            "Outstanding balance as per your last statement.",
                            "The total amount of all your payments, credits, purchases and charges incurred since your last statement.",
                            "This is your last Statement balance less any recent payments and credits that have been received plus any charges which have been applied to your Account since your last statement.",
                            "This is your last Statement balance less any recent payments and credits that have been received plus any charges which have been applied to your Account since your last statement.",
                            "It includes your total credit limit minus all billed, unbilled & pending charges. This amount is updated real time.",
                            "This is how much you need to pay by the due date which includes your last statement balance minus recent payments & credits."
                           ]
    
    private let billWiseTitles: [String] = [
        "Total Outstanding",
        "Available Credits"
    ]
    
    private let billWiseDescription: [String] = [
        "This includes all your puchases and charges which have been applied to your Account less any recent payments and credits that have been received.",
        "It includes your total credit limit minus all billed, unbilled & pending charges. This amount is updated real time."
    ]
    
    private let offlineDepositTitles: [String] = [
        "Step 1",
        "Step 2",
        "Step 3",
        "Step 4",
        "Step 5"
    ]
    
    private let offlineDepositDescription: [String] = [
        "Select preferred Aertrip Bank for deposit",
        "Download blank Cheque / DD deposit slip for printing",
        "Deposit via Cheque / DD / RTGS / NEFT / IMPS / Fund Transfer in our Bank Account",
        "Fill in all of the details in the form and Register Payment",
        "Upload a copy of the deposit confirmation slip"
    ]
    
    
    var titles: [String] = []
    var description: [String] = []
    
    //MARK:- Private
    func fetchData() {
        if self.currentUsingFor == .chargeInfo, let user = UserInfo.loggedInUser {
            titles = (user.userCreditType == UserCreditType.billwise) ? self.billWiseTitles : self.statementTitles
            description = (user.userCreditType == UserCreditType.billwise) ? self.billWiseDescription : self.statementDescription
        }
        else if self.currentUsingFor == .offlinePaymentSteps {
            titles = offlineDepositTitles
            description = offlineDepositDescription
        }
    }
    
    
    //MARK:- Methods
    //MARK:- Private

    //MARK:- Public
}
