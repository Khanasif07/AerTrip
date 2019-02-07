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
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Variables
    
    let cellIdentifier = "AmenitiesTableViewCell"
    let amentiesDetails: [(amenititesImage: UIImage, amentitiesTitle: String, status: Int)] = [(amenititesImage: UIImage(named: "wifiIcon") ?? AppPlaceholderImage.frequentFlyer, amentitiesTitle: LocalizedString.Wifi.localized, status: 0), (amenititesImage: UIImage(named: "roomServiceIcon") ?? AppPlaceholderImage.frequentFlyer, amentitiesTitle: LocalizedString.RoomService.localized, status: 0), (amenititesImage: UIImage(named: "internetIcon") ?? AppPlaceholderImage.frequentFlyer, amentitiesTitle: LocalizedString.Internet.localized, status: 0), (amenititesImage: UIImage(named: "airConditionerIcon") ?? AppPlaceholderImage.frequentFlyer, amentitiesTitle: LocalizedString.AirConditioner.localized, status: 0), (amenititesImage: UIImage(named: "restaurantBarIcon") ?? AppPlaceholderImage.frequentFlyer, amentitiesTitle: LocalizedString.RestaurantBar.localized, status: 0),(amenititesImage: UIImage(named: "gymIcon") ?? AppPlaceholderImage.frequentFlyer, amentitiesTitle: LocalizedString.Gym.localized, status: 0),(amenititesImage: UIImage(named: "businessIcon") ?? AppPlaceholderImage.frequentFlyer, amentitiesTitle: LocalizedString.BusinessCenter.localized, status: 0),(amenititesImage: UIImage(named: "poolIcon") ?? AppPlaceholderImage.frequentFlyer, amentitiesTitle: LocalizedString.Pool.localized, status: 0),(amenititesImage: UIImage(named: "spaIcon") ?? AppPlaceholderImage.frequentFlyer, amentitiesTitle: LocalizedString.Spa.localized, status: 0)]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doIntitialSetup()
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
