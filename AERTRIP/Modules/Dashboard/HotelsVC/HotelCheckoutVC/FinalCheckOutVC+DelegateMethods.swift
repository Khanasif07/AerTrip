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
        self.checkOutTableView.reloadData()
    }
}
