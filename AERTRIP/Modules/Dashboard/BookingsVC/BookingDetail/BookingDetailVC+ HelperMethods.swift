//
//  BookingDetailVC+ HelperMethods.swift
//  AERTRIP
//
//  Created by apple on 10/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension BookingDetailVC {
    
    // get height for Baggage row for first sections
    func getHeightForBaggageInfoRowFirstSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0,6:
            return 44.0
        case 5:
            return 72.0
        default:
            return 34.0
        }
    }
    
    // get height for row for second sections
    func getHeightForBaggageInfoRowSecondSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 44.0
        default:
            return 34.0
        }
    }
    
    // get height For Flight Info For First section
    
    func getHeightForFlightInfoRowFirstSection(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 80.0
        case 1:
            return 150
        case 2:
            return 175.0
        case 3,4,5,6,7,8:
            return UITableView.automaticDimension
        default:
            return 0
        }
        
    }
    
    
    // return cell for Flight Info
    func getCellForFlightInfo(_ indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let flightInfoCell = self.tableView.dequeueReusableCell(withIdentifier: "FlightInfoTableViewCell") as? FlightInfoTableViewCell else {
                fatalError("FlightInfoTableViewCell not found")
            }
            flightInfoCell.configureCell()
            return flightInfoCell
         case 1:
            guard let fligthTimeLocationInfoCell = self.tableView.dequeueReusableCell(withIdentifier: "FlightTimeLocationInfoTableViewCell") as? FlightTimeLocationInfoTableViewCell else {
                fatalError("FlightTimeLocationInfoTableViewCell not found")
            }
            fligthTimeLocationInfoCell.configureCell()
            return fligthTimeLocationInfoCell
            
        case 2:
            guard let bookingTravellerCell = self.tableView.dequeueReusableCell(withIdentifier: "BookingTravellerTableViewCell") as? BookingTravellerTableViewCell else {
                fatalError("BookingTravellerTableViewCell not found")
            }
         
            return bookingTravellerCell
            
        case 3,4,5,6,7,8:
            guard let travellerDetailTableCell = self.tableView.dequeueReusableCell(withIdentifier: "BookingTravellerDetailTableViewCell") as? BookingTravellerDetailTableViewCell else {
                fatalError("BookingTravellerDetailTableViewCell not found")
            }
            travellerDetailTableCell.configureCell()
            return travellerDetailTableCell
    
        default:
            return UITableViewCell()
            
        }
    }
    
    
    func getCellForBaggageInfo(_ indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0,6:
                guard let airlineCell = self.tableView.dequeueReusableCell(withIdentifier: "BaggageAirlineInfoTableViewCell") as? BaggageAirlineInfoTableViewCell else {
                    fatalError("BaggageAirlineInfoTableViewCell not found")
                }
                airlineCell.backgroundColor = .green
                airlineCell.airlineNameLabel.text = "Airline Name"
                airlineCell.airlineCodeLabel.text = "EK-5154・Economy (E)"
                airlineCell.delegate = self
                return airlineCell
            case 1,2,3,4,7,8,9,10:
                guard  let commonCell = self.tableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell", for: indexPath) as? BookingInfoCommonCell else {
                    fatalError("BookingInfoCommonCell not found")
                }
                commonCell.leftLabel.text = "Type"
                commonCell.middleLabel.text = "Check-in"
                commonCell.rightLabel.text = "Cabin"
                return commonCell
            case 5:
                guard let nightStateCell = self.tableView.dequeueReusableCell(withIdentifier: "NightStateTableViewCell") as? NightStateTableViewCell else {
                    fatalError("NightStateTableViewCell not found")
                }
                nightStateCell.configureCell(image: #imageLiteral(resourceName: "overnightIcon"), status: "Overnight Layover in London", time: "8h 59m")
                return nightStateCell
            default:
                return UITableViewCell()
            }
        } else {
            switch indexPath.row  {
            case 0:
                guard let airlineCell = self.tableView.dequeueReusableCell(withIdentifier: "BaggageAirlineInfoTableViewCell") as? BaggageAirlineInfoTableViewCell else {
                    fatalError("BaggageAirlineInfoTableViewCell not found")
                }
                airlineCell.backgroundColor = .red
                airlineCell.airlineNameLabel.text = "Airline Name"
                airlineCell.airlineCodeLabel.text = "EK-5154・Economy (E)"
                airlineCell.delegate = self
                return airlineCell
            case 1,2:
                guard  let commonCell = self.tableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell", for: indexPath) as? BookingInfoCommonCell else {
                    fatalError("BookingInfoCommonCell not found")
                }
                commonCell.leftLabel.text = "Type"
                commonCell.middleLabel.text = "Check-in"
                commonCell.rightLabel.text = "Cabin"
                return commonCell
            default:
                return UITableViewCell()
                
            }
        }
    }
    
    func getCellForFareInfo(_ indexPath: IndexPath) -> UITableViewCell  {
        switch indexPath.row {
        case 0,1,2,3,4,6,7,8,12,13,14: // three type common cell
            guard  let commonCell = self.tableView.dequeueReusableCell(withIdentifier: "BookingInfoCommonCell", for: indexPath) as? BookingInfoCommonCell else {
                fatalError("BookingInfoCommonCell not found")
            }
            commonCell.leftLabel.text = "Type"
            commonCell.middleLabel.text = "Check-in"
            commonCell.rightLabel.text = "Cabin"
            return commonCell
        case 5,9:  // Empty Divider view Cell
            guard let emptyDividerViewCell = self.tableView.dequeueReusableCell(withIdentifier: "EmptyDividerViewCellTableViewCell") as? EmptyDividerViewCellTableViewCell else {
                fatalError("EmptyDividerViewCellTableViewCell not found")
            }
            return emptyDividerViewCell
        case 10:  // Notes point cell
            guard let fareInfoNoteCell = self.tableView.dequeueReusableCell(withIdentifier: "FareInfoNoteTableViewCell") as? FareInfoNoteTableViewCell else {
                fatalError("FareInfoNoteTableViewCell not found")
            }
            fareInfoNoteCell.isForBookingPolicyCell = false
            fareInfoNoteCell.noteLabel.text = LocalizedString.Notes.localized
            fareInfoNoteCell.configCell(notes: ["Hello","Hello","Hello","Hello","Hello","Hello","Hello","Hello"])
            return fareInfoNoteCell
            
        case 11: // Route fare info cell
            guard let routeFareInfoCell = self.tableView.dequeueReusableCell(withIdentifier: "RouteFareInfoTableViewCell") as? RouteFareInfoTableViewCell else {
                fatalError("RouteFareInfoTableViewCell not found")
            }
            routeFareInfoCell.delegate = self
            routeFareInfoCell.configureCell()
            return routeFareInfoCell
            
            
        default:
            return UITableViewCell()
        }
    }
    
    
}
