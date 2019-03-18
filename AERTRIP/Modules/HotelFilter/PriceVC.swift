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
}

class PriceVC: BaseVC {
    // MARK: - IBOutlets
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var minimumPriceView: UIView!
    @IBOutlet var minimumPriceLabel: UILabel!
    
    @IBOutlet var maximumPriceView: UIView!
    @IBOutlet var maximumPriceLabel: UILabel!
    @IBOutlet var tableView: ATTableView!
    
    // MARK: - Variables
    
    let horizontalMultiSlider = MultiSlider()
    var filterApplied: UserInfo.HotelFilter = UserInfo.HotelFilter()
    private let titles: [String] = [LocalizedString.PerNight.localized, LocalizedString.Total.localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSavedFilter()
        doInitialSetup()
        addSlider()
        registerXib()
    }
    
    // MARK: - Override methods
    
    // MARK: - Helper methods
    
    private func addSlider() {
        horizontalMultiSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        horizontalMultiSlider.orientation = .horizontal
        horizontalMultiSlider.minimumValue = CGFloat(HotelFilterVM.shared.minimumPrice)
        horizontalMultiSlider.maximumValue = CGFloat(HotelFilterVM.shared.maximumPrice)
        horizontalMultiSlider.value = [UserInfo.hotelFilter != nil ? CGFloat(filterApplied.leftRangePrice) : CGFloat(HotelFilterVM.shared.minimumPrice), UserInfo.hotelFilter != nil ? CGFloat(filterApplied.rightRangePrice) : CGFloat(HotelFilterVM.shared.maximumPrice)]
        horizontalMultiSlider.isSettingValue = true
        horizontalMultiSlider.thumbCount = 2
        horizontalMultiSlider.tintColor = AppColors.themeGreen // color of the track
        horizontalMultiSlider.outerTrackColor = AppColors.themeGray10
        horizontalMultiSlider.trackWidth = 3
        horizontalMultiSlider.showsThumbImageShadow = false
        horizontalMultiSlider.hasRoundTrackEnds = true
        horizontalMultiSlider.frame = CGRect(x: minimumPriceView.frame.origin.x + 16, y: minimumPriceView.frame.origin.y + 24, width: UIScreen.main.bounds.width - 66, height: 28.0)
        view.addSubview(horizontalMultiSlider)
    }
    
    private func doInitialSetup() {
        minimumPriceView.layer.cornerRadius = 15.0
        maximumPriceView.layer.cornerRadius = 15.0
        let leftRangePrice = UserInfo.hotelFilter != nil ? filterApplied.leftRangePrice : HotelFilterVM.shared.minimumPrice
        let rightRangePrice = UserInfo.hotelFilter != nil ? filterApplied.rightRangePrice : HotelFilterVM.shared.maximumPrice
        minimumPriceLabel.attributedText = (AppConstants.kRuppeeSymbol + "\(leftRangePrice.roundTo(places: 2))").asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
        maximumPriceLabel.attributedText = (AppConstants.kRuppeeSymbol + "\(rightRangePrice.roundTo(places: 2))").asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func getSavedFilter() {
        guard let filter = UserInfo.hotelFilter else {
            printDebug("filter not found")
            return
        }
        filterApplied = filter
    }
    
    func registerXib() {
        tableView.registerCell(nibName: SortTableViewCell.reusableIdentifier)
    }
    
    override func setupColors() {
        titleLabel.textColor = AppColors.themeGray40
        minimumPriceLabel.textColor = AppColors.textFieldTextColor51
        maximumPriceLabel.textColor = AppColors.textFieldTextColor51
        minimumPriceView.backgroundColor = AppColors.themeGray10
        maximumPriceView.backgroundColor = AppColors.themeGray10
    }
    
    override func setupFonts() {
        titleLabel.font = AppFonts.Regular.withSize(16.0)
        minimumPriceLabel.font = AppFonts.Regular.withSize(14.0)
        maximumPriceLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    override func setupTexts() {
        titleLabel.text = LocalizedString.PricePerNight.localized
    }
    
    @objc func sliderChanged(_ slider: MultiSlider) {
        print("\(slider.value)")
        // "\u{20B9} " +
        minimumPriceLabel.attributedText = (AppConstants.kRuppeeSymbol + String(format: "%.2f", slider.value.first ?? "")).asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
        HotelFilterVM.shared.leftRangePrice = Double(slider.value.first ?? 0.0).roundTo(places: 2)
        HotelFilterVM.shared.rightRangePrice = Double(slider.value.last ?? 0.0).roundTo(places: 2)
        maximumPriceLabel.attributedText = (AppConstants.kRuppeeSymbol + String(format: "%.2f", slider.value.last ?? "")).asStylizedPrice(using: AppFonts.Regular.withSize(18.0))
    }
}

// MARK: - UITableViewCellDataSource and UITableViewCellDelegateMethods

extension PriceVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SortTableViewCell.reusableIdentifier, for: indexPath) as? SortTableViewCell else {
            return UITableViewCell()
        }
        cell.tintColor = AppColors.themeGreen
        if indexPath.row == 0,  HotelFilterVM.shared.priceType == .PerNight {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.bottom)
            cell.leftTitleLabel.textColor = AppColors.themeGreen
        } else if indexPath.row == 1, HotelFilterVM.shared.priceType == .Total {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.bottom)
            cell.leftTitleLabel.textColor =  AppColors.themeGreen
        }
      
        cell.configureCell(leftTitle: titles[indexPath.row], rightTitle: "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SortTableViewCell{
            cell.tintColor = AppColors.themeGreen
            cell.accessoryType = .checkmark
            switch indexPath.row {
            case 0:
                HotelFilterVM.shared.priceType = .PerNight
                cell.leftTitleLabel.textColor = AppColors.themeGreen
            case 1:
                HotelFilterVM.shared.priceType = .Total
                cell.leftTitleLabel.textColor = AppColors.themeGreen
            default:
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SortTableViewCell {
            cell.accessoryType = .none
            cell.leftTitleLabel.textColor = AppColors.textFieldTextColor51
        }
    }
}
