//
//  AccountCheckoutVC+DelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 01/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

//extension AccountCheckoutVC : WalletTableViewCellDelegate {
//    func valueForSwitch(isOn: Bool) {
//        self.isWallet = (getWalletAmount() <= 0) ? false : isOn
//        self.setConvenienceFeeToBeApplied()
//        
//    }
//}
//
//
//extension AccountCheckoutVC : ApplyCouponTableViewCellDelegate {
//    func removeCouponTapped() {
//        printDebug("Remove coupon tapped")
//        self.viewModel.removeCouponCode()
//    }
//}
//
//extension AccountCheckoutVC : FareSectionHeaderDelegate {
//    func headerViewTapped() {
//        printDebug("Header View Tapped")
//        if self.isCouponApplied {
//            if self.isCouponSectionExpanded {
//                  self.isCouponSectionExpanded = false
//            } else {
//                self.isCouponSectionExpanded = true
//            }
//          self.checkOutTableView.reloadData()
//        }
//    }
//}
//
//
