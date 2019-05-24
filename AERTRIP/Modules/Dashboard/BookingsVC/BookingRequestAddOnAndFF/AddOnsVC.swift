//
//  AddOnsVC.swift
//  AERTRIP
//
//  Created by apple on 21/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AddOnsVC: BaseVC {
    
    // MARK: - IBOutlet
    @IBOutlet weak var addOnTableView: ATTableView!
    
    
    
    //MARK: - Variables
    let viewModel =  BookingRequestAddOnsFFVM()
    let footerViewIdentifier = "BookingInfoEmptyFooterView"
    let headerViewIdentifier = "BookingAddOnHeaderView"
    

    override func initialSetup() {
       self.registerXib()
       self.addOnTableView.dataSource = self
       self.addOnTableView.delegate = self
       self.addOnTableView.reloadData()
    }
    
    
    
    func registerXib() {
        self.addOnTableView.register(UINib(nibName: self.footerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.footerViewIdentifier)
        self.addOnTableView.register(UINib(nibName: self.headerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: self.headerViewIdentifier)
        self.addOnTableView.registerCell(nibName: BookingAddOnPassengerTableViewCell.reusableIdentifier)
        self.addOnTableView.registerCell(nibName: BookingFFMealTableViewCell.reusableIdentifier)
        
    }
    
    func getCellForSection(_ indexPath:IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0,5:
            guard let cell = self.addOnTableView.dequeueReusableCell(withIdentifier: "BookingAddOnPassengerTableViewCell") as? BookingAddOnPassengerTableViewCell else {
                fatalError("BookingAddOnPassengerTableViewCell not found")
            }
            if indexPath.row == 0 {
                cell.topConstraint.constant = 0
            } else {
                cell.topConstraint.constant = 16
            }
            cell.configureCell(profileImage: UIImage(named: "boy")!, passengerName: "Mr. Alan McCarthy")
            return cell
        case 1,2,3,4,6,7,8,9:
            guard let cell = self.addOnTableView.dequeueReusableCell(withIdentifier: "BookingFFMealTableViewCell") as? BookingFFMealTableViewCell else {
                fatalError("BookingFFMealTableViewCell not found")
            }
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
    
    

}


extension AddOnsVC: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [10,10][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return getCellForSection(indexPath)
        case 1:
              return getCellForSection(indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 67.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return [44,60,60,60,60,60,60,60,60,60][indexPath.row]
    }
    
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = addOnTableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? BookingAddOnHeaderView else {
            fatalError(" BookingAddOnHeaderView not  found")
        }
        
        headerView.routeLabel.text = self.viewModel.sectionDataAddOns[section].title
        headerView.infoLabel.text = self.viewModel.sectionDataAddOns[section].info
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = self.addOnTableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerViewIdentifier) as? BookingInfoEmptyFooterView else {
            fatalError("BookingInfoFooterView not found")
        }
        return footerView
    }
}
