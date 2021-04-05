//
//  WebCheckinVC.swift
//  AERTRIP
//
//  Created by Admin on 15/07/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class WebCheckinVC: BaseVC {
    // MARK: - IB Outlet
    
    @IBOutlet weak var topNavBar: TopNavigationView!
    @IBOutlet weak var topDeviderView: ATDividerView!
    @IBOutlet weak var webCheckinTableView: ATTableView!
    @IBOutlet weak var navBarHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Varibles
    
    let viewModel = WebCheckinVM()
    
    
    // MARK: - Override methods
    
    override func initialSetup() {
        self.webCheckinTableView.dataSource = self
        self.webCheckinTableView.delegate = self
        self.webCheckinTableView.reloadData()
        topNavBar.backgroundColor = .clear
        self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        if #available(iOS 13.0, *) {
            navBarHeightConstraint.constant = 56
        } else {
            self.view.backgroundColor = AppColors.themeWhite
        }
        self.viewModel.getIntialData()
        
        self.setupNavBar()
        self.registerXib()
        
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Webcheckin.rawValue, params: [AnalyticsKeys.name.rawValue:AnalyticsEvents.Webcheckin.rawValue, AnalyticsKeys.type.rawValue: "LoggedInUserType", AnalyticsKeys.values.rawValue: UserInfo.loggedInUser?.userCreditType ?? "n/a"])

                
//        FirebaseAnalyticsController.shared.logEvent(name: "WebCheckin", params: ["ScreenName":"WebCheckin", "ScreenClass":"WebCheckinVC"])

    }
    
    override func setupNavBar() {
        self.topNavBar.delegate = self
        self.topNavBar.configureNavBar(title: LocalizedString.WebCheckin.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "black_cross"), selectedImage: #imageLiteral(resourceName: "black_cross"))
    }
    
    // MARK: - Helper methods
    func registerXib() {
        self.webCheckinTableView.register(UINib(nibName: AppConstants.ktableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: AppConstants.ktableViewHeaderViewIdentifier)
        self.webCheckinTableView.registerCell(nibName: BookingCallTableViewCell.reusableIdentifier)
        self.webCheckinTableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
    }
    
    func getCellForSecondSection(_ indexPath: IndexPath) -> UITableViewCell {
        guard let bookingCell = self.webCheckinTableView.dequeueReusableCell(withIdentifier: "BookingCallTableViewCell") as? BookingCallTableViewCell else {
            fatalError("BookingCallTableViewCell not found")
        }
        bookingCell.configureCell(code: self.viewModel.airlineData[indexPath.row].airlineCode, title: self.viewModel.airlineData[indexPath.row].airlineName, phoneLabel: "", cellType: .webcheckin)
        bookingCell.dividerView.isHidden = false//self.viewModel.airlineData.count - 1 == indexPath.row
        bookingCell.dividerViewLeadingConst.constant = (self.viewModel.airlineData.count - 1 == indexPath.row) ? 0 : 59
        return bookingCell
    }
    
}

// MARK: - UITableViewDataSource and UITableViewDelegate methods

extension WebCheckinVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.airlineData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let callHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ViewProfileDetailTableViewSectionView") as? ViewProfileDetailTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        callHeader.topSeparatorView.isHidden = (section == 0)
        callHeader.headerLabel.text = self.viewModel.section[section]
        return callHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getCellForSecondSection(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      //  guard let url = self.viewModel.webCheckins[indexPath.row].toUrl else { return }
      //  AppFlowManager.default.showURLOnATWebView(url, screenTitle: LocalizedString.WebCheckin.localized)
        guard self.viewModel.webCheckins.count > indexPath.row else {return}
        self.openUrl( self.viewModel.webCheckins[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}

extension WebCheckinVC: TopNavigationViewDelegate {
    
    func topNavBarLeftButtonAction(_ sender: UIButton) {
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
