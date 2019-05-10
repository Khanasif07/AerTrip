//
//  BookingDetailViewController.swift
//  AERTRIP
//
//  Created by apple on 09/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingDetailViewController: BaseVC {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var topNavigationView: TopNavigationView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: ATTableView!
    
    // MARK: - Variables
    let headerViewIdentifier = "BookingInfoHeaderView"
    let footerViewIdentifier = "BookingInfoFooterView"
    
    
    override func initialSetup() {
            self.configureNavBar()
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.setUpSegmentControl()
        
    }
    
    
    private func configureNavBar() {
        self.topNavigationView.configureNavBar(title: "BEL" + LocalizedString.ForwardArrow.localized + "DEL", isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false)
        self.topNavigationView.delegate = self
    }
    
    
    private func setUpSegmentControl() {
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
    }
    
    private func registerXib() {
        self.tableView.registerCell(nibName: BaggageAirlineInfoTableViewCell.reusableIdentifier)
        self.tableView.register(UINib(nibName: self.headerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.headerViewIdentifier)
        self.tableView.register(UINib(nibName: self.footerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.footerViewIdentifier)
        self.tableView.registerCell(nibName:BookingInfoCommonCell.reusableIdentifier)
        self.tableView.registerCell(nibName: NightStateTableViewCell.reusableIdentifier)
    }

    
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            printDebug("Flight info tapped")
            
        case 1:
            printDebug("Baggage  tapped")
           
        case 2:
            printDebug("Fare info tapped")
           
        default:
            printDebug("Tapped")
        }
        tableView.reloadData()
    }
}


// MARK: - Top Navigation View

extension BookingDetailViewController: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.mainNavigationController.popViewController(animated: true)
    }
    
    
}
