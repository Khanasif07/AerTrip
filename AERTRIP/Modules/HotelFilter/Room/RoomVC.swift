//
//  RoomVC.swift
//  AERTRIP
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class RoomVC: UIViewController {
    
    // MARK: -  IB Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roomSegmentedControl: UISegmentedControl!
    
    // MARK: - Variables
    let cellIdentifier = "RoomTableViewCell"
    let meal : [(title:String,status:Int)] = [(title:LocalizedString.NoMeal.localized,status:0),(title:LocalizedString.Breakfast.localized,status:0),(title:LocalizedString.HalfBoard.localized,status:0),(title:LocalizedString.FullBoard.localized,status:0),(title:LocalizedString.Others.localized,status:0)]
    
    let cancellationPolicy : [(title:String,status:Int)] = [(title:LocalizedString.Refundable.localized,status:0),(title:LocalizedString.PartRefundable.localized,status:0),(title:LocalizedString.NonRefundable.localized,status:0)]
    
    let others : [(title:String,status:Int)] = [(title:LocalizedString.FreeWifi.localized ,status:0),(title:LocalizedString.TransferInclusive.localized ,status:0)]
    
    var tableData : [(title:String,status:Int)] = []
    
    
    
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doInitialSetUp()
        registerXib()
    }
    
    
    // MARK: - Helper methods
    
    private func doInitialSetUp() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
         roomSegmentedControl.addTarget(self, action: #selector(self.indexChanged(_:)), for: .valueChanged)
        tableData = meal
        self.tableView.reloadData()
    }
    
    private func registerXib() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            printDebug("Meal tapped")
            tableData = meal
        case 1:
               printDebug("cancellation policy tapped")
            tableData = cancellationPolicy
        case 2:
               printDebug("Others")
            tableData = others
        default:
            printDebug("Tapped")
        }
        self.tableView.reloadData()
    }

    

}


// MARK : - UITableViewDataSource

extension RoomVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RoomTableViewCell else {
            printDebug("RoomTableViewCell not found")
            return UITableViewCell()
        }
        cell.room  = tableData[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    
}
