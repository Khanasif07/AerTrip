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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roomSegmentedControl: UISegmentedControl!
    
    // MARK: - Variables
    
    let cellIdentifier = "RoomTableViewCell"
    let amentiesDetails: [ATAmenity] = ATAmenity.allCases
    let meal: [ATMeal] = ATMeal.allCases
    
    let cancellationPolicy: [ATCancellationPolicy] = ATCancellationPolicy.allCases
    
    let others: [ATOthers] = ATOthers.allCases
    
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
        roomSegmentedControl.selectedSegmentIndex = 0
        roomSegmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        roomSegmentedControl.setWidth(95, forSegmentAt: 0)
        roomSegmentedControl.setWidth(95, forSegmentAt: 2)
        tableView.reloadData()
        if #available(iOS 13.0, *) {
            roomSegmentedControl.backgroundColor = AppColors.themeWhite
            roomSegmentedControl.selectedSegmentTintColor = AppColors.themeGreen
            
            roomSegmentedControl.apportionsSegmentWidthsByContent = true
            roomSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColors.themeWhite], for: UIControl.State.selected)
            
            let font: [AnyHashable : Any] = [NSAttributedString.Key.font : AppFonts.SemiBold.withSize(14)]
            roomSegmentedControl.setTitleTextAttributes(font as? [NSAttributedString.Key : Any], for: .normal)
            roomSegmentedControl.layer.borderColor = AppColors.themeGreen.cgColor
            roomSegmentedControl.layer.borderWidth = 1.0
            roomSegmentedControl.layer.cornerRadius = 4.0
            roomSegmentedControl.layer.masksToBounds = true
            
            roomSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColors.themeGreen], for: UIControl.State.normal)
            roomSegmentedControl.setBacgroundColor()
        } else {
            // Fallback on earlier versions
        }
        updateSegmentControlTitle()
    }
    
    private func registerXib() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            printDebug("Meal tapped")
            roomType = .meal
        case 1:
            printDebug("cancellation policy tapped")
            roomType = .cancellationPolicy
        case 2:
            printDebug("Others")
            roomType = .others
        default:
            printDebug("Tapped")
        }
        tableView.reloadData()
    }
    
    private func updateSegmentControlTitle() {
        
        var title = LocalizedString.Meal.localized
        if !HotelFilterVM.shared.roomMeal.isEmpty {
            title += "●"
        }
        roomSegmentedControl.setTitle(title, forSegmentAt: 0)

        title = LocalizedString.cancellationPolicy.localized        
        if !HotelFilterVM.shared.roomCancelation.isEmpty {
            title += "●"
        }
        roomSegmentedControl.setTitle(title, forSegmentAt: 1)
        
        title = LocalizedString.Others.localized
        if !HotelFilterVM.shared.roomOther.isEmpty {
            title += "●"
        }
        roomSegmentedControl.setTitle(title, forSegmentAt: 2)

        
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
            cell.meal = meal[indexPath.row]
            cell.statusButton.isSelected = HotelFilterVM.shared.roomMeal.contains(meal[indexPath.row].title)
        case .cancellationPolicy:
            cell.cancellationPolicy = cancellationPolicy[indexPath.row]
            cell.statusButton.isSelected = HotelFilterVM.shared.roomCancelation.contains(cancellationPolicy[indexPath.row].title)
        case .others:
            cell.others = others[indexPath.row]
            cell.statusButton.isSelected = HotelFilterVM.shared.roomOther.contains(others[indexPath.row].title)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch roomType {
        case .meal:
            if HotelFilterVM.shared.roomMeal.contains(meal[indexPath.row].title) {
                HotelFilterVM.shared.roomMeal.remove(at: HotelFilterVM.shared.roomMeal.firstIndex(of: meal[indexPath.row].title)!)
            } else {
                HotelFilterVM.shared.roomMeal.append(meal[indexPath.row].title)
            }
            
            if HotelFilterVM.shared.roomMeal.isEmpty {
                HotelFilterVM.shared.roomMeal = HotelFilterVM.shared.defaultRoomMeal
            }
            
        case .cancellationPolicy:
            if HotelFilterVM.shared.roomCancelation.contains(cancellationPolicy[indexPath.row].title) {
                HotelFilterVM.shared.roomCancelation.remove(at: HotelFilterVM.shared.roomCancelation.firstIndex(of: cancellationPolicy[indexPath.row].title)!)
            } else {
                HotelFilterVM.shared.roomCancelation.append(cancellationPolicy[indexPath.row].title)
            }
            
            if HotelFilterVM.shared.roomCancelation.isEmpty {
                HotelFilterVM.shared.roomCancelation = HotelFilterVM.shared.defaultRoomCancelation
            }
            
        case .others:
            if HotelFilterVM.shared.roomOther.contains(others[indexPath.row].title) {
                HotelFilterVM.shared.roomOther.remove(at: HotelFilterVM.shared.roomOther.firstIndex(of: others[indexPath.row].title)!)
            } else {
                HotelFilterVM.shared.roomOther.append(others[indexPath.row].title)
            }
        }
        self.tableView.reloadData()
        updateSegmentControlTitle()
    }
}
