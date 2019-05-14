//
//  BookingDetailVC+Extensions.swift
//  AERTRIP
//
//  Created by apple on 09/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit


extension BookingDetailVC : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 11
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let airlineCell = self.tableView.dequeueReusableCell(withIdentifier: "BaggageAirlineInfoTableViewCell") as? BaggageAirlineInfoTableViewCell else {
            fatalError("BaggageAirlineInfoTableViewCell not found")
        }
        guard  let commonCell = self.tableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell", for: indexPath) as? BookingInfoCommonCell else {
            fatalError("BookingInfoCommonCell not found")
        }
        
        guard let nightStateCell = self.tableView.dequeueReusableCell(withIdentifier: "NightStateTableViewCell") as? NightStateTableViewCell else {
                            fatalError("NightStateTableViewCell not found")
                        }
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
               
                airlineCell.airlineNameLabel.text = "Airline Name"
                airlineCell.airlineCodeLabel.text = "EK-5154・Economy (E)"
                return airlineCell
            case 1:
                commonCell.leftLabel.text = "Type"
                commonCell.middleLabel.text = "Check-in"
                commonCell.rightLabel.text = "Cabin"
                return commonCell
            case 2:
                commonCell.isForPassenger = true
                commonCell.leftLabel.text = "Per Adult"
                commonCell.middleLabel.text = "2 x 23 kgs"
                commonCell.rightLabel.text = "2 x 23 kgs "
                return commonCell
            case 3:
                commonCell.isForPassenger = true
                commonCell.leftLabel.text = "Per Child"
                commonCell.middleLabel.text = "1 x 7 kgs"
                commonCell.rightLabel.text = "1 x 7 kgs"
                return commonCell
            case 4:
                commonCell.isForPassenger = true
                commonCell.leftLabel.text = "Per Infant"
                commonCell.middleLabel.text = "1 x 7 kgs"
                commonCell.rightLabel.text = "1 x 7 kgs"
                return commonCell
            case 5:
                return nightStateCell
            case 6:
                airlineCell.airlineNameLabel.text = "Airline Name"
                airlineCell.airlineCodeLabel.text = "EK-5154・Economy (E)"
                return airlineCell
            case 7:
                commonCell.leftLabel.text = "Type"
                commonCell.middleLabel.text = "Check-in"
                commonCell.rightLabel.text = "Cabin"
                return commonCell
            case 8:
                commonCell.isForPassenger = true
                commonCell.leftLabel.text = "Per Adult"
                commonCell.middleLabel.text = "1 x 7 kgs"
                commonCell.rightLabel.text = "1 x 7 kgs"
                return commonCell
            case 9:
                commonCell.isForPassenger = true
                commonCell.leftLabel.text = "Per Child"
                commonCell.middleLabel.text = "1 x 7 kgs"
                commonCell.rightLabel.text = "1 x 7 kgs"
                return commonCell
            case 10:
                commonCell.isForPassenger = true
                commonCell.leftLabel.text = "Per Child"
                commonCell.middleLabel.text = "1 x 7 kgs"
                commonCell.rightLabel.text = "1 x 7 kgs"
                return commonCell
            default:
                return UITableViewCell()
            }
        } else {
            switch indexPath.row  {
            case 0:
                airlineCell.airlineNameLabel.text = "Airline Name"
                airlineCell.airlineCodeLabel.text = "EK-5154・Economy (E)"
                airlineCell.delegate = self
                return airlineCell
            case 1:
                commonCell.leftLabel.text = "Type"
                commonCell.middleLabel.text = "Check-in"
                commonCell.rightLabel.text = "Cabin"
                return commonCell
            case 2:
                commonCell.leftLabel.text = "Type"
                commonCell.middleLabel.text = "Check-in"
                commonCell.rightLabel.text = "Cabin"
                return commonCell
            default:
                return UITableViewCell()

            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.getHeightForRowFirstSection(indexPath)
        } else {
            return self.getHeightForRowSecondSection(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerViewIdentifier) as? BookingInfoHeaderView else { return nil }
        headerView.tripRougteLabel.text = "DEL" + LocalizedString.ForwardArrow.localized + "BEL"
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.footerViewIdentifier) as? BookingInfoEmptyFooterView else {
            fatalError("BookingInfoFooterView not found")
        }
        return footerView
    }
    
    
    
    

    
}
