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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.createDataSource()
        self.registerXib()
        travellerTable.delegate = self
        travellerTable.dataSource = self
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
        return self.viewModel.tableDataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TravellerMasterListCell.reusableIdentifier) as? TravellerMasterListCell else {
            return UITableViewCell()
        }
        cell.showSalutationImage = true
        cell.contact = self.viewModel.tableDataArray[indexPath.section][indexPath.row].contact
        cell.dividerView.isHidden = indexPath.row == (self.viewModel.tableDataArray[indexPath.section].count - 1)
        cell.selectionButton.isSelected = self.viewModel.selectedTraveller.contains(where: { (traveller) -> Bool in
            traveller.contact.id == self.viewModel.tableDataArray[indexPath.section][indexPath.row].contact.id
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "tableViewHeaderCellIdentifier") as? TravellerListTableViewSectionView else {
            return nil
        }
        headerView.configureCell(self.viewModel.tableSectionArray[section])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}
