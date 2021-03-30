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
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    
    let cellIdentifier = "SortTableViewCell"
    
    private let sortTitle : [SortUsing] = [.BestSellers,.PriceLowToHigh(ascending: true),.TripAdvisorRatingHighToLow(ascending: false),.StartRatingHighToLow(ascending: false),.DistanceNearestFirst(ascending: true)]
    private let titles: [String] = [LocalizedString.BestSellers.localized, LocalizedString.Price.localized, LocalizedString.TripAdvisor.localized, LocalizedString.StarRating.localized, LocalizedString.Distance.localized]
    private let subTitles: [String] = [LocalizedString.Recommended.localized, LocalizedString.LowToHigh.localized, LocalizedString.FiveToOne.localized, LocalizedString.FiveToOne.localized, LocalizedString.NearestFirst.localized]
    
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doInitialSetup()
        registerXib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFilterValues()
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
    
    func setFilterValues() {
        tableView?.reloadData()
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
        //        if sortTitle[indexPath.row] == HotelFilterVM.shared.sortUsing {
        //            cell.accessoryView = setCheckBox()
        //            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.bottom)
        //            cell.leftTitleLabel.textColor = AppColors.themeGreen
        //            cell.rightTitleLabel.textColor = AppColors.themeGray40
        //        } else {
        //            cell.accessoryView = nil
        //            cell.leftTitleLabel.textColor = AppColors.themeBlack
        //            cell.rightTitleLabel.textColor = AppColors.themeGray40
        //        }
        
        func setSelectedState() {
            cell.accessoryView = setCheckBox()
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.bottom)
            cell.leftTitleLabel.textColor = AppColors.themeGreen
            cell.rightTitleLabel.textColor = AppColors.themeGray40
        }
        
        cell.accessoryView = nil
        cell.leftTitleLabel.textColor = AppColors.themeBlack
        cell.rightTitleLabel.textColor = AppColors.themeGray40
        
        
        switch indexPath.row {
        case 0:
            cell.leftTitleLabel.text = titles[indexPath.row]
            cell.rightTitleLabel.text = LocalizedString.Recommended.localized
            if HotelFilterVM.shared.sortUsing == .BestSellers {
               setSelectedState()
            }
        case 1:
            cell.leftTitleLabel.text = titles[indexPath.row]
            cell.rightTitleLabel.text = LocalizedString.LowToHigh.localized
            if HotelFilterVM.shared.sortUsing == .PriceLowToHigh(ascending: true) {
               setSelectedState()
                cell.rightTitleLabel.text = LocalizedString.LowToHigh.localized
            } else if HotelFilterVM.shared.sortUsing == .PriceLowToHigh(ascending: false) {
               setSelectedState()
                cell.rightTitleLabel.text = LocalizedString.HighToLow.localized
            }
        case 2:
            cell.leftTitleLabel.text = titles[indexPath.row]
            cell.rightTitleLabel.text = LocalizedString.FiveToOne.localized
            if HotelFilterVM.shared.sortUsing == .TripAdvisorRatingHighToLow(ascending: true) {
               setSelectedState()
                cell.rightTitleLabel.text = LocalizedString.OneToFive.localized
            } else if HotelFilterVM.shared.sortUsing == .TripAdvisorRatingHighToLow(ascending: false) {
               setSelectedState()
                cell.rightTitleLabel.text = LocalizedString.FiveToOne.localized
            }
        case 3:
            cell.leftTitleLabel.text = titles[indexPath.row]
            cell.rightTitleLabel.text = LocalizedString.FiveToOne.localized
            if HotelFilterVM.shared.sortUsing == .StartRatingHighToLow(ascending: true) {
               setSelectedState()
                cell.rightTitleLabel.text = LocalizedString.OneToFive.localized
            } else if HotelFilterVM.shared.sortUsing == .StartRatingHighToLow(ascending: false) {
               setSelectedState()
                cell.rightTitleLabel.text = LocalizedString.FiveToOne.localized
            }
        case 4:
            cell.leftTitleLabel.text = titles[indexPath.row]
            cell.rightTitleLabel.text = LocalizedString.NearestFirst.localized
            if HotelFilterVM.shared.sortUsing == .DistanceNearestFirst(ascending: true) {
               setSelectedState()
                cell.rightTitleLabel.text = LocalizedString.NearestFirst.localized
            } else if HotelFilterVM.shared.sortUsing == .DistanceNearestFirst(ascending: false) {
               setSelectedState()
                cell.rightTitleLabel.text = LocalizedString.FurthestFirst.localized
            }
        default: break
        }
        return cell
    }
    func setCheckBox() -> UIImageView {
        let checkMarkView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
        checkMarkView.setImageWithUrl("", placeholder: #imageLiteral(resourceName: "checkIcon"), showIndicator: false)
        return checkMarkView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var filterType = "", filterValues = ""
        
        HotelFilterVM.shared.isSortingApplied = true
        if let cell = tableView.cellForRow(at: indexPath) as? SortTableViewCell {
            cell.tintColor = AppColors.themeGreen
            //            cell.accessoryType = .checkmark
            //            cell.accessoryView = setCheckBox()
            //            cell.leftTitleLabel.textColor = AppColors.themeGreen
            //            cell.rightTitleLabel.textColor = AppColors.themeGreen
            switch indexPath.row {
            case 0:
                filterType = "BestSellers"
                filterValues = "n/a"
                HotelFilterVM.shared.sortUsing = .BestSellers
            case 1:
                filterType = "Price"
                if HotelFilterVM.shared.sortUsing != .PriceLowToHigh(ascending: true) {
                    HotelFilterVM.shared.sortUsing = .PriceLowToHigh(ascending: true)
                    filterValues = "Low to High"
                } else {
                    HotelFilterVM.shared.sortUsing = .PriceLowToHigh(ascending: false)
                    filterValues = "High to Low"
                }
            case 2:
                filterType = "TARatings"
                if HotelFilterVM.shared.sortUsing != .TripAdvisorRatingHighToLow(ascending: false) {
                    HotelFilterVM.shared.sortUsing = .TripAdvisorRatingHighToLow(ascending: false)
                    filterValues = "High to Low"
                } else {
                    HotelFilterVM.shared.sortUsing = .TripAdvisorRatingHighToLow(ascending: true)
                    filterValues = "Low to High"
                }
            case 3:
                filterType = "StarRatings"
                if HotelFilterVM.shared.sortUsing != .StartRatingHighToLow(ascending: false) {
                    HotelFilterVM.shared.sortUsing = .StartRatingHighToLow(ascending: false)
                    filterValues = "High to Low"
                } else {
                    HotelFilterVM.shared.sortUsing = .StartRatingHighToLow(ascending: true)
                    filterValues = "Low to High"
                }
            case 4:
                filterType = "Distance"
                if HotelFilterVM.shared.sortUsing != .DistanceNearestFirst(ascending: true) {
                    HotelFilterVM.shared.sortUsing = .DistanceNearestFirst(ascending: true)
                    filterValues = "Nearest First"
                } else {
                    HotelFilterVM.shared.sortUsing = .DistanceNearestFirst(ascending: false)
                    filterValues = "Furthest First"
                }
            default:
                return
            }
            self.tableView.reloadData()
        }
        // Log Event
        if !filterType.isEmpty {
            let sortFilterParams = [AnalyticsKeys.FilterName.rawValue: AnalyticsEvents.Sort.rawValue, AnalyticsKeys.FilterType.rawValue: filterType, AnalyticsKeys.Values.rawValue: filterValues]
            FirebaseEventLogs.shared.logHotelFilterEvents(params: sortFilterParams)
        }
        HotelFilterVM.shared.delegate?.updateFiltersTabs()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SortTableViewCell {
            cell.accessoryType = .none
            cell.leftTitleLabel.textColor = AppColors.textFieldTextColor51
            cell.rightTitleLabel.textColor = AppColors.themeGray40
        }
    }
}
