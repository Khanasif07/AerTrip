//
//  SideMenuVM.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 12/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

protocol SideMenuVMDelegate: class {
    
    func willGetAccountSummary()
    func getAccountSummarySuccess()
    func getAccountSummaryFail(errors: ErrorCodes)
    
}

class SideMenuVM {
    
    weak var delegate: SideMenuVMDelegate?
    let displayCellsForGuest = [ LocalizedString.WhyAertrip.localized,
                                 LocalizedString.SmartSort.localized,
                                 LocalizedString.Offers.localized,
                                 LocalizedString.ContactUs.localized,
                                 LocalizedString.Settings.localized]
    let cellForLoginUser = [ LocalizedString.Bookings.localized,
                             LocalizedString.Offers.localized,
                             LocalizedString.Notification.localized,
                             LocalizedString.ReferAndEarn.localized,
                             LocalizedString.Settings.localized,
                             LocalizedString.Support.localized,
                             LocalizedString.RateUs.localized]
    
    func webserviceForGetAccountSummary() {
        delegate?.willGetAccountSummary()
        APICaller.shared.getAccountSummaryAPI(params: [:], completionBlock: { [weak self] ( success, errors) in
            guard let strongSelf = self else {return}
            if success {
                strongSelf.delegate?.getAccountSummarySuccess()
            }
            else {
                strongSelf.delegate?.getAccountSummaryFail(errors: errors)
            }
        })
    }
    
}

