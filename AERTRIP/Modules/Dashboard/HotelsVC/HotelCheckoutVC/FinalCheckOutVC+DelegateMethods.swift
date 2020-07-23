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
        self.isWallet = (getWalletAmount() <= 0) ? false : isOn
        self.setConvenienceFeeToBeApplied()
        self.updatePayButtonText()
    }
}


extension FinalCheckOutVC : ApplyCouponTableViewCellDelegate {
    func removeCouponTapped() {
        printDebug("Remove coupon tapped")
        self.viewModel.removeCouponCode()
    }
}

extension FinalCheckOutVC : HotelFareTableViewCellDelegate {
    func headerViewTapped(_ view: HotelFareTableViewCell) {
        printDebug("Header View Tapped")
        if self.isCouponApplied {
            if self.isCouponSectionExpanded {
                  self.isCouponSectionExpanded = false
            } else {
                self.isCouponSectionExpanded = true
            }
            self.checkOutTableView.reloadRow(at: IndexPath(row: 0, section: 1), with: .automatic)
        }
    }
}


