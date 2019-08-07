//
//  BookingDirectionVC.swift
//  AERTRIP
//
//  Created by apple on 21/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingDirectionVC: BaseVC {
    // MARK: - IBOutlet
    
    @IBOutlet weak var topNavigationView: TopNavigationView!
    @IBOutlet weak var directionTableView: ATTableView!
    
    // MARK: - Variables
    
    let viewModel = BookingDirectionVM()
    
    override func initialSetup() {
        self.setupNavBar()
        self.registerXib()
        
        self.directionTableView.dataSource = self
        self.directionTableView.delegate = self
        self.directionTableView.reloadData()
    }
    
    override func setupNavBar() {
        self.topNavigationView.delegate = self
        self.topNavigationView.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.topNavigationView.navTitleLabel.textColor = AppColors.textFieldTextColor51
        self.topNavigationView.configureNavBar(title: LocalizedString.Directions.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false)
    }
    
    private func registerXib() {
        self.directionTableView.registerCell(nibName: BookingDirectionTableViewCell.reusableIdentifier)
        self.directionTableView.register(UINib(nibName: AppConstants.ktableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: AppConstants.ktableViewHeaderViewIdentifier)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate methods

extension BookingDirectionVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.directionData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let directionCell = self.directionTableView.dequeueReusableCell(withIdentifier: "BookingDirectionTableViewCell") as? BookingDirectionTableViewCell else {
            fatalError("BookingDirectionTableViewCell not found")
        }
        
        let airportName: String = self.viewModel.directionData[indexPath.row].city + "," + self.viewModel.directionData[indexPath.row].country_code
        directionCell.configureCell(airportCode: self.viewModel.directionData[indexPath.row].iataCode, airportName: airportName, airportAddress: self.viewModel.directionData[indexPath.row].airportName)
        directionCell.bottomDividerView.isHidden = self.viewModel.directionData.count - 1 == indexPath.row
        directionCell.edgeToedgeBottomDividerView.isHidden = self.viewModel.directionData.count - 1 != indexPath.row
        return directionCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ViewProfileDetailTableViewSectionView") as? ViewProfileDetailTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        
        headerView.headerLabel.text = self.viewModel.sectionData[section]
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppGlobals.shared.redirectToMap(sourceView: self.view, originLat: "", originLong: "", destLat: self.viewModel.directionData[indexPath.row].latitude, destLong: self.viewModel.directionData[indexPath.row].longitude)
    }
}

// MARK: - TopNavigation View Delegate methods

extension BookingDirectionVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}
