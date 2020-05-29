//
//  RangeVC.swift
//  AERTRIP
//
//  Created by apple on 01/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class RangeVC: BaseVC {
    // MARK: - IB Outlets
    @IBOutlet weak var tableView: ATTableView!
    
    
    // MARK: - View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doInitialSetup()
        //self.setFilterValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFilterValues()
    }
    // MARK: - Override methods
    
    private func doInitialSetup() {
        registerXib()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func registerXib() {
        tableView.registerCell(nibName: RangeTableViewCell.reusableIdentifier)
    }
    
    func setFilterValues() {
        //        let filter = UserInfo.hotelFilter
        //        let range = filter?.distanceRange ?? HotelFilterVM.shared.distanceRange
        //        self.stepSlider?.index = UInt(range.toInt)
        //        self.rangeLabel?.text = range.toInt >= 20 ? "Beyond \(range.toInt)km" : "Within " + "\((range.toInt))" + "km"
        tableView?.reloadData()
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        //        let value = (sender as AnyObject).index ?? 0
        // self.rangeLabel.text = value >= 20 ? "Beyond \(value)km" : "Within " + "\(value)" + "km"
        var value = Double((sender as AnyObject).index ?? 0)
        if value < 1 {
            value = 1
        }
        HotelFilterVM.shared.distanceRange =  value
        HotelFilterVM.shared.delegate?.updateFiltersTabs()
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RangeTableViewCell {
            cell.stepSlider?.index = UInt(value.toInt)
            cell.updateSliderValueOnLabel(range: value)
        } else {
            tableView?.reloadData()
        }
    }
}

// MARK: - UITableViewCellDataSource and UITableViewCellDelegateMethods

extension RangeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RangeTableViewCell.reusableIdentifier, for: indexPath) as? RangeTableViewCell else {
            return UITableViewCell()
        }
        cell.stepSlider?.removeTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        cell.stepSlider?.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        let filter = UserInfo.hotelFilter
        let range = filter?.distanceRange ?? HotelFilterVM.shared.distanceRange
        cell.stepSlider?.index = UInt(range.toInt)
        cell.updateSliderValueOnLabel(range: range)
        return cell
    }
    
}



