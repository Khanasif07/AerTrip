//
//  SortVC.swift
//  AERTRIP
//
//  Created by apple on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class SortVC: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Variables
    
    let cellIdentifier = "SortTableViewCell"
    private let titles: [String] = [LocalizedString.BestSellers.localized, LocalizedString.Price.localized, LocalizedString.TripAdvisor.localized, LocalizedString.StarRating.localized, LocalizedString.Distance.localized]
    private let subTitles: [String] = [LocalizedString.Recommended.localized, LocalizedString.LowToHigh.localized, LocalizedString.FiveToOne.localized, LocalizedString.FiveToOne.localized, LocalizedString.NearestFirst.localized]
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doInitialSetup()
        registerXib()
    }
    
    // MARK: - Helper methods
    
    func registerXib() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func doInitialSetup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
}

// MARK: - UITableViewCellDataSource and UITableViewCellDelegateMethods

extension SortVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SortTableViewCell else {
            return UITableViewCell()
        }
        cell.tintColor = AppColors.themeGreen
        if indexPath.row == 0 && HotelFilterVM.shared.sortUsing == .BestSellers {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.bottom)
        } else if indexPath.row == 1 && HotelFilterVM.shared.sortUsing == .PriceLowToHigh {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.bottom)
        } else if indexPath.row == 2 && HotelFilterVM.shared.sortUsing == .TripAdvisorRatingHighToLow  {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.bottom)
            
        } else if indexPath.row == 3 && HotelFilterVM.shared.sortUsing == .StartRatingHighToLow  {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.bottom)
        } else if indexPath.row == 4 && HotelFilterVM.shared.sortUsing == .DistanceNearestFirst  {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.bottom)
        } else {
            cell.accessoryType = .none
        }
        cell.leftTitleLabel.textColor = indexPath.row == 0 ? AppColors.themeGreen : AppColors.textFieldTextColor51
        cell.configureCell(leftTitle: titles[indexPath.row], rightTitle: subTitles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.tintColor = AppColors.themeGreen
            cell.accessoryType = .checkmark
            switch indexPath.row {
            case 0:
                HotelFilterVM.shared.sortUsing = .BestSellers
            case 1:
                HotelFilterVM.shared.sortUsing = .PriceLowToHigh
            case 2:
                HotelFilterVM.shared.sortUsing = .TripAdvisorRatingHighToLow
            case 3:
                HotelFilterVM.shared.sortUsing = .StartRatingHighToLow
            case 4:
                HotelFilterVM.shared.sortUsing = .DistanceNearestFirst
            default:
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
}
