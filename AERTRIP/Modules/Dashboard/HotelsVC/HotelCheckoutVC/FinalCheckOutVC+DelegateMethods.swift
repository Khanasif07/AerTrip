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
        
    }
}


extension FinalCheckOutVC : ApplyCouponTableViewCellDelegate {
    func removeCouponTapped() {
        printDebug("Remove coupon tapped")
        self.viewModel.removeCouponCode()
    }
}

extension FinalCheckOutVC : FareSectionHeaderDelegate {
    func headerViewTapped(_ view: UITableViewHeaderFooterView) {
        printDebug("Header View Tapped")
        if self.isCouponApplied {
            if self.isCouponSectionExpanded {
                  self.isCouponSectionExpanded = false
            } else {
                self.isCouponSectionExpanded = true
            }
          self.checkOutTableView.reloadData()
        }
    }
}


