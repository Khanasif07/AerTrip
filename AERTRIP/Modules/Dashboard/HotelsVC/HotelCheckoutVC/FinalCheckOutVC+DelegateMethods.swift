//
//  FinalCheckOutVC+DelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 01/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension FinalCheckOutVC : WalletTableViewCellDelegate {
    func valueForSwitch(isOn: Bool) {
        self.isWallet = isOn
        self.setConvenienceFeeToBeApplied()
        delay(seconds: 0.3) { [weak self] in
            self?.updateAllData()
        }
    }
}


extension FinalCheckOutVC : ApplyCouponTableViewCellDelegate {
    func removeCouponTapped() {
        printDebug("Remove coupon tapped")
        self.viewModel.removeCouponCode()
    }
}

extension FinalCheckOutVC : FareSectionHeaderDelegate {
    func headerViewTapped() {
        printDebug("Header View Tapped")
    }
}


