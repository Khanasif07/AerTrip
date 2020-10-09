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
    @IBOutlet weak var navigationHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    let viewModel = BookingDirectionVM()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusBarStyle = .darkContent
    }
    
    override func initialSetup() {
        self.setupNavBar()
        self.registerXib()
        topNavigationView.backgroundColor = .clear
        self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        if #available(iOS 13.0, *) {
            navigationHeightConstraint.constant = 56
        } else {
            self.view.backgroundColor = AppColors.themeWhite
        }
        self.directionTableView.contentInset = UIEdgeInsets(top: topNavigationView.height , left: 0.0, bottom: 0.0, right: 0.0)
        self.directionTableView.dataSource = self
        self.directionTableView.delegate = self
        self.directionTableView.reloadData()
    }
    
    override func setupNavBar() {
        self.topNavigationView.delegate = self
        //self.topNavigationView.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        //self.topNavigationView.navTitleLabel.textColor = AppColors.textFieldTextColor51
        self.topNavigationView.configureNavBar(title: LocalizedString.Directions.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
         topNavigationView.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "black_cross"), selectedImage: #imageLiteral(resourceName: "black_cross"))
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
        headerView.headerLabel.textColor = AppColors.themeGray60
        headerView.headerLabel.font = AppFonts.Regular.withSize(14)
        headerView.headerLabel.text = self.viewModel.sectionData[section]
        headerView.topSeparatorView.isHidden = section == 0
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppGlobals.shared.redirectToMap(sourceView: self.view, originLat: "", originLong: "", destLat: self.viewModel.directionData[indexPath.row].latitude, destLong: self.viewModel.directionData[indexPath.row].longitude)
    }
}

// MARK: - TopNavigation View Delegate methods

extension BookingDirectionVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        //AppFlowManager.default.popViewController(animated: true)
    }
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
           self.dismiss(animated: true, completion: nil)
       }
}
