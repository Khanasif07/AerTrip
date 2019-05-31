//
//  EventTypeVC.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class EventTypeVC: BaseVC {
    
    //Mark:- Variables
    //================
    
    let rowTitle: [String] = [LocalizedString.flights.localized , LocalizedString.hotels.localized , LocalizedString.Others.localized]
    let rowImages: [UIImage] = [#imageLiteral(resourceName: "flight_blue_icon"),#imageLiteral(resourceName: "hotel_green_icon"),#imageLiteral(resourceName: "others")]
    var selectedIndexPath: IndexPath?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var eventTypeTableView: ATTableView! {
        didSet {
            self.eventTypeTableView.delegate = self
            self.eventTypeTableView.dataSource = self
            self.eventTypeTableView.estimatedRowHeight = UITableView.automaticDimension
            self.eventTypeTableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    //Mark:- LifeCycle
    //================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initialSetup() {
        self.registerNibs()
    }
    
    //Mark:- Functions
    //================
    private func registerNibs() {
        self.eventTypeTableView.registerCell(nibName: AmenitiesTableViewCell.reusableIdentifier)
    }
    
    //Mark:- IBActions
    //================
    
    
    @IBAction func openBookingFlow(_ sender: Any) {
        AppFlowManager.default.moveToBookingDetail()
    }
}

//Mark:- Extensions
//=================
extension EventTypeVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AmenitiesTableViewCell.reusableIdentifier) as? AmenitiesTableViewCell else { return UITableViewCell() }
        cell.amentityTitleLabel.text = self.rowTitle[indexPath.row]
        cell.amenityImageView.image = self.rowImages[indexPath.row]
        if let index = self.selectedIndexPath , index == indexPath {
            cell.statusButton.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
        } else {
            cell.statusButton.setImage(#imageLiteral(resourceName: "untick"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        switch indexPath.row {
        case 0:
            MyBookingFilterVM.shared.eventType = .flight
        case 1:
            MyBookingFilterVM.shared.eventType = .hotel
        case 2:
            MyBookingFilterVM.shared.eventType = .other
        default:
            return
        }
        self.eventTypeTableView.reloadData()
    }
}
