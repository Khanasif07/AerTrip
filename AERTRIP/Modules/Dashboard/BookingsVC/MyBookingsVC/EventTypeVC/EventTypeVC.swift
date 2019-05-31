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
    
    // var eventType
    let eventType: [ProductType] = ProductType.allCases
    
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
        return self.eventType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AmenitiesTableViewCell.reusableIdentifier) as? AmenitiesTableViewCell else { return UITableViewCell() }
        cell.eventType = eventType[indexPath.row]
        cell.statusButton.isSelected = MyBookingFilterVM.shared.eventType.contains(eventType[indexPath.row].rawValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if MyBookingFilterVM.shared.eventType.contains(eventType[indexPath.row].rawValue) {
           MyBookingFilterVM.shared.eventType.remove(at: MyBookingFilterVM.shared.eventType.firstIndex(of: self.eventType[indexPath.row].rawValue)!)
        } else {
            MyBookingFilterVM.shared.eventType.append(self.eventType[indexPath.row].rawValue)
        }
        self.eventTypeTableView.reloadData()
    }
}
