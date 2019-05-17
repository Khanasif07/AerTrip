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
    
    
    
    // MARK:- Variables
    let viewModel = BookingVoucherVM()
    
    // MARK:- View life cycle
    
    override func initialSetup() {
        self.voucherTableView.dataSource = self
        self.voucherTableView.delegate = self
        self.registerXib()
        self.viewModel.getVouherData()
        printDebug("voucher data is \(self.viewModel.vouchers)")
    }
    
    
    

    // MARK:- Helper methods
    
    override func setupNavBar() {
        self.topNavigationView.configureNavBar(title: LocalizedString.Vouchers.localized, isLeftButton: true, isFirstRightButton: true, isSecondRightButton: true, isDivider: true)
        
        self.topNavigationView.delegate = self
    }
    
    
     func registerXib() {
        self.voucherTableView.registerCell(nibName: BookingVoucherTableViewCell.reusableIdentifier)
        self.voucherTableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        self.voucherTableView.reloadData()
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
        return self.viewModel.vouchers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return [75,75,10,75,75,10,75][indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let voucherCell = self.voucherTableView.dequeueReusableCell(withIdentifier: "BookingVoucherTableViewCell") as? BookingVoucherTableViewCell else {
            fatalError("BookingVoucherTableViewCell not found ")
        }
        switch indexPath.row {
        case 0,1,3,4:
            if indexPath.row == 1 || indexPath.row == 4 {
                voucherCell.dividerView.isHidden = true
            } else {
                voucherCell.dividerView.isHidden = false
            }
            voucherCell.voucherData = self.viewModel.vouchers[indexPath.row]
            return voucherCell
        case 2,5:
            guard let emptyCell = self.voucherTableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell") as? EmptyTableViewCell else {
                fatalError("EmptyTableViewCell not found ")
            }
            return emptyCell
        case 6:
            voucherCell.voucherData = self.viewModel.vouchers[indexPath.row]
            voucherCell.dateLabelTopConstraint.constant = 8
            voucherCell.dividerViewLeadingConstraint.constant = 0
            voucherCell.dividerViewTrailingConstraint.constant = 0
            return voucherCell
        default:
            return UITableViewCell()
        }

        
    }
    
    
}
