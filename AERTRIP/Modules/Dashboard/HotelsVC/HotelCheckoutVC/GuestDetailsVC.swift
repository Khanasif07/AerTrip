//
//  GuestDetailsVC.swift
//  AERTRIP
//
//  Created by apple on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class GuestDetailsVC: BaseVC {
    
    // MARK:- IB Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var travellersTableView: UITableView!
    
    
    // Mark: - Properties
    let cellIdentifier = "GuestDetailTableViewCell"
    let viewModel = GuestDetailsVM()
    
    
    // MARK: - View Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerXib()
        self.doInitialSetup()
        self.addFooterView()
        self.getRoomDetails()
       
    }
    

   


    
    
    // MARK: - Helper methods
    
    private func registerXib() {
        self.tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.register(UINib(nibName: AppConstants.ktableViewHeaderViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: AppConstants.ktableViewHeaderViewIdentifier)

    }
    
    private func doInitialSetup() {
        self.tableView.separatorStyle = .none
        self.travellersTableView.separatorStyle = .none
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.travellersTableView.isHidden = true
        self.setUpNavigationView()
    }
    
    private func setUpNavigationView() {
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.GuestDetails.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: false, isDivider: false)
        self.topNavView.configureLeftButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.CancelWithSpace.localized, selectedTitle: LocalizedString.CancelWithSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.Regular.withSize(18.0))
        self.topNavView.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: LocalizedString.DoneWithSpace.localized, selectedTitle: LocalizedString.DoneWithSpace.localized, normalColor: AppColors.themeGreen, selectedColor: AppColors.themeGreen, font: AppFonts.SemiBold.withSize(18.0))
      
    }
    
    private func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 120))
        customView.backgroundColor = AppColors.themeWhite
        
        tableView.tableFooterView = customView
    }
    
    private func getRoomDetails() {
        self.viewModel.hotelFormData =  HotelsSearchVM.hotelFormData
    }
    
  

}


// MARK: - UITableView Data Source and Delegate methods

extension GuestDetailsVC : UITableViewDataSource ,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.hotelFormData.adultsCount.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.hotelFormData.adultsCount[section] + self.viewModel.hotelFormData.childrenCounts[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GuestDetailTableViewCell else {
            printDebug("cell not found")
            return UITableViewCell()
        }
        cell.delegate = self
        if indexPath.row < self.viewModel.hotelFormData.adultsCount[indexPath.section] {
            cell.guestTitleLabel.text = "Adult \(indexPath.row + 1)"
        } else {
            cell.guestTitleLabel.text = "Child \((indexPath.row - self.viewModel.hotelFormData.adultsCount[indexPath.section]) + 1)"
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

extension GuestDetailsVC : TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        printDebug("Done Button tapped")
        AppFlowManager.default.popViewController(animated: true)
    }
}

extension GuestDetailsVC : GuestDetailTableViewCellDelegate {
    func textField(_ textField: UITextField) {
        let itemPosition: CGPoint = textField.convert(CGPoint.zero, to: tableView)
        self.tableView.setContentOffset(CGPoint(x: self.tableView.origin.x, y: itemPosition.y - CGFloat(95)), animated: true)
       
        printDebug("item position is \(itemPosition)")
    }
    
    
}

