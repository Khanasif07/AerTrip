//
//  FareRulesVC.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FareBookingRulesVC: BaseVC {
    
    // MARK: - IBOutlet
    @IBOutlet weak var fareRuleTableView: ATTableView!
    @IBOutlet weak var navBarView: TopNavigationView!
    @IBOutlet weak var navBarHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Override methods
    private var fareRules: String = LocalizedString.na.localized
    private var ruteString: String = LocalizedString.na.localized
    let viewModel = BookingFareInfoDetailVM()
    
    override func initialSetup() {
        registerXib()
        self.fareRuleTableView.dataSource = self
        self.fareRuleTableView.delegate = self
//        self.fareRuleTableView.isScrollEnabled = false
        self.fareRuleTableView.reloadData()
        
        navBarView.backgroundColor = .clear
        self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        if #available(iOS 13.0, *) {
            navBarHeightConstraint.constant = 56
        } else {
            self.view.backgroundColor = AppColors.themeWhite
        }
        self.fareRuleTableView.contentInset = UIEdgeInsets(top: navBarView.height, left: 0.0, bottom: 0.0, right: 0.0)
        self.viewModel.getFareRules()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func setupNavBar() {
        self.navBarView.delegate = self
        self.navBarView.configureNavBar(title: LocalizedString.FareRules.localized, isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: true)
        navBarView.configureFirstRightButton(normalImage: AppImages.CancelButtonWhite, selectedImage: AppImages.CancelButtonWhite)
    }
    
    // MARK: - Helper methods
    
    func set(fareRules: String, ruteString: String) {
        self.fareRules = fareRules
        self.ruteString = ruteString
        self.fareRuleTableView?.reloadData()
    }
    
    private func registerXib() {
        self.fareRuleTableView.registerCell(nibName: FareRuleTableViewCell.reusableIdentifier)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate methods

extension FareBookingRulesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.screenSize.height - 84
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.fareRuleTableView.dequeueReusableCell(withIdentifier: "FareRuleTableViewCell", for: indexPath) as? FareRuleTableViewCell else {
            fatalError("FareRuleTableViewCell not found")
        }
        
        cell.configureCell(fareRules: self.fareRules, ruteString: self.ruteString)
        return cell
    }
}

extension FareBookingRulesVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension FareBookingRulesVC: BookingFareInfoDetailVMDelegate{
    func willGetFareRules() {
    }
    
    func getFareRulesSuccess(fareRules: String, ruteString: String) {
        
        DispatchQueue.mainAsync {
            self.set(fareRules: fareRules, ruteString: ruteString)
        }
    }
    
    func getFareRulesFail() {
        
    }
}
