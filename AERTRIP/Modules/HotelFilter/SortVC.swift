//
//  SortVC.swift
//  AERTRIP
//
//  Created by apple on 31/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class SortVC: UIViewController {
    
    
    // MARK:- IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- Variables
    let cellIdentifier = "SortTableViewCell"
    private  let titles: [String] = [LocalizedString.BestSellers.localized,LocalizedString.Price.localized,LocalizedString.TripAdvisor.localized,LocalizedString.StarRating.localized,LocalizedString.Distance.localized]
    
    // MARK:- View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doInitialSetup()
        self.registerXib()
    }
    
    
    // MARK:- Helper methods
    
    func registerXib(){
        self.tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier:cellIdentifier)
    }
    
    func  doInitialSetup() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.separatorStyle = .none
    }
    

    

}


// MARK: - UITableViewCellDataSource and UITableViewCellDelegateMethods

extension SortVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SortTableViewCell else {
           return UITableViewCell()
        }
        cell.leftTitleLabel.textColor = indexPath.row == 0 ? AppColors.themeGreen : AppColors.textFieldTextColor
        cell.configureCell(leftTitle: titles[indexPath.row], rightTitle: "will change")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.tintColor = AppColors.themeGreen
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell  = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
}
