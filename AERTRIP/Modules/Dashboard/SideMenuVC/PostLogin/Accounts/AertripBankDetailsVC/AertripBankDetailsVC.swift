//
//  AertripBankDetailsVC.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AertripBankDetailsVC: BaseVC {

    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var tableView: ATTableView!
    @IBOutlet weak var topNavBar: TopNavigationView!
    @IBOutlet weak var topNavBarHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = AertripBankDetailsVM()
    var currentIndex = 0
    //MARK:- Private

    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        topNavBar.configureNavBar(title: "Bank Detail", isLeftButton: false, isFirstRightButton: true, isSecondRightButton: false, isDivider: true, backgroundType: .clear)
        topNavBar.configureFirstRightButton(normalImage: #imageLiteral(resourceName: "black_cross"), selectedImage: #imageLiteral(resourceName: "black_cross"))
        topNavBar.delegate = self
        topNavBar.backView.backgroundColor = .clear
        topNavBar.backgroundColor = .clear
        self.view.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.85)
        if #available(iOS 13.0, *) {
            topNavBarHeightConstraint.constant = 56
        } else {
            self.view.backgroundColor = AppColors.themeWhite
        }
        self.tableView.registerCell(nibName: OfflineDepositeTextImageCell.reusableIdentifier)
        self.tableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if self.currentIndex != 0 && currentIndex < self.viewModel.allBanks.count{
            let numberOfRow = self.tableView.numberOfRows(inSection: currentIndex)
            let indexPath = IndexPath(row: numberOfRow - 1, section: currentIndex)
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
//        self.viewModel.getBankAccountDetails()
        self.tableView.backgroundColor = AppColors.themeGray04
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //MARK:- Methods
    //MARK:- Private
    
    //MARK:- Public
    
    //MARK:- Action
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- View model delegate methods
//MARK:-
extension AertripBankDetailsVC: AertripBankDetailsVMDelegate {
    func getBankAccountDetailsSuccess() {
        self.tableView.reloadData()
        if self.currentIndex != 0 && currentIndex < self.viewModel.allBanks.count{
            let numberOfRow = self.tableView.numberOfRows(inSection: currentIndex)
            let indexPath = IndexPath(row: numberOfRow - 1, section: currentIndex)
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    func getBankAccountDetailsFail() {
        self.tableView.reloadData()
    }
}
extension AertripBankDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
    }
    
    func topNavBarFirstRightButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
