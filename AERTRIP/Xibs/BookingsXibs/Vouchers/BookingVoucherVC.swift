//
//  BookingVoucherVC.swift
//  AERTRIP
//
//  Created by apple on 17/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingVoucherVC: BaseVC {

    // MARK:- IBOutlet
    @IBOutlet weak var voucherTableView: ATTableView!
    @IBOutlet weak var topNavigationView: TopNavigationView!
    
    
    override func initialSetup() {
        self.voucherTableView.dataSource = self
        self.voucherTableView.delegate = self
    }
    
    
    

    
    override func setupNavBar() {
        self.topNavigationView.configureNavBar(title: LocalizedString.Vouchers.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: true)
        self.topNavigationView.delegate = self
    }
    
    
    
  
}


// MARK: - Top navigation view Delegate methods

extension BookingVoucherVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    
}


// MARK: - UITableViewSource and UITableViewViewDelegate

extension BookingVoucherVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
