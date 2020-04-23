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


extension HCDataSelectionVC : HCEmailTextFieldCellDelegate, HCPanCardTextFieldCellDelegate {
    func textEditableTableViewCellTextFieldText(_ indexPath: IndexPath, _ text: String) {
        let newRow = indexPath.row - hotelFormData.adultsCount.count
        if newRow == 5 {
        self.viewModel.email = text
        } else if newRow == 8 {
            self.viewModel.panCard = text
        }
    }
}
