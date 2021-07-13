//
//  ADVoucherTypeVC.swift
//  AERTRIP
//
//  Created by Admin on 22/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol ADVoucherTypeVCDelegate: class {
    func didSelect()
}


class ADVoucherTypeVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var tableView: ATTableView!
    
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: ADVoucherTypeVCDelegate?
    //let viewModel = ADVoucherTypeVM()
    var oldSelection: [String] = []
    
    //MARK:- Private
    private let cellIdentifier = "RoomTableViewCell"
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        setFilterValues()
        registerXib()
        self.tableView.backgroundColor = AppColors.themeWhiteDashboard
        self.view.backgroundColor = AppColors.themeWhiteDashboard
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func registerXib() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    internal func setFilterValues() {
        self.oldSelection = ADEventFilterVM.shared.selectedVoucherType
        self.tableView?.reloadData()
    }
    //MARK:- Public
    
    
    //MARK:- Action
}

//MARK:- Action
extension ADVoucherTypeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : ADEventFilterVM.shared.voucherTypes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RoomTableViewCell else {
                printDebug("RoomTableViewCell not found")
                return UITableViewCell()
            }
            cell.configCell(title: ADEventFilterVM.shared.voucherTypes[indexPath.row])
            cell.dividerView.isHidden = true
            
//            if oldSelection.isEmpty || oldSelection.count ==  ADEventFilterVM.shared.voucherTypes.count - 1{
//                cell.statusButton.isSelected = true
//
//            } else {
                cell.statusButton.isSelected = oldSelection.contains(ADEventFilterVM.shared.voucherTypes[indexPath.row])
//            }
            
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RoomTableViewCell else {
                printDebug("RoomTableViewCell not found")
                return UITableViewCell()
            }
            cell.configCell(title: LocalizedString.ALL.localized)
            cell.dividerView.isHidden = false
            cell.statusButton.isSelected = oldSelection.count == ADEventFilterVM.shared.voucherTypes.count
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            if oldSelection.contains(ADEventFilterVM.shared.voucherTypes[indexPath.row]) {
                oldSelection.remove(object: ADEventFilterVM.shared.voucherTypes[indexPath.row])
            } else {
                oldSelection.append(ADEventFilterVM.shared.voucherTypes[indexPath.row])
            }
            
        } else {
            if  oldSelection.count ==  ADEventFilterVM.shared.voucherTypes.count {
                oldSelection.removeAll()
            } else {
                oldSelection.removeAll()
                oldSelection = ADEventFilterVM.shared.voucherTypes
            }
        }
        ADEventFilterVM.shared.selectedVoucherType = oldSelection
        self.delegate?.didSelect()
        tableView.reloadData()
    }
    
}

