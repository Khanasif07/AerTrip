//
//  HCDataSelectionVC+DelegateMethods.swift
//  AERTRIP
//
//  Created by apple on 04/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension HCDataSelectionVC : GuestDetailsVCDelegate {
    func doneButtonTapped() {
        self.tableView.reloadData()
    }
    
}
