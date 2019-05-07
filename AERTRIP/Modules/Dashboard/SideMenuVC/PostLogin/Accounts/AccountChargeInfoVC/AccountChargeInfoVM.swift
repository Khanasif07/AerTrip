//
//  AccountChargeInfoVM.swift
//  AERTRIP
//
//  Created by Admin on 06/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit


class AccountChargeInfoVM {
    //MARK:- Properties
    //MARK:- Public
    private let statementTitles: [String] = [
                            "Opening Balance",
                            "Recent Payments & Credits",
                            "Recent Charges",
                            "Total Outstanding",
                            "Current Balance",
                            "Available Credits",
                            "Total Amount Due"
                           ]
    
    private let statementDescription: [String] = [
                            "Outstanding balance as per your last statement.",
                            "Shows any payments & credits added to your account post your last statement generated.",
                            "The total amount of all your purchases and charges incurred since your last statement.",
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
    
    
    var titles: [String] = []
    var description: [String] = []
    
    //MARK:- Private
    init() {
        if let user = UserInfo.loggedInUser {
            titles = (user.userType == UserInfo.UserType.billWise) ? self.billWiseTitles : self.statementTitles
            description = (user.userType == UserInfo.UserType.billWise) ? self.billWiseDescription : self.statementDescription
        }
    }
    
    
    //MARK:- Methods
    //MARK:- Private

    //MARK:- Public
}
