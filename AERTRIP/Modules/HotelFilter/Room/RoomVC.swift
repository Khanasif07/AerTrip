//
//  RoomVC.swift
//  AERTRIP
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

enum RoomType {
    case meal
    case cancellationPolicy
    case others
}

class RoomVC: UIViewController {
    // MARK: -  IB Outlet
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var roomSegmentedControl: UISegmentedControl!
    
    // MARK: - Variables
    
    let cellIdentifier = "RoomTableViewCell"
    let meal: [(title: String, id: Int)] = [(title: LocalizedString.NoMeal.localized, id: 1), (title: LocalizedString.Breakfast.localized, id: 2), (title: LocalizedString.HalfBoard.localized, id: 3), (title: LocalizedString.FullBoard.localized, id: 4), (title: LocalizedString.Others.localized, id: 5)]
    
    let cancellationPolicy: [(title: String, id: Int)] = [(title: LocalizedString.Refundable.localized, id: 1), (title: LocalizedString.PartRefundable.localized, id: 2), (title: LocalizedString.NonRefundable.localized, id: 3)]
    
    let others: [(title: String, id: Int)] = [(title: LocalizedString.FreeWifi.localized, id: 1), (title: LocalizedString.TransferInclusive.localized, id: 2)]
    
    var tableData: [(title: String, id: Int)] = []
    var roomType: RoomType = .meal
    
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
        roomSegmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        tableData = meal
        
        tableView.reloadData()
    }
    
    private func registerXib() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            printDebug("Meal tapped")
            tableData = meal
            roomType = .meal
        case 1:
            printDebug("cancellation policy tapped")
            tableData = cancellationPolicy
            roomType = .cancellationPolicy
        case 2:
            printDebug("Others")
            tableData = others
            roomType = .others
        default:
            printDebug("Tapped")
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension RoomVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch roomType {
        case .meal:
            return meal.count
        case .cancellationPolicy:
            return cancellationPolicy.count
        case .others:
            return others.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? RoomTableViewCell else {
            printDebug("RoomTableViewCell not found")
            return UITableViewCell()
        }
        switch roomType {
        case .meal:
            cell.room = meal[indexPath.row]
            cell.statusButton.isSelected = HotelFilterVM.shared.roomMeal.contains(meal[indexPath.row].id)
        case .cancellationPolicy:
            cell.room = cancellationPolicy[indexPath.row]
             cell.statusButton.isSelected = HotelFilterVM.shared.roomCancelation.contains(cancellationPolicy[indexPath.row].id)
        case .others:
            cell.room = others[indexPath.row]
            cell.statusButton.isSelected = HotelFilterVM.shared.roomOther.contains(others[indexPath.row].id)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch roomType {
        case .meal:
            if HotelFilterVM.shared.roomMeal.contains(meal[indexPath.row].id) {
                HotelFilterVM.shared.roomMeal.remove(at: HotelFilterVM.shared.roomMeal.firstIndex(of: meal[indexPath.row].id)!)
            } else {
                HotelFilterVM.shared.roomMeal.append(meal[indexPath.row].id)
            }
            
        case .cancellationPolicy:
            if HotelFilterVM.shared.roomCancelation.contains(cancellationPolicy[indexPath.row].id) {
                HotelFilterVM.shared.roomCancelation.remove(at: HotelFilterVM.shared.roomCancelation.firstIndex(of: cancellationPolicy[indexPath.row].id)!)
            } else {
                HotelFilterVM.shared.roomCancelation.append(cancellationPolicy[indexPath.row].id)
            }
        case .others:
            if HotelFilterVM.shared.roomOther.contains(others[indexPath.row].id) {
                HotelFilterVM.shared.roomOther.remove(at: HotelFilterVM.shared.roomOther.firstIndex(of: others[indexPath.row].id)!)
            } else {
                HotelFilterVM.shared.roomOther.append(others[indexPath.row].id)
            }
            
        }
        self.tableView.reloadData()
    }
}
