//
//  AmenitiesVC.swift
//  AERTRIP
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AmenitiesVC: BaseVC {
    // MARK: - IB Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    
    let cellIdentifier = "AmenitiesTableViewCell"
    let amentiesDetails: [ATAmenity] = ATAmenity.allCases
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doIntitialSetup()
        self.addFooterView()
        registerXib()
    }
    
    // MARK: - Helper methods
    
    private func doIntitialSetup() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func registerXib() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    private func addFooterView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth, height: 35))
        customView.backgroundColor = AppColors.themeWhite
        
        tableView.tableFooterView = customView
    }
}

// MARK: - UITableViewDataSource and Delegate methods

extension AmenitiesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amentiesDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? AmenitiesTableViewCell else {
            printDebug("AmenitiesTableViewCell not found")
            return UITableViewCell()
        }
        cell.amenitie = amentiesDetails[indexPath.row]
        cell.statusButton.isSelected = HotelFilterVM.shared.amenitites.contains(amentiesDetails[indexPath.row].rawValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if HotelFilterVM.shared.amenitites.contains(amentiesDetails[indexPath.row].rawValue) {
            HotelFilterVM.shared.amenitites.remove(at: HotelFilterVM.shared.amenitites.firstIndex(of: amentiesDetails[indexPath.row].rawValue)!)
        } else {
            HotelFilterVM.shared.amenitites.append(amentiesDetails[indexPath.row].rawValue)
        }
        self.tableView.reloadData()
    }
}
