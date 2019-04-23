//
//  ADVoucherTypeVC.swift
//  AERTRIP
//
//  Created by Admin on 22/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ADVoucherTypeVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var tableView: ATTableView!
    
    
    //MARK:- Properties
    //MARK:- Public
    let viewModel = ADVoucherTypeVM()
    
    //MARK:- Private
    private let cellIdentifier = "cellIdentifier"
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func initialSetup() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    //MARK:- Methods
    //MARK:- Private
    
    
    //MARK:- Public
    
    
    //MARK:- Action
}

//MARK:- Action
extension ADVoucherTypeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.allTypes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: self.cellIdentifier)
        }
        
        cell?.textLabel?.font = AppFonts.Regular.withSize(18.0)
        cell?.textLabel?.text = self.viewModel.allTypes[indexPath.row]
        cell?.tintColor = AppColors.themeGreen
        cell?.accessoryType = .none
        
        if let idxPath = self.viewModel.selectedIndexPath, idxPath.row == indexPath.row {
            cell?.accessoryType = .checkmark
            cell?.textLabel?.textColor = AppColors.themeGreen
        }
        else {
            cell?.textLabel?.textColor = AppColors.themeBlack
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.selectedIndexPath = indexPath
        tableView.reloadData()
    }
    
}

