//
//  GuestDetailsVC.swift
//  AERTRIP
//
//  Created by apple on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class GuestDetailsVC: BaseVC {
    // MARK: - IB Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var topNavView: TopNavigationView!
    @IBOutlet var travellersTableView: UITableView!
    
    // Mark: - Properties
    let cellIdentifier = "GuestDetailTableViewCell"
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerXib()
        self.doInitialSetup()
        self.addFooterView()
        self.getRoomDetails()
        
        // setting delay of 1 sec because table view cell are creating
        
        delay(seconds: 1.0) { [weak self] in
            self?.makeTableViewIndexSelectable()
        }
    }
    
    // MARK: - Helper methods
    
    // register All Xib file
    
    private func registerXib() {
        self.tableView.register(UINib(nibName: self.cellIdentifier, bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.register(UINib(nibName: AppConstants.ktableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: AppConstants.ktableViewHeaderViewIdentifier)
    }
    
    private func doInitialSetup() {
        self.tableView.separatorStyle = .none
        self.travellersTableView.separatorStyle = .none
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.travellersTableView.isHidden = true
        self.setUpNavigationView()
    }
    
    // configure navigation View
    
    private func setUpNavigationView() {
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.GuestDetails.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.CancelWithSpace.localized, selectedTitle: LocalizedString.CancelWithSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.DoneWithSpace.localized, selectedTitle: LocalizedString.DoneWithSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
    }
    
    // add Footer to Table view
    
    private func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 120))
        customView.backgroundColor = AppColors.themeWhite
        
        tableView.tableFooterView = customView
    }
    
    // get Room details from User defaults
    
    private func getRoomDetails() {
        HCDataSelectionVM.shared.hotelFormData = HotelsSearchVM.hotelFormData
    }
    
    // Make table view particular index selectable or Editable
    private func makeTableViewIndexSelectable() {
        self.tableView.scrollToRow(at: HCDataSelectionVM.shared.selectedIndexPath, at: .top, animated: false)
        if let cell = tableView.cellForRow(at: HCDataSelectionVM.shared.selectedIndexPath) as? GuestDetailTableViewCell {
            cell.firstNameTextField.becomeFirstResponder()
        }
    }
}

// MARK: - UITableView Data Source and Delegate methods

extension GuestDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return HCDataSelectionVM.shared.hotelFormData.adultsCount.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HCDataSelectionVM.shared.hotelFormData.adultsCount[section] + HCDataSelectionVM.shared.hotelFormData.childrenCounts[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GuestDetailTableViewCell else {
            printDebug("cell not found")
            return UITableViewCell()
        }
        cell.delegate = self
        if indexPath.row < HCDataSelectionVM.shared.hotelFormData.adultsCount[indexPath.section] {
            cell.guestTitleLabel.text = "Adult \(indexPath.row + 1)"
        } else {
            cell.guestTitleLabel.text = "Child \((indexPath.row -  HCDataSelectionVM.shared.hotelFormData.adultsCount[indexPath.section]) + 1)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AppConstants.ktableViewHeaderViewIdentifier) as? ViewProfileDetailTableViewSectionView else {
            fatalError("ViewProfileDetailTableViewSectionView not found")
        }
        headerView.headerLabel.text = "ROOM \(section + 1)"
        headerView.backgroundColor = AppColors.themeGray04
        headerView.containerView.backgroundColor = AppColors.themeGray04
        return headerView
    }
}

// MARK: - Top NavigationView Delegate methods

extension GuestDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        printDebug("Done Button tapped")
        AppFlowManager.default.popViewController(animated: true)
    }
}

extension GuestDetailsVC: GuestDetailTableViewCellDelegate {
    func textField(_ textField: UITextField) {
        let itemPosition: CGPoint = textField.convert(CGPoint.zero, to: tableView)
        // self.tableView.setContentOffset(CGPoint(x: self.tableView.origin.x, y: itemPosition.y - CGFloat(95)), animated: true)
        
        printDebug("item position is \(itemPosition)")
    }
}
