//
//  PriceVC.swift
//  AERTRIP
//
//  Created by apple on 04/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

enum Price {
    case PerNight
    case Total
    
    func stringValue() -> String {
        if self == .PerNight {
            return "perNight"
        } else {
            return "total"
        }
    }
}

class PriceVC: BaseVC {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: ATTableView!
    
    // MARK: - Variables
    
    var filterApplied: UserInfo.HotelFilter = UserInfo.HotelFilter()
    private let titles: [String] = [LocalizedString.PerNight.localized, LocalizedString.Total.localized]
    private let priceTitles: [Price] = [.PerNight,.Total]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        registerXib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFilterValues()
    }
    
    override func currencyChanged(_ note: Notification) {
        self.tableView.reloadData()
    }
    
    // MARK: - Override methods
    
    // MARK: - Helper methods
    
    
    
    func setFilterValues() {
        getSavedFilter()
        self.tableView?.reloadData()
    }
    
    func getSavedFilter() {
        guard let filter = UserInfo.hotelFilter else {
            printDebug("filter not found")
            filterApplied = UserInfo.HotelFilter()
            HotelFilterVM.shared.priceType = .PerNight
            return
        }
        filterApplied = filter
        HotelFilterVM.shared.priceType = filter.priceType
    }
    
    func registerXib() {
        tableView.registerCell(nibName: PriceSliderCell.reusableIdentifier)
        tableView.registerCell(nibName: SortTableViewCell.reusableIdentifier)
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        printDebug("\(slider.value)")
        // "\u{20B9} " +
        HotelFilterVM.shared.leftRangePrice = Double(slider.value.first ?? 0.0).roundTo(places: 2)
        HotelFilterVM.shared.rightRangePrice = Double(slider.value.last ?? 0.0).roundTo(places: 2)
        HotelFilterVM.shared.delegate?.updateFiltersTabs()
        
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PriceSliderCell {
            cell.setPriceOnLabels()
        } else {
            tableView?.reloadData()
        }
    }
    
    @objc private func sliderDidEndDragging(slider: MultiSlider) {
        
        let minRange = Double(slider.value.first ?? 0.0).roundTo(places: 2)
        let maxRange = Double(slider.value.last ?? 0.0).roundTo(places: 2)
        let valueStr = "min\(Int(minRange)) max\(Int(maxRange))"
        let rangeFilterParams = [AnalyticsKeys.name.rawValue: AnalyticsEvents.Price.rawValue, AnalyticsKeys.type.rawValue: AnalyticsEvents.PriceRange.rawValue, AnalyticsKeys.values.rawValue: valueStr]
        FirebaseEventLogs.shared.logHotelFilterEvents(params: rangeFilterParams)
        
    }
}

// MARK: - UITableViewCellDataSource and UITableViewCellDelegateMethods

extension PriceVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 190 : 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PriceSliderCell.reusableIdentifier, for: indexPath) as? PriceSliderCell else {
                return UITableViewCell()
            }
            cell.horizontalMultiSlider.removeTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
            cell.horizontalMultiSlider.removeTarget(self, action: #selector(sliderDidEndDragging(slider:)), for: [.touchUpInside, .touchUpOutside])
            cell.horizontalMultiSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
            cell.horizontalMultiSlider.addTarget(self, action: #selector(sliderDidEndDragging(slider:)), for: [.touchUpInside, .touchUpOutside])

            cell.horizontalMultiSlider.value = [UserInfo.hotelFilter != nil ? CGFloat(filterApplied.leftRangePrice) : CGFloat(HotelFilterVM.shared.minimumPrice), UserInfo.hotelFilter != nil ? CGFloat(filterApplied.rightRangePrice) : CGFloat(HotelFilterVM.shared.maximumPrice)]
            cell.setPriceOnLabels()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SortTableViewCell.reusableIdentifier, for: indexPath) as? SortTableViewCell else {
                return UITableViewCell()
            }
            //        cell.tintColor = AppColors.themeGreen
            if priceTitles[indexPath.row] ==  HotelFilterVM.shared.priceType {
                cell.accessoryView = setCheckBox()
                cell.leftTitleLabel.textColor = AppColors.themeGreen
            } else {
                cell.accessoryView = nil
                cell.leftTitleLabel.textColor = AppColors.themeBlack
                
            }
            
            cell.configureCell(leftTitle: titles[indexPath.row], rightTitle: "")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = tableView.cellForRow(at: indexPath) as? SortTableViewCell{
            //            cell.tintColor = AppColors.themeGreen
            //            cell.accessoryType = .checkmark
            //            cell.leftTitleLabel.textColor = AppColors.themeGreen
            
            var valueStr = ""
            
            switch indexPath.row {
            case 0:
                HotelFilterVM.shared.priceType = .PerNight
                valueStr = AnalyticsEvents.PerNight.rawValue
            case 1:
                HotelFilterVM.shared.priceType = .Total
                valueStr = AnalyticsEvents.Total.rawValue
            default:
                return
            }
            // reloading table was resetting sliders to 0
            // self.tableView.reloadData()
            tableView.reloadSections([1], with: .none)
            
            HotelFilterVM.shared.delegate?.updateFiltersTabs()
            
            let rangeFilterParams = [AnalyticsKeys.name.rawValue: AnalyticsEvents.Price.rawValue, AnalyticsKeys.type.rawValue: AnalyticsEvents.PriceType.rawValue, AnalyticsKeys.values.rawValue: valueStr]
            FirebaseEventLogs.shared.logHotelFilterEvents(params: rangeFilterParams)
        }
    }
    
    func setCheckBox() -> UIImageView {
        let checkMarkView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
        checkMarkView.setImageWithUrl("", placeholder: AppImages.checkIcon, showIndicator: false)
        return checkMarkView
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SortTableViewCell {
            cell.accessoryType = .none
            cell.leftTitleLabel.textColor = AppColors.textFieldTextColor51
            cell.rightTitleLabel.textColor = AppColors.themeGray40
        }
    }
}




