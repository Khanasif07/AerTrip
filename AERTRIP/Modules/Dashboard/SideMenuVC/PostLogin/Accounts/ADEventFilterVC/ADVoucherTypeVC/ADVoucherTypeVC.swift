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
    
    //MARK:- Private
    private let cellIdentifier = "RoomTableViewCell"
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        registerXib()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func registerXib() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
}

//MARK:- Action
extension ADVoucherTypeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ADEventFilterVM.shared.voucherTypes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RoomTableViewCell else {
            printDebug("RoomTableViewCell not found")
            return UITableViewCell()
        }
        cell.configCell(title: ADEventFilterVM.shared.voucherTypes[indexPath.row])
        cell.dividerView.isHidden = indexPath.row != 0
        
        if ADEventFilterVM.shared.selectedVoucherType.isEmpty || ADEventFilterVM.shared.selectedVoucherType.count ==  ADEventFilterVM.shared.voucherTypes.count - 1{
            cell.statusButton.isSelected = true

        } else {
            cell.statusButton.isSelected = ADEventFilterVM.shared.selectedVoucherType.contains(ADEventFilterVM.shared.voucherTypes[indexPath.row])
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if ADEventFilterVM.shared.selectedVoucherType.contains(ADEventFilterVM.shared.voucherTypes[indexPath.row]) {
                ADEventFilterVM.shared.selectedVoucherType = []
            } else {
                ADEventFilterVM.shared.selectedVoucherType = ADEventFilterVM.shared.voucherTypes
            }
        } else {
            if ADEventFilterVM.shared.selectedVoucherType.contains(ADEventFilterVM.shared.voucherTypes[indexPath.row]) {
                ADEventFilterVM.shared.selectedVoucherType.remove(object: LocalizedString.ALL.localized)
                ADEventFilterVM.shared.selectedVoucherType.remove(object: ADEventFilterVM.shared.voucherTypes[indexPath.row])
            } else {
                ADEventFilterVM.shared.selectedVoucherType.append(ADEventFilterVM.shared.voucherTypes[indexPath.row])
            }
        }
        self.delegate?.didSelect()
        tableView.reloadData()
    }
    
}

