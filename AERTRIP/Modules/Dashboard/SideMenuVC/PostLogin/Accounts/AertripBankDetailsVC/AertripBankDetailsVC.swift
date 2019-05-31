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
    @IBOutlet weak var crossButton: UIButton!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = AertripBankDetailsVM()
    
    //MARK:- Private

    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        self.tableView.registerCell(nibName: OfflineDepositeTextImageCell.reusableIdentifier)
        self.tableView.registerCell(nibName: EmptyTableViewCell.reusableIdentifier)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
//        self.viewModel.getBankAccountDetails()
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
    }
    
    func getBankAccountDetailsFail() {
        self.tableView.reloadData()
    }
}