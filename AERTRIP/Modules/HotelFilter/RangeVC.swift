//
//  RangeVC.swift
//  AERTRIP
//
//  Created by apple on 01/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class RangeVC: BaseVC {
    
    
    // MARK: Variables
    var lastSelectedRange: Double = .leastNormalMagnitude
    
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
//        printDebug("index: \((sender as AnyObject).index ?? 0)")
//        printDebug("value: \(value)")
//
        print("-----------------------------------")
        print(value)
        print(lastSelectedRange)
        print("-----------------------------------")
        if value != lastSelectedRange {
            if value >= 1 {
                generateHapticFeedback()
            }
        }
        lastSelectedRange = value == 0 ? 1 : value
        
        var sliderPoint = 13
        if value <= 1 {
            value = 0.5
            sliderPoint = 1
        } else if value > 11 &&   value <= 12 {
           value = 15
            sliderPoint = 12
        } else if value > 12 && value <= 13 {
            value = 20
            sliderPoint = 13
        } else if value > 13 {
            value = 25
            sliderPoint = 14
        }else {
            sliderPoint = Int(value)
//            if value > 10 {
                value = value - 1
//            }
        }
        var setValue = true
        if HotelFilterVM.shared.distanceRange == value {
            setValue = false
        }
        HotelFilterVM.shared.distanceRange =  value
        HotelFilterVM.shared.delegate?.updateFiltersTabs()
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RangeTableViewCell {
            //cell.stepSlider?.index = UInt(sliderPoint)
            cell.stepSlider?.enableHapticFeedback = false
            cell.stepSlider?.setIndex(UInt(sliderPoint), animated: false)
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
        var value = 13
        if range == 25 {
            value = 14
        }else if range == 20 {
            value = 13
        } else if range == 15 {
            value = 12
        }else if range == 0.5 {
            value = 1
        } else {
            value = Int(range + 1)
        }
        cell.stepSlider?.enableHapticFeedback = false//HotelFilterVM.shared.distanceRange != 0.5
        cell.stepSlider?.index = UInt(value) //UInt(value.toInt)
        cell.updateSliderValueOnLabel(range: range)
        return cell
    }
    
    private func generateHapticFeedback() {
        print("feedback generated")
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.selectionChanged()
    }
    
}



