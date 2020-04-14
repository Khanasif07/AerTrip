//
//  RequestReschedulingVC+Extensions.swift
//  AERTRIP
//
//  Created by Admin on 05/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

extension RequestReschedulingVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.legsWithSelection.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < self.viewModel.legsWithSelection.count {
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < (self.viewModel.legsWithSelection.count - 1) {
            return 35.0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section < (self.viewModel.legsWithSelection.count - 1) {
            return getEmptyTableCell(tableView).contentView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section < self.viewModel.legsWithSelection.count {
            switch indexPath.row {
            case 0:
                //flightDetailsCell
                return getFlightDetailsCell(tableView, indexPath: indexPath)
            case 1:
                //selectDateCell
                return getSelectDateTableViewCell(tableView, indexPath: indexPath)
            case 2:
                //preferredFlightNoCell
                return getPreferredFlightNoCell(tableView, indexPath: indexPath)
            default: return UITableViewCell()
            }
        }
        else {
            //other details
            switch indexPath.row {
            case 0:
                //customerExecutiveCell
                return getCustomerContactCellTableViewCell(tableView, indexPath: indexPath)
            case 1:
                //totalNetRefundCell
                return getTotalRefundCell(tableView, indexPath: indexPath)
                
            default: return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow(tableView, indexPath: indexPath)
    }
}

extension RequestReschedulingVC: BookingTopNavBarWithSubtitleDelegate {
    
    func leftButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension RequestReschedulingVC: HCSpecialRequestTextfieldCellDelegate {
    func didPassSpecialRequestAndAirLineText(infoText: String, textField: UITextField) {
        guard let cell = textField.tableViewCell, let indexPath = self.reschedulingTableView.indexPath(for: cell) else {return}
        self.viewModel.legsWithSelection[indexPath.section].prefredFlightNo = infoText
    }
}

extension RequestReschedulingVC: SelectDateTableViewCellDelegate {
    func didSelect(_ sender: SelectDateTableViewCell, date: Date?) {
        guard let indexPath = self.reschedulingTableView.indexPath(for: sender) else{return}
        self.viewModel.legsWithSelection[indexPath.section].rescheduledDate = date
        self.updateReturnMinimumDate(indexPath: indexPath, date: date)
    }
    
    func updateReturnMinimumDate(indexPath: IndexPath, date:Date?){
        
        if self.viewModel.legsWithSelection.count > 1 && indexPath.section == 0{
            let nextIndexPath = IndexPath(row: indexPath.row, section: indexPath.section + 1)
            if let cell = self.reschedulingTableView.cellForRow(at: nextIndexPath) as? SelectDateTableViewCell{
                self.reschedulingTableView.beginUpdates()
                cell.minimumDate = date ?? Date()
                if let returnDate = self.viewModel.legsWithSelection[1].rescheduledDate, (returnDate < (date ?? Date())){
                    self.viewModel.legsWithSelection[1].rescheduledDate = nil
                    cell.selectDateTextField.text = LocalizedString.Select.localized
                }
                self.reschedulingTableView.endUpdates()
            }
        }
    }
}


extension RequestReschedulingVC: RequestReschedulingVMDelegate {
    func willMakeRequestForRescheduling() {
        self.requestReschedulingBtnOutlet.isLoading = true
    }
    
    func makeRequestForReschedulingSuccess() {
        self.requestReschedulingBtnOutlet.isLoading = false
        AppFlowManager.default.showReschedulingRequest(buttonTitle: LocalizedString.RequestRescheduling.localized, delegate: self)
    }
    
    func makeRequestForReschedulingFail() {
        self.requestReschedulingBtnOutlet.isLoading = false
        AppToast.default.showToastMessage(message: LocalizedString.SomethingWentWrong.localized)
    }
}

extension RequestReschedulingVC: BulkEnquirySuccessfulVCDelegate{
    func doneButtonAction() {
        self.navigationController?.dismiss(animated: true, completion: {
            self.sendDataChangedNotification(data: ATNotification.myBookingCasesRequestStatusChanged)
        })
    }
}
