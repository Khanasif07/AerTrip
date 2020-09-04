//
//  EventTypeVC.swift
//  AERTRIP
//
//  Created by Admin on 15/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol EventTypeVCDelegate: class {
    func didSelectEventTypes(selection: [Int])
}

class EventTypeVC: BaseVC {
    
    //Mark:- Variables
    //================
    // var eventType
    var eventType: [ProductType] = []//ProductType.allCases
    
    var selectedIndexPath: IndexPath?
    var oldSelection: [Int] = []
    weak var delegate: EventTypeVCDelegate?
    
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
        setFilterValues()
    }
    
    override func initialSetup() {
        self.registerNibs()
    }
    
    //Mark:- Functions
    //================
    private func registerNibs() {
        self.eventTypeTableView.registerCell(nibName: AmenitiesTableViewCell.reusableIdentifier)
        self.eventTypeTableView.registerCell(nibName: RoomTableViewCell.reusableIdentifier)
        
    }
    internal func setFilterValues() {
        eventType.removeAll()
        selectedIndexPath = nil
        oldSelection.removeAll()
        oldSelection = MyBookingFilterVM.shared.eventType
        for type in MyBookingFilterVM.shared.bookigEventAvailableType {
            if let product = ProductType(rawValue: type) {
                eventType.append(product)
            }
        }
        self.eventTypeTableView?.reloadData()
    }
}

//Mark:- Extensions
//=================
extension EventTypeVC: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.eventType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AmenitiesTableViewCell.reusableIdentifier) as? AmenitiesTableViewCell else { return UITableViewCell() }
            cell.eventType = eventType[indexPath.row]
            cell.statusButton.isSelected = oldSelection.contains(eventType[indexPath.row].rawValue)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RoomTableViewCell.reusableIdentifier) as? RoomTableViewCell else {
                printDebug("RoomTableViewCell not found")
                return UITableViewCell()
            }
            cell.configCell(title: LocalizedString.ALL.localized)
            cell.dividerView.isHidden = false
            cell.statusButton.isSelected = oldSelection.count == eventType.count
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let idx = oldSelection.firstIndex(of: self.eventType[indexPath.row].rawValue) {
                oldSelection.remove(at: idx)
            } else {
                oldSelection.append(self.eventType[indexPath.row].rawValue)
            }
            
        } else {
            if  oldSelection.count == eventType.count {
                oldSelection.removeAll()
            } else {
                oldSelection.removeAll()
                self.eventType.forEach { (model) in
                    oldSelection.append(model.rawValue)
                }
            }
        }
        self.delegate?.didSelectEventTypes(selection: oldSelection)
        self.eventTypeTableView.reloadData()
    }
}
