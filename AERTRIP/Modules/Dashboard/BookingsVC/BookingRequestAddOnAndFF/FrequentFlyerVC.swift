//
//  FrequentFlyerVC.swift
//  AERTRIP
//
//  Created by apple on 21/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FrequentFlyerVC: BaseVC {
    // MARK: - IBOutlet
    
    @IBOutlet weak var frequentFlyerTableView: ATTableView!
    
    // MARK: - Variables
    
    let footerViewIdentifier = "BookingInfoEmptyFooterView"
    let headerViewIdentifier = "BookingFrequentFlyerHeaderView"
    
    var delegate:BookingRequestAddOnsFFVCTextfiledDelegate?
    
    override func initialSetup() {
        registerXib()
        frequentFlyerTableView.dataSource = self
        frequentFlyerTableView.delegate = self
        frequentFlyerTableView.reloadData()
        self.frequentFlyerTableView.backgroundColor = AppColors.themeGray04
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        frequentFlyerTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        frequentFlyerTableView.reloadData()
    }
    
    // MARK: Helper methods
    
    func registerXib() {
        frequentFlyerTableView.register(UINib(nibName: footerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: footerViewIdentifier)
        frequentFlyerTableView.register(UINib(nibName: headerViewIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: headerViewIdentifier)
        frequentFlyerTableView.registerCell(nibName: BookingFFMealTableViewCell.reusableIdentifier)
        frequentFlyerTableView.registerCell(nibName: BookingFFAirlineTableViewCell.reusableIdentifier)
    }
    
    func getCellForSection(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0, 1:
            guard let arilineCell = self.frequentFlyerTableView.dequeueReusableCell(withIdentifier: "BookingFFAirlineTableViewCell") as? BookingFFAirlineTableViewCell else {
                fatalError("BookingFFAirlineTableViewCell not found")
            }
            return arilineCell
        default:
            return UITableViewCell()
        }
    }
}

extension FrequentFlyerVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData[section].flights.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let arilineCell = self.frequentFlyerTableView.dequeueReusableCell(withIdentifier: "BookingFFAirlineTableViewCell") as? BookingFFAirlineTableViewCell else {
            fatalError("BookingFFAirlineTableViewCell not found")
        }
        
        arilineCell.flightData = BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData[indexPath.section].flights[indexPath.row]
        arilineCell.leftDividerView.isHidden = indexPath.row == (BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData[indexPath.section].flights.count ?? 0) - 1
        arilineCell.rightDividerView.isHidden = indexPath.row == (BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData[indexPath.section].flights.count ?? 0) - 1
        arilineCell.contentView.backgroundColor = AppColors.themeBlack26
        arilineCell.delegate = self
        return arilineCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 76.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = frequentFlyerTableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? BookingFrequentFlyerHeaderView else {
            fatalError(" BookingFrequentFlyerHeaderView not  found")
        }
        
        guard let passenger = BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData[section].passenger else {
            printDebug("passenger not found")
            return UIView()
        }
        
        var age = ""
        let dob = passenger.dob
        if !dob.isEmpty {
            age = AppGlobals.shared.getAgeLastString(dob: dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
        }
        headerView.configureCell(profileImage: passenger.profileImage, salutationImage: AppGlobals.shared.getEmojiIcon(dob: dob, salutation: passenger.salutation, dateFormatter: Date.DateFormat.yyyy_MM_dd.rawValue), passengerName: passenger.paxName, age: age)
        headerView.containerView.backgroundColor = AppColors.themeBlack26
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = self.frequentFlyerTableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerViewIdentifier) as? BookingInfoEmptyFooterView else {
            fatalError("BookingInfoFooterView not found")
        }
        let totalSection = BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData.count ?? 0
        footerView.bottomDividerView.isHidden = (totalSection - 1) == section
        return footerView
    }
}

// MARK: -  BookingAirlineTableViewCell Delgate methods

extension FrequentFlyerVC: BookingFFAirlineTableViewCellDelegate {
    func textFieldText(_ textField: UITextField) {
        guard let indexPath = self.frequentFlyerTableView.indexPath(forItem: textField) else {
            printDebug("indexPath not found")
            return
        }
        BookingRequestAddOnsFFVM.shared.bookingDetails?.frequentFlyerData[indexPath.section].flights[indexPath.row].frequentFlyerNumber = textField.text ?? ""
        
        self.delegate?.closeKeyboard()

    }
}
