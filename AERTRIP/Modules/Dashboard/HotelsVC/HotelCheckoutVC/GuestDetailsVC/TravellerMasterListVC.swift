//
//  TravellerMasterListVC.swift
//  AERTRIP
//
//  Created by Admin on 10/05/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

class TravellerMasterListVC: BaseVC {

    @IBOutlet weak var travellerTable: UITableView!
    
    var viewModel = TravellerMasterListVM()
    

    lazy var noResultEmptyView: EmptyScreenView = {
        let newEmptyView = EmptyScreenView()
        newEmptyView.vType = .noResult
        return newEmptyView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.createDataSource()
        self.registerXib()
        self.travellerTable.backgroundColor = AppColors.themeGray04
        travellerTable.delegate = self
        travellerTable.dataSource = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.noResultEmptyView.layoutSubviews()
    }
    
    override func dataChanged(_ note: Notification) {
        if let obj = note.object as? HCSelectGuestsVM.Notification {
             if obj == .selectionChanged {
                self.travellerTable.reloadData()
            }
            else if obj == .searchDone {
                let searchText = HCSelectGuestsVM.shared.searchText.lowercased()
                if searchText.isEmpty{
                    self.viewModel.createDataSource()
                }else{
                    let travellers = GuestDetailsVM.shared.travellerList.filter{$0.firstLastName.lowercased().contains(searchText)}
                    self.viewModel.createDataSource(with: travellers)
                    if self.viewModel.tableSectionArray.count == 1{
                        self.noResultEmptyView.messageLabel.isHidden = false
                        self.noResultEmptyView.messageLabel.text = "\(LocalizedString.noResults.localized + " " + LocalizedString.For.localized) '\(searchText)'"
                        self.noResultEmptyView.messageLabel.numberOfLines = 0
                        self.travellerTable.backgroundView = self.noResultEmptyView
                    }else{
                        self.travellerTable.backgroundView = nil
                    }
                }
                self.travellerTable.reloadData()
            }
        }
    }
    
    
    func registerXib() {
        travellerTable.register(UINib(nibName: "TravellerListTableViewSectionView", bundle: nil), forHeaderFooterViewReuseIdentifier: "tableViewHeaderCellIdentifier")
        self.travellerTable.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        self.travellerTable.registerCell(nibName: TravellerMasterListCell.reusableIdentifier)
    }
   

}

extension TravellerMasterListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.tableSectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((self.viewModel.tableSectionArray.count - 1) != section){
            return self.viewModel.tableDataArray[section].count
        }else{
            return self.viewModel.tableDataArray[section].count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != self.viewModel.tableDataArray[indexPath.section].count{
            return 50.0
        }else{
            return 35.0
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (self.viewModel.tableSectionArray[section].isEmpty) ? .leastNormalMagnitude : 30
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != self.viewModel.tableDataArray[indexPath.section].count{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TravellerMasterListCell.reusableIdentifier) as? TravellerMasterListCell else {
                return UITableViewCell()
            }
            cell.showSalutationImage = true
            cell.contact = self.viewModel.tableDataArray[indexPath.section][indexPath.row].contact
            cell.dividerView.isHidden = indexPath.row == (self.viewModel.tableDataArray[indexPath.section].count - 1)
            cell.selectionButton.isSelected = HCSelectGuestsVM.shared.selectedTravellerContacts.contains(where: { (contact) -> Bool in
                contact.id == self.viewModel.tableDataArray[indexPath.section][indexPath.row].contact.id
            })
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIdentifier) as? EmptyTableViewCell else {
                return UITableViewCell()
            }
            cell.bottomDividerView.isHidden = true
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "tableViewHeaderCellIdentifier") as? TravellerListTableViewSectionView, !(self.viewModel.tableSectionArray[section].isEmpty) else {
            return nil
        }
        headerView.configureCell(self.viewModel.tableSectionArray[section])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != self.viewModel.tableDataArray[indexPath.section].count{
            self.updateSelectedContact(with: self.viewModel.tableDataArray[indexPath.section][indexPath.row])
        }
    }
    
    
    func updateSelectedContact(with traveller: TravellerModel){
        let travellerVM = HCSelectGuestsVM.shared
        if let oIndex = travellerVM.originalIndex(forContact: traveller.contact, forType: .travellers) {

            if let index = travellerVM.selectedTravellerContacts.firstIndex(where: { (contact) -> Bool in
                contact.id == traveller.contact.id
            }) {
                travellerVM.selectedTravellerContacts.remove(at: index)
                if let index = travellerVM.travellerContacts.firstIndex(where: {$0.id == traveller.contact.id}){
                    travellerVM.remove(atIndex: index, for: .travellers)
                }
            }
            else if travellerVM.totalGuestCount > travellerVM.allSelectedCount {
                travellerVM.selectedTravellerContacts.append(traveller.contact)
                travellerVM.add(atIndex: oIndex, for: .travellers)
            } else {
                travellerVM.selectedTravellerContacts.append(traveller.contact)
                travellerVM.update(atIndex: oIndex, for: .travellers)
            }
        }
        self.travellerTable.reloadData()
        
    }

}
